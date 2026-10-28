package com.xiaopeng.qa.camera;

import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Canvas;
import android.graphics.ImageFormat;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.SurfaceTexture;
import android.hardware.Camera;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.TextureView;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.lang.reflect.Method;
import java.util.List;

/**
 * Camera1（旧版 Camera API）预览通路。
 *
 * 原厂 360 程序在 820A 车机上并不使用 Camera2，而是：
 *   Camera.open(2) -> 1280x720 / NV21 -> Camera.Parameters 里的 display-mode 选择视角
 * 本类复刻这一通路，供悬浮窗直接显示单侧摄像头画面。
 *
 * 所有 Xpeng 私有方法（setAvmDisplayMode / setCmdControlParameters 等）均通过反射调用，
 * 因此在标准 API 28 上可以编译，在缺少私有接口的设备上会安全降级。
 */
public final class Camera1Preview {

    private static final String TAG = "CameraAssist";

    /** 原厂在 820A 上使用的 AVM 摄像头号，其余作为兜底。 */
    private static final int[] CANDIDATE_IDS = {2, 0, 1, 3, 4, 5, 6, 7};

    /** 打灯联动候选视角：8=四路拼接（左下/右下象限即左右鱼眼原图），失败再退回 2D 单视图。 */
    private static final int[] MODES_LEFT = {8};
    private static final int[] MODES_RIGHT = {8};
    private static final int[] MODES_MANUAL = {22};  // 22=3D环视

    private static final Handler MAIN = new Handler(Looper.getMainLooper());

    private static Context sContext;
    private static Camera sCamera;
    private static int sCameraId = -1;
    private static TextureView sTextureView;
    private static String sDirection;
    private static int sWidth = 1280;
    private static int sHeight = 720;
    private static boolean sPreviewing;
    private static int sRetry;
    private static int[] sModes = MODES_LEFT;
    private static int sOpenRetries;
    private static Method sServiceLogMethod;

    private static final boolean DEBUG_LOG = false;

    private Camera1Preview() {
    }

    /** 供 smali 调用：打开（或复用）Camera1 预览。返回 true 表示已接管，false 表示应回退到 Camera2。 */
    public static boolean open(Context context, TextureView textureView, String direction) {
        sOpenRetries = 0;
        sContext = context;
        sDirection = direction;
        if (sCamera != null && sTextureView != textureView) {
            // 浮窗被重建（纹理变化）：先释放旧会话，避免新画面仍画到旧的 SurfaceTexture
            log("Camera1: 浮窗纹理变化，释放旧会话");
            release();
        }
        if (sCamera == null) {
            sTextureView = textureView;
            // 新会话：先隐藏浮窗，等第一帧就绪再淡入显示
            setRootVisible(false);
            log("Camera1: 开始打开摄像头（浮窗隐藏，画面就绪后显示）");
        }
        return openInternal(context, textureView, direction);
    }

    private static boolean openInternal(Context context, TextureView textureView, String direction) {
        log("Camera1: open() 进入 dir=" + direction + " tv=" + textureView + " active=" + (sCamera != null));
        if (context == null || textureView == null) {
            log("Camera1: 上下文或 TextureView 为空，跳过");
            setRootVisible(true);
            return false;
        }
        if (context.checkSelfPermission("android.permission.CAMERA")
                != PackageManager.PERMISSION_GRANTED) {
            log("Camera1: 无相机权限，跳过");
            setRootVisible(true);
            return false;
        }
        if (SignalGate.factoryActiveNow()) {
            // 原厂 360/窄道全景正在用 2 号摄像头：不要打开、更不要下发视角，否则会把原厂画面切成后视/四宫格
            log("Camera1: 原厂 360/窄道全景占用中，取消本次预览");
            SignalGate.requestHide("原厂全景占用中，取消本程序浮窗");
            return true;
        }
        sDirection = direction;
        int[] modes = modesFor(context, direction);
        if (sCamera != null && sTextureView == textureView) {
            sModes = modes;
            log("Camera1: 复用摄像头 id=" + sCameraId + "，切换视角 display-mode=" + sModes[0]);
            applyCurrentMode(false);
            if (!sPreviewing) {
                startPreviewWhenReady();
            }
            return true;
        }
        release();
        sTextureView = textureView;
        applyRoundedCorners(textureView);
        logEnvironment(context);
        log("Camera1: 开始枚举摄像头，厂商 setCmdControlParameters=" + hasMethod(Camera.class, "setCmdControlParameters")
                + " getCmdControlParameters=" + hasMethod(Camera.class, "getCmdControlParameters"));
        int idOverride = readIntFile(context, "id.txt", -1);
        if (idOverride >= 0) {
            log("Camera1: 使用外部指定摄像头 id=" + idOverride);
            try {
                sCamera = Camera.open(idOverride);
                sCameraId = idOverride;
            } catch (Throwable t) {
                log("Camera1: 指定摄像头打开失败 id=" + idOverride + " -> " + t);
            }
        } else {
            for (int id : CANDIDATE_IDS) {
                try {
                    Camera camera = Camera.open(id);
                    if (camera == null) {
                        continue;
                    }
                    sCamera = camera;
                    sCameraId = id;
                    log("Camera1: 打开成功 id=" + id);
                    break;
                } catch (Throwable t) {
                    log("Camera1: 打开失败 id=" + id + " -> " + t);
                }
            }
        }
        if (sCamera == null) {
            log("Camera1: 所有候选摄像头均打开失败（可能被原厂 360/行车记录占用）");
            scheduleReopen(context, textureView, direction);
            return false;
        }
        installErrorCallback(sCamera);
        sModes = modes;
        sOpenRetries = 0;
        configure(sCamera, direction);
        applyCurrentMode(true);
        startPreviewWhenReady();
        log("Camera1: open() 完成，已接管（id=" + sCameraId + "）");
        return true;
    }

    /** 当前是否由 Camera1 接管。 */
    public static boolean isActive() {
        return sCamera != null;
    }

    /** 释放摄像头（幂等）。
     *  注意：不再向 HAL 下发“恢复原厂视角”。实测当原厂 360 也在用 2 号摄像头时，
     *  我们作为第二个客户端下发的任何 display-mode 都会被 HAL 翻成 17（后视），
     *  反而把原厂画面顶掉；原厂自己打开时会重新下发它的视角，所以这里只做关闭。 */
    public static void release() {
        setRootVisible(true);
        final Camera camera = sCamera;
        if (camera == null) {
            sCameraId = -1;
            sPreviewing = false;
            sTextureView = null;
            sContext = null;
            return;
        }
        log("Camera1: 释放摄像头 id=" + sCameraId);
        sCamera = null;
        sCameraId = -1;
        sPreviewing = false;
        sTextureView = null;
        sContext = null;
        closeCamera(camera);
    }

    private static void closeCamera(Camera camera) {
        try {
            camera.stopPreview();
        } catch (Throwable ignored) {
        }
        try {
            camera.setPreviewTexture(null);
        } catch (Throwable ignored) {
        }
        try {
            camera.setPreviewCallback(null);
        } catch (Throwable ignored) {
        }
        try {
            camera.release();
        } catch (Throwable ignored) {
        }
    }

    /** 摄像头被 HAL 断开/被原厂抢占时，释放并自动重试，避免留下僵死会话。 */
    private static void installErrorCallback(final Camera camera) {
        try {
            camera.setErrorCallback(new Camera.ErrorCallback() {
                @Override
                public void onError(int error, Camera cam) {
                    final TextureView tv = sTextureView;
                    final String dir = sDirection;
                    final Context ctx = sContext;
                    log("Camera1: 摄像头错误 error=" + error + "，释放后自动重试");
                    MAIN.post(new Runnable() {
                        @Override
                        public void run() {
                            if (cam != sCamera) {
                                return;
                            }
                            release();
                            if (tv != null && ctx != null) {
                                sTextureView = tv;
                                sContext = ctx;
                                scheduleReopen(ctx, tv, dir);
                            }
                        }
                    });
                }
            });
        } catch (Throwable t) {
            log("Camera1: 注册错误回调失败: " + t);
        }
    }

    private static int[] modesFor(Context context, String direction) {
        int override = readModeOverride(context);
        if (override > 0) {
            log("Camera1: 使用外部配置视角 display-mode=" + override);
            return new int[]{override};
        }
        if ("RIGHT".equals(direction)) {
            return MODES_RIGHT;
        }
        if ("MANUAL".equals(direction)) {
            return MODES_MANUAL;
        }
        return MODES_LEFT;
    }

    /** 支持用 adb 写文件临时改视角，便于不改包测试：
     *  echo 18 > /sdcard/Android/data/com.xiaopeng.qa.camera/files/mode.txt */
    private static int readModeOverride(Context context) {
        try {
            File dir = context.getExternalFilesDir(null);
            if (dir != null) {
                int value = readInt(new File(dir, "mode.txt"));
                if (value > 0) {
                    return value;
                }
            }
        } catch (Throwable ignored) {
        }
        return 0;
    }

    private static int readInt(File file) {
        if (file == null || !file.exists()) {
            return 0;
        }
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new FileReader(file));
            String line = reader.readLine();
            if (line == null) {
                return 0;
            }
            return Integer.parseInt(line.trim());
        } catch (Throwable ignored) {
            return 0;
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (Throwable ignored) {
                }
            }
        }
    }

    /** 读取外部文件里的整数（用于临时指定摄像头 id）。 */
    private static int readIntFile(Context context, String name, int def) {
        try {
            File dir = context.getExternalFilesDir(null);
            if (dir == null) {
                return def;
            }
            File file = new File(dir, name);
            if (!file.exists()) {
                return def;
            }
            BufferedReader reader = new BufferedReader(new FileReader(file));
            String line = reader.readLine();
            reader.close();
            if (line == null) {
                return def;
            }
            return Integer.parseInt(line.trim());
        } catch (Throwable ignored) {
            return def;
        }
    }

    /** 摄像头被占用时，间隔 1 秒重试最多 3 次（原厂 360/记录仪可能短暂占用 2 号摄像头）。 */
    private static void scheduleReopen(final Context context, final TextureView textureView, final String direction) {
        if (sOpenRetries >= 3) {
            // 重试用尽仍打不开：把浮窗显示出来（黑屏）并提示，避免留下一个看不见的窗口
            setRootVisible(true);
            try {
                Toast.makeText(context, "摄像头被原厂全景占用，暂时无法显示", Toast.LENGTH_SHORT).show();
            } catch (Throwable ignored) {
            }
            return;
        }
        sOpenRetries++;
        final int attempt = sOpenRetries;
        MAIN.postDelayed(new Runnable() {
            @Override
            public void run() {
                if (sCamera != null || sTextureView != textureView || textureView == null) {
                    return;
                }
                log("Camera1: 第 " + attempt + " 次重试打开摄像头");
                openInternal(context, textureView, direction);
            }
        }, 1000L);
    }

    private static void configure(Camera camera, String direction) {
        try {
            Camera.Parameters parameters = camera.getParameters();
            if (parameters == null) {
                log("Camera1: getParameters() 返回 null");
                return;
            }
            List<Camera.Size> sizes = parameters.getSupportedPreviewSizes();
            int width = 0;
            int height = 0;
            if (sizes != null && !sizes.isEmpty()) {
                Camera.Size best = null;
                int bestScore = Integer.MAX_VALUE;
                for (Camera.Size size : sizes) {
                    if (size.width == 1280 && size.height == 720) {
                        best = size;
                        bestScore = 0;
                        break;
                    }
                    int score = Math.abs(size.width - 1280) + Math.abs(size.height - 720);
                    if (size.width * 9 == size.height * 16) {
                        score -= 400; // 优先 16:9
                    }
                    if (score < bestScore) {
                        bestScore = score;
                        best = size;
                    }
                }
                if (best != null) {
                    width = best.width;
                    height = best.height;
                }
            }
            if (width <= 0 || height <= 0) {
                width = 1280;
                height = 720;
            }
            sWidth = width;
            sHeight = height;
            try {
                parameters.setPreviewSize(width, height);
                parameters.setPreviewFormat(ImageFormat.NV21);
            } catch (Throwable t) {
                log("Camera1: 设置预览尺寸/格式失败: " + t);
            }
            try {
                Camera.CameraInfo info = new Camera.CameraInfo();
                Camera.getCameraInfo(sCameraId, info);
                log("Camera1: 参数 id=" + sCameraId + " size=" + width + "x" + height
                        + " orientation=" + info.orientation + " facing=" + info.facing);
            } catch (Throwable ignored) {
            }
            log("Camera1: 支持尺寸=" + describeSizes(sizes));
            log("Camera1: 支持格式=" + parameters.getSupportedPreviewFormats());
            camera.setParameters(parameters);
        } catch (Throwable t) {
            log("Camera1: 配置异常: " + t);
        }
    }

    private static void applyCurrentMode(boolean initial) {
        if (sCamera == null || sModes == null || sModes.length == 0) {
            return;
        }
        int mode = sModes[0];
        applyMode(sCamera, mode, initial);
    }

    /** 浮窗整体显示/隐藏：等画面就绪后再显示，避免出现“空窗口”。
     *  用透明度而不是 INVISIBLE，保证 TextureView 的 SurfaceTexture 仍然正常创建；
     *  隐藏期间加上 FLAG_NOT_TOUCHABLE，避免透明窗口拦截点击。 */
    private static void setRootVisible(boolean visible) {
        try {
            TextureView view = sTextureView;
            if (view == null) {
                return;
            }
            final View root = view.getRootView();
            if (root == null) {
                return;
            }
            setWindowTouchable(root, visible);
            if (visible) {
                if (root.getAlpha() < 1.0f) {
                    root.animate().alpha(1.0f).setDuration(120L).start();
                } else {
                    root.setAlpha(1.0f);
                }
            } else {
                root.animate().cancel();
                root.setAlpha(0.0f);
            }
        } catch (Throwable ignored) {
        }
    }

    private static void setWindowTouchable(View root, boolean touchable) {
        try {
            android.view.ViewGroup.LayoutParams params = root.getLayoutParams();
            if (!(params instanceof android.view.WindowManager.LayoutParams)) {
                return;
            }
            android.view.WindowManager.LayoutParams lp =
                    (android.view.WindowManager.LayoutParams) params;
            int flag = android.view.WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE;
            if (touchable) {
                lp.flags &= ~flag;
            } else {
                lp.flags |= flag;
            }
            android.view.WindowManager wm = (android.view.WindowManager)
                    root.getContext().getSystemService(Context.WINDOW_SERVICE);
            if (wm != null) {
                wm.updateViewLayout(root, lp);
            }
        } catch (Throwable ignored) {
        }
    }

    private static int dp(Context context, int value) {
        return (int) (value * context.getResources().getDisplayMetrics().density + 0.5f);
    }

    /** 侧视浮窗也做成圆角：纹理自身 outline 裁剪 + 四角遮罩（兼容 TextureView 不跟随 outline 裁剪的情况）。 */
    private static void applyRoundedCorners(TextureView tv) {
        try {
            if (tv == null) {
                return;
            }
            final float radius = dp(tv.getContext(), 24);
            // 对整个浮窗（含视频子 View）做圆角裁剪，和流媒体后视镜同一套做法
            View parent = (View) tv.getParent();
            View clip = parent != null ? parent : tv;
            clip.setOutlineProvider(new android.view.ViewOutlineProvider() {
                @Override
                public void getOutline(View view, android.graphics.Outline outline) {
                    outline.setRoundRect(0, 0, view.getWidth(), view.getHeight(), radius);
                }
            });
            clip.setClipToOutline(true);
            tv.setOutlineProvider(new android.view.ViewOutlineProvider() {
                @Override
                public void getOutline(View view, android.graphics.Outline outline) {
                    outline.setRoundRect(0, 0, view.getWidth(), view.getHeight(), radius);
                }
            });
            tv.setClipToOutline(true);
        } catch (Throwable ignored) {
        }
    }

    /** 只在四个圆角外绘制面板色，把直角画面“盖”成圆角。 */
    static final class CornerMask extends View {
        private final float radius;
        private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);
        private final Path path = new Path();

        CornerMask(Context context, float radius, int color) {
            super(context);
            this.radius = radius;
            paint.setColor(color);
            // 关键：纯自定义绘制的 View 默认可能被标记为不绘制
            setWillNotDraw(false);
        }

        @Override
        protected void onDraw(Canvas canvas) {
            int w = getWidth();
            int h = getHeight();
            if (w <= 0 || h <= 0) {
                return;
            }
            path.reset();
            path.addRect(0, 0, w, h, Path.Direction.CW);
            Path inner = new Path();
            inner.addRoundRect(0, 0, w, h, radius, radius, Path.Direction.CW);
            path.op(inner, Path.Op.DIFFERENCE);
            canvas.drawPath(path, paint);
        }
    }

    private static void applyMode(Camera camera, int mode, boolean initial) {
        try {
            if (sCameraId != 2) {
                log("Camera1: 物理摄像头 id=" + sCameraId + "，不设置 AVM 视角");
                return;
            }
            if (SignalGate.factoryActiveNow()) {
                log("Camera1: 原厂 360/窄道全景占用中，跳过视角下发 display-mode=" + mode);
                return;
            }
            Camera.Parameters parameters = camera.getParameters();
            if (parameters == null) {
                return;
            }
            boolean viaVendor = false;
            try {
                Method m = parameters.getClass().getMethod("setAvmDisplayMode", Integer.TYPE);
                m.invoke(parameters, Integer.valueOf(mode));
                viaVendor = true;
            } catch (Throwable t) {
                try {
                    parameters.set("display-mode", String.valueOf(mode));
                } catch (Throwable ignored) {
                }
            }
            try {
                parameters.getClass().getMethod("setAvmOverlayWorkSt", Integer.TYPE)
                        .invoke(parameters, Integer.valueOf(255));
            } catch (Throwable ignored) {
            }
            try {
                parameters.getClass().getMethod("setAvmOutMode", Integer.TYPE)
                        .invoke(parameters, Integer.valueOf(0));
            } catch (Throwable ignored) {
            }
            try {
                parameters.getClass().getMethod("setAvmCalibration", Integer.TYPE)
                        .invoke(parameters, Integer.valueOf(0));
            } catch (Throwable ignored) {
            }
            if (initial || !sPreviewing) {
                camera.setParameters(parameters);
            }
            boolean sent = sendCmdControl(camera, parameters);
            log("Camera1: display-mode=" + mode + " vendorSet=" + viaVendor
                    + " setCmdControlParameters=" + sent);
            if (!sent && !initial) {
                boolean wasPreviewing = sPreviewing;
                if (wasPreviewing) {
                    try {
                        camera.stopPreview();
                    } catch (Throwable ignored) {
                    }
                    sPreviewing = false;
                }
                camera.setParameters(parameters);
                if (wasPreviewing) {
                    startPreviewWhenReady();
                }
            }
        } catch (Throwable t) {
            log("Camera1: 设置视角异常: " + t);
        }
    }

    private static boolean sendCmdControl(Camera camera, Camera.Parameters parameters) {
        try {
            Method target = null;
            for (Method method : camera.getClass().getMethods()) {
                if ("setCmdControlParameters".equals(method.getName())
                        && method.getParameterTypes().length == 1
                        && method.getParameterTypes()[0].isInstance(parameters)) {
                    target = method;
                    break;
                }
            }
            if (target == null) {
                return false;
            }
            target.invoke(camera, parameters);
            return true;
        } catch (Throwable t) {
            log("Camera1: setCmdControlParameters 失败: " + t);
            return false;
        }
    }

    private static void startPreviewWhenReady() {
        sRetry = 0;
        MAIN.post(new Runnable() {
            @Override
            public void run() {
                if (sCamera == null) {
                    return;
                }
                SurfaceTexture surfaceTexture = sTextureView == null ? null : sTextureView.getSurfaceTexture();
                if (surfaceTexture == null) {
                    if (sRetry++ < 60) {
                        MAIN.postDelayed(this, 50);
                    } else {
                        log("Camera1: 等待 SurfaceTexture 超时（约3秒）");
                        setRootVisible(true);
                    }
                    return;
                }
                try {
                    surfaceTexture.setDefaultBufferSize(sWidth, sHeight);
                    sCamera.setPreviewTexture(surfaceTexture);
                    sCamera.startPreview();
                    sPreviewing = true;
                    try {
                        Camera.Size actual = sCamera.getParameters().getPreviewSize();
                        log("Camera1: 预览已启动 " + actual.width + "x" + actual.height
                                + " id=" + sCameraId + " dir=" + sDirection);
                    } catch (Throwable t) {
                        log("Camera1: 预览已启动 " + sWidth + "x" + sHeight + " id=" + sCameraId
                                + " dir=" + sDirection);
                    }
                    // 第一帧开始渲染后再显示浮窗，做到窗口和画面同步出现
                    MAIN.postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            setRootVisible(true);
                        }
                    }, 80L);
                } catch (Throwable t) {
                    sPreviewing = false;
                    if (sRetry++ < 60) {
                        MAIN.postDelayed(this, 50);
                    } else {
                        log("Camera1: 启动预览失败: " + t);
                        // 预览始终起不来：把浮窗显示出来，避免留下一个看不见的窗口
                        setRootVisible(true);
                    }
                }
            }
        });
    }

    /** 首次打开后若 1.5 秒内没有帧，自动尝试下一个候选视角。 */
    private static void logEnvironment(Context context) {
        try {
            log("环境: SDK=" + android.os.Build.VERSION.SDK_INT
                    + " DEVICE=" + android.os.Build.DEVICE
                    + " MODEL=" + android.os.Build.MODEL);
        } catch (Throwable ignored) {
        }
        try {
            int count = Camera.getNumberOfCameras();
            log("Camera1: getNumberOfCameras()=" + count);
            for (int i = 0; i < count; i++) {
                try {
                    Camera.CameraInfo info = new Camera.CameraInfo();
                    Camera.getCameraInfo(i, info);
                    log("Camera1: 系统摄像头 index=" + i + " facing=" + info.facing
                            + " orientation=" + info.orientation);
                } catch (Throwable t) {
                    log("Camera1: getCameraInfo(" + i + ") 失败: " + t);
                }
            }
        } catch (Throwable t) {
            log("Camera1: getNumberOfCameras 失败: " + t);
        }
        try {
            android.hardware.camera2.CameraManager manager =
                    (android.hardware.camera2.CameraManager) context.getSystemService(Context.CAMERA_SERVICE);
            if (manager != null) {
                String[] ids = manager.getCameraIdList();
                log("Camera2: getCameraIdList()=" + (ids == null ? 0 : ids.length)
                        + (ids == null ? "" : " " + describeIds(ids)));
            }
        } catch (Throwable t) {
            log("Camera2: getCameraIdList 失败: " + t);
        }
    }

    private static String describeIds(String[] ids) {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < ids.length && i < 20; i++) {
            if (i > 0) {
                builder.append(',');
            }
            builder.append(ids[i]);
        }
        return builder.toString();
    }

    private static boolean hasMethod(Class<?> cls, String name) {
        try {
            for (Method method : cls.getMethods()) {
                if (name.equals(method.getName())) {
                    return true;
                }
            }
        } catch (Throwable ignored) {
        }
        return false;
    }

    private static String describeSizes(List<Camera.Size> sizes) {
        if (sizes == null || sizes.isEmpty()) {
            return "无";
        }
        StringBuilder builder = new StringBuilder();
        int count = Math.min(sizes.size(), 12);
        for (int i = 0; i < count; i++) {
            if (i > 0) {
                builder.append(',');
            }
            builder.append(sizes.get(i).width).append('x').append(sizes.get(i).height);
        }
        if (sizes.size() > count) {
            builder.append("...共").append(sizes.size()).append("项");
        }
        return builder.toString();
    }

    private static void log(String message) {
        if (!DEBUG_LOG) {
            return;
        }
        try {
            Method method = sServiceLogMethod;
            if (method == null) {
                Class<?> cls = Class.forName("com.xiaopeng.qa.camera.CameraOverlayService");
                method = cls.getMethod("serviceLog", String.class);
                sServiceLogMethod = method;
            }
            method.invoke(null, message);
        } catch (Throwable t) {
            Log.i(TAG, message);
        }
    }
}
