package com.xiaopeng.qa.camera;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.PixelFormat;
import android.hardware.Camera;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.TextureView;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

import java.lang.reflect.Method;

/**
 * 流媒体后视镜浮窗：
 *  - 独立窗口，使用后视摄像头（默认 id=0），不修改 AVM 的 display-mode，
 *    因此不会和左右打灯浮窗（2 号 AVM 摄像头）、原厂 360 互相抢视角；
 *  - 默认居中、宽扁比例（约 2.4:1），只显示画面偏上部分（后视镜视角）；
 *  - 单指拖动移动窗口，双击进入编辑模式：单指平移画面、双指缩放、拖动黄色边缘调整窗口大小，
 *    再次双击退出并保存；
 *  - 开关状态与几何参数保存在 SharedPreferences（rear_ 前缀）。
 */
public final class RearMirror {

    private static final String PREFS = "cameraassist";
    private static final String TAG = "CameraAssist";

    public static final String KEY_ENABLED = "rear_mirror_enabled";
    private static final String KEY_W = "rear_w";
    private static final String KEY_H = "rear_h";
    private static final String KEY_X = "rear_x";
    private static final String KEY_Y = "rear_y";
    private static final String KEY_PAN_X = "rear_pan_x";
    private static final String KEY_PAN_Y = "rear_pan_y";
    private static final String KEY_ZOOM = "rear_zoom";
    private static final String KEY_CAM = "rear_cam_id";
    private static final String KEY_LOCKED = "rear_locked";

    private static final float DEFAULT_W_RATIO = 750f / 2400f;
    private static final float DEFAULT_ASPECT = 750f / 250f;   // 750x250（用户指定）
    private static final float DEFAULT_X_RATIO = 727f / 2400f;
    private static final float DEFAULT_Y_RATIO = 89f / 1200f;
    private static final int REAR_AVM_MODE = 17;          // 17 = 2D 后视
    private static final long GUARD_MS = 500L;
    private static final int MIN_W = 480;
    private static final int MIN_H = 160;
    private static final float MIN_ZOOM = 0.5f;
    private static final float MAX_ZOOM = 4.0f;

    private static final Handler MAIN = new Handler(Looper.getMainLooper());

    private static Context sContext;
    private static WindowManager sWm;
    private static FrameLayout sRoot;
    private static TextureView sTexture;
    private static TextView sHint;
    private static View sBorder;
    private static View sBsdBarL;
    private static View sBsdBarR;
    private static View sHandleL;
    private static View sHandleR;
    private static View sHandleT;
    private static View sHandleB;
    private static TextView sClose;
    private static LinearLayout sZoomRow;
    private static TextView sZoomLabel;
    private static float sZoomLevel = 1.0f;

    private static Camera sCamera;
    private static int sPreviewW = 1280;
    private static int sPreviewH = 720;
    private static boolean sPreviewing;

    private static int sW;
    private static int sH;
    private static int sX;
    private static int sY;
    private static int sScreenW;
    private static int sScreenH;
    private static float sPanX;
    private static float sPanY;
    private static float sZoom = 1.0f;
    private static boolean sEditMode;
    private static boolean sShowing;
    private static int sOpenRetries;
    private static int sPreviewRetries;
    private static boolean sGuardRunning;
    private static boolean sLocked;
    private static long sLastModeCheck;
    private static long sLastReverseAt;
    private static boolean sSettingsVisible;

    private RearMirror() {
    }

    // ------------------------------------------------------------------ 开关

    public static boolean isEnabled(Context context) {
        if (context == null) {
            return false;
        }
        return context.getSharedPreferences(PREFS, 0).getBoolean(KEY_ENABLED, false);
    }

    /** 切换开关，返回切换后的状态。 */
    public static boolean isLocked(Context context) {
        if (context == null) {
            return false;
        }
        return context.getSharedPreferences(PREFS, 0).getBoolean(KEY_LOCKED, false);
    }

    public static void setLocked(Context context, boolean locked) {
        if (context == null) {
            return;
        }
        context.getApplicationContext().getSharedPreferences(PREFS, 0)
                .edit().putBoolean(KEY_LOCKED, locked).apply();
        sLocked = locked;
    }

    public static boolean toggle(Context context) {
        boolean next = !isEnabled(context);
        setEnabled(context, next);
        return next;
    }

    public static void setEnabled(Context context, boolean enabled) {
        if (context == null) {
            return;
        }
        Context app = context.getApplicationContext();
        app.getSharedPreferences(PREFS, 0).edit().putBoolean(KEY_ENABLED, enabled).apply();
        if (enabled) {
            sContext = app;
            startGuard();
        } else {
            stopGuard();
            hide();
        }
        OverlayPresets.refreshMirrorButton();
    }

    /** 打灯浮窗/原厂 360 占用摄像头时收起后视镜，恢复后自动重新显示。 */
    private static void startGuard() {
        if (sGuardRunning) {
            return;
        }
        sGuardRunning = true;
        MAIN.postDelayed(GUARD, GUARD_MS);
    }

    private static void stopGuard() {
        sGuardRunning = false;
        MAIN.removeCallbacks(GUARD);
    }

    private static final Runnable GUARD = new Runnable() {
        @Override
        public void run() {
            try {
                if (sContext == null || !isEnabled(sContext)) {
                    sGuardRunning = false;
                    return;
                }
                boolean reverse = SignalGate.isReverseNow();
                if (reverse) {
                    sLastReverseAt = SystemClock.elapsedRealtime();
                }
                // 倒车结束后再等 5 秒，避开车辆倒车影像/360 从后视切前视的过渡，避免被我们的视角顶掉
                boolean reverseCooldown = sLastReverseAt > 0
                        && SystemClock.elapsedRealtime() - sLastReverseAt < 2000L;
                boolean debug = OverlayPresets.isDebugMode(sContext);
                boolean busy = Camera1Preview.isActive() || SignalGate.factoryActiveNow()
                        || reverse || reverseCooldown || sSettingsVisible
                        || (SignalGate.isTurnActive() && !SignalGate.isHazardNow())
                        || (!debug && !SignalGate.isDriveNow())
                        || !isOnHome(sContext);
                if (busy) {
                    if (sShowing) {
                        hide();
                    }
                } else if (!sShowing) {
                    show(sContext);
                } else {
                    boolean bsdOn = OverlayPresets.isBsdMirror(sContext);
                    applyWarningBars(bsdOn && SignalGate.isBsdLeft(),
                            bsdOn && SignalGate.isBsdRight());
                    long now = SystemClock.elapsedRealtime();
                    if (now - sLastModeCheck > 1500L) {
                        sLastModeCheck = now;
                        int mode = SignalGate.avmMode();
                        if (mode >= 0 && mode != REAR_AVM_MODE
                                && !SignalGate.factoryActiveNow()) {
                            applyModeViaCamera2Async();
                        }
                    }
                }
            } catch (Throwable ignored) {
            }
            MAIN.postDelayed(this, GUARD_MS);
        }
    };

    /** 还原后视镜几何参数（位置/大小/画面），不影响开关状态。 */
    public static void resetGeometry(Context context) {
        if (context == null) {
            return;
        }
        Context app = context.getApplicationContext();
        boolean wasShowing = sShowing;
        if (wasShowing) {
            hide();
        }
        app.getSharedPreferences(PREFS, 0).edit()
                .remove(KEY_W).remove(KEY_H).remove(KEY_X).remove(KEY_Y)
                .remove(KEY_PAN_X).remove(KEY_PAN_Y).remove(KEY_ZOOM)
                .apply();
        if (wasShowing) {
            show(app);
        }
    }

    /** 进程/服务重启后，如果开关是打开的，自动恢复浮窗。 */
    private static String sHomePackage;

    /** 车机桌面（主页）包名，首次解析后缓存。 */
    private static String homePackage(Context context) {
        if (sHomePackage == null) {
            try {
                Intent home = new Intent(Intent.ACTION_MAIN);
                home.addCategory(Intent.CATEGORY_HOME);
                android.content.pm.ResolveInfo info =
                        context.getPackageManager().resolveActivity(home, 0);
                if (info != null && info.activityInfo != null) {
                    sHomePackage = info.activityInfo.packageName;
                }
            } catch (Throwable ignored) {
            }
            if (sHomePackage == null) {
                sHomePackage = "com.xiaopeng.montecarlo";
            }
        }
        return sHomePackage;
    }

    /** 当前是否显示在主页（桌面）。 */
    private static boolean isOnHome(Context context) {
        String foreground = SignalGate.foregroundPackage();
        if (foreground == null || foreground.length() == 0) {
            return false;
        }
        if (foreground.equals(homePackage(context))) {
            return true;
        }
        return "com.xiaopeng.montecarlo".equals(foreground);
    }

    /** 设置页在前台时收起后视镜，避免遮挡按钮。 */
    public static void onSettingsVisible(Context context) {
        sSettingsVisible = true;
        if (sShowing) {
            hide();
        }
    }

    /** 设置页离开前台后恢复后视镜。 */
    public static void onSettingsHidden(Context context) {
        sSettingsVisible = false;
        restoreIfEnabled(context);
    }

    public static void restoreIfEnabled(final Context context) {
        if (context == null || !isEnabled(context)) {
            return;
        }
        // 刚开机时 AVM/摄像头还没初始化完成，稍等再启动，避免把原厂 360 画面卡黑
        if (SystemClock.elapsedRealtime() < 120000L) {
            final Context app = context.getApplicationContext();
            MAIN.postDelayed(new Runnable() {
                @Override
                public void run() {
                    if (isEnabled(app) && !sShowing && !sSettingsVisible) {
                        show(app);
                        startGuard();
                    }
                }
            }, 30000L);
            return;
        }
        sContext = context.getApplicationContext();
        startGuard();
    }

    // ------------------------------------------------------------------ 显示/隐藏

    public static synchronized void show(Context context) {
        if (sShowing) {
            return;
        }
        try {
            sContext = context;
            sWm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
            if (sWm == null) {
                return;
            }
            loadGeometry(context);
            sLocked = isLocked(context);
            sOpenRetries = 0;
            sPreviewRetries = 0;
            buildView(context);
            WindowManager.LayoutParams lp = buildLayoutParams(context);
            sWm.addView(sRoot, lp);
            sShowing = true;
            openCamera(context);
            updateHint();
        } catch (Throwable t) {
            sShowing = false;
            toast(context, "后视镜启动失败：" + t);
        }
    }

    public static synchronized void hide() {
        if (!sShowing && sRoot == null) {
            return;
        }
        saveGeometry();
        releaseCamera();
        try {
            if (sRoot != null && sWm != null) {
                sWm.removeView(sRoot);
            }
        } catch (Throwable ignored) {
        }
        sRoot = null;
        sTexture = null;
        sHint = null;
        sBorder = null;
        sHandleL = null;
        sHandleR = null;
        sHandleT = null;
        sHandleB = null;
        sClose = null;
        sBsdBarL = null;
        sBsdBarR = null;
        sEditMode = false;
        sShowing = false;
    }

    private static WindowManager.LayoutParams buildLayoutParams(Context context) {
        WindowManager.LayoutParams lp = new WindowManager.LayoutParams();
        lp.type = android.os.Build.VERSION.SDK_INT >= 26
                ? WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
                : WindowManager.LayoutParams.TYPE_PHONE;
        lp.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
                | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
                | WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS;
        lp.format = PixelFormat.TRANSLUCENT;
        lp.gravity = Gravity.TOP | Gravity.LEFT;
        lp.width = sW;
        lp.height = sH;
        lp.x = sX;
        lp.y = sY;
        return lp;
    }

    private static void loadGeometry(Context context) {
        SharedPreferences p = context.getSharedPreferences(PREFS, 0);
        DisplayMetrics metrics = new DisplayMetrics();
        WindowManager wm = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        wm.getDefaultDisplay().getRealMetrics(metrics);
        int screenW = metrics.widthPixels;
        int screenH = metrics.heightPixels;
        sScreenW = screenW;
        sScreenH = screenH;
        int defW = (int) (screenW * DEFAULT_W_RATIO);
        int defH = (int) (defW / DEFAULT_ASPECT);
        sW = clamp(p.getInt(KEY_W, defW), MIN_W, screenW);
        sH = clamp(p.getInt(KEY_H, defH), MIN_H, screenH);
        sX = clamp(p.getInt(KEY_X, (int) (screenW * DEFAULT_X_RATIO)), -sW / 2, screenW - sW / 2);
        sY = clamp(p.getInt(KEY_Y, (int) (screenH * DEFAULT_Y_RATIO)), 0, screenH - sH / 2);
        sPanX = p.getFloat(KEY_PAN_X, 0f);
        sPanY = p.getFloat(KEY_PAN_Y, 0f);
        sZoom = clamp(p.getFloat(KEY_ZOOM, 1f), MIN_ZOOM, MAX_ZOOM);
        sZoomLevel = clamp(p.getFloat("zoom_level", 1.0f), 1.0f, 3.0f);
        updateZoomLabel();
        sEditMode = false;
    }

    private static void saveGeometry() {
        if (sContext == null || sRoot == null) {
            return;
        }
        sContext.getSharedPreferences(PREFS, 0).edit()
                .putInt(KEY_W, sW)
                .putInt(KEY_H, sH)
                .putInt(KEY_X, sX)
                .putInt(KEY_Y, sY)
                .putFloat(KEY_PAN_X, sPanX)
                .putFloat(KEY_PAN_Y, sPanY)
                .putFloat(KEY_ZOOM, sZoom)
                .apply();
    }

    // ------------------------------------------------------------------ 视图

    private static void buildView(Context context) {
        sRoot = new FrameLayout(context);
        sRoot.setBackgroundColor(Color.BLACK);
        // 圆角：用 outline 裁剪整块浮窗（含视频画面）
        final float radius = dp(context, 24);
        sRoot.setOutlineProvider(new android.view.ViewOutlineProvider() {
            @Override
            public void getOutline(View view, android.graphics.Outline outline) {
                outline.setRoundRect(0, 0, view.getWidth(), view.getHeight(), radius);
            }
        });
        sRoot.setClipToOutline(true);

        sTexture = new TextureView(context);
        sRoot.addView(sTexture, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        sTexture.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
            @Override
            public void onLayoutChange(View v, int left, int top, int right, int bottom,
                                       int oldLeft, int oldTop, int oldRight, int oldBottom) {
                if (right - left != oldRight - oldLeft || bottom - top != oldBottom - oldTop) {
                    applyTransform();
                }
            }
        });
        sTexture.setSurfaceTextureListener(new TextureView.SurfaceTextureListener() {
            @Override
            public void onSurfaceTextureAvailable(android.graphics.SurfaceTexture surface, int width, int height) {
                startPreviewIfReady();
            }

            @Override
            public void onSurfaceTextureSizeChanged(android.graphics.SurfaceTexture surface, int width, int height) {
                applyTransform();
            }

            @Override
            public boolean onSurfaceTextureDestroyed(android.graphics.SurfaceTexture surface) {
                return true;
            }

            @Override
            public void onSurfaceTextureUpdated(android.graphics.SurfaceTexture surface) {
            }
        });

        sBorder = new View(context);
        sBorder.setBackgroundColor(Color.TRANSPARENT);
        sRoot.addView(sBorder, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));

        sBsdBarL = new View(context);
        sBsdBarL.setBackground(new BsdBarDrawable(false));
        sBsdBarL.setVisibility(View.GONE);
        sRoot.addView(sBsdBarL, new FrameLayout.LayoutParams(
                dp(context, 14), ViewGroup.LayoutParams.MATCH_PARENT, Gravity.LEFT | Gravity.CENTER_VERTICAL));
        sBsdBarR = new View(context);
        sBsdBarR.setBackground(new BsdBarDrawable(true));
        sBsdBarR.setVisibility(View.GONE);
        sRoot.addView(sBsdBarR, new FrameLayout.LayoutParams(
                dp(context, 14), ViewGroup.LayoutParams.MATCH_PARENT, Gravity.RIGHT | Gravity.CENTER_VERTICAL));


        sHandleL = makeHandle(context, true);
        sHandleR = makeHandle(context, true);
        sHandleT = makeHandle(context, false);
        sHandleB = makeHandle(context, false);
        FrameLayout.LayoutParams lpL = new FrameLayout.LayoutParams(dp(context, 22), ViewGroup.LayoutParams.MATCH_PARENT, Gravity.LEFT);
        FrameLayout.LayoutParams lpR = new FrameLayout.LayoutParams(dp(context, 22), ViewGroup.LayoutParams.MATCH_PARENT, Gravity.RIGHT);
        FrameLayout.LayoutParams lpT = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(context, 22), Gravity.TOP);
        FrameLayout.LayoutParams lpB = new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, dp(context, 22), Gravity.BOTTOM);
        sRoot.addView(sHandleL, lpL);
        sRoot.addView(sHandleR, lpR);
        sRoot.addView(sHandleT, lpT);
        sRoot.addView(sHandleB, lpB);

        sHint = new TextView(context);
        sHint.setTextSize(14f);
        sHint.setTextColor(Color.WHITE);
        sHint.setShadowLayer(3f, 1f, 1f, Color.BLACK);
        sHint.setPadding(dp(context, 8), dp(context, 6), dp(context, 8), dp(context, 6));
        sRoot.addView(sHint, new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, Gravity.TOP | Gravity.LEFT));

        sClose = new TextView(context);
        sClose.setVisibility(View.GONE);
        sClose.setText("✕");
        sClose.setTextSize(18f);
        sClose.setTextColor(Color.WHITE);
        sClose.setGravity(Gravity.CENTER);
        int closeBg = context.getResources().getIdentifier(
                "bg_button", "drawable", context.getPackageName());
        if (closeBg != 0) {
            sClose.setBackgroundResource(closeBg);
        } else {
            sClose.setBackgroundColor(0x66000000);
        }
        FrameLayout.LayoutParams closeParams = new FrameLayout.LayoutParams(
                dp(context, 40), dp(context, 40), Gravity.TOP | Gravity.RIGHT);
        closeParams.topMargin = dp(context, 6);
        closeParams.rightMargin = dp(context, 6);
        sRoot.addView(sClose, closeParams);
        sClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                try {
                    setEnabled(v.getContext().getApplicationContext(), false);
                    toast(v.getContext(), "已关闭流媒体后视镜，可在设置中重新开启");
                } catch (Throwable ignored) {
                }
            }
        });

        sZoomRow = new LinearLayout(context);
        sZoomRow.setOrientation(LinearLayout.HORIZONTAL);
        sZoomRow.setVisibility(View.GONE);
        sZoomRow.setGravity(Gravity.CENTER_VERTICAL);
        FrameLayout.LayoutParams zoomRowParams = new FrameLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, dp(context, 44), Gravity.BOTTOM | Gravity.RIGHT);
        zoomRowParams.rightMargin = dp(context, 8);
        zoomRowParams.bottomMargin = dp(context, 8);
        sRoot.addView(sZoomRow, zoomRowParams);

        TextView minus = makeRoundButton(context, "-");
        minus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setZoomLevel(v.getContext(), sZoomLevel - 0.1f);
            }
        });
        sZoomRow.addView(minus);

        sZoomLabel = new TextView(context);
        sZoomLabel.setTextSize(15f);
        sZoomLabel.setTextColor(Color.WHITE);
        sZoomLabel.setShadowLayer(3f, 1f, 1f, Color.BLACK);
        sZoomLabel.setGravity(Gravity.CENTER);
        LinearLayout.LayoutParams labelParams = new LinearLayout.LayoutParams(
                dp(context, 52), ViewGroup.LayoutParams.WRAP_CONTENT);
        sZoomRow.addView(sZoomLabel, labelParams);

        TextView plus = makeRoundButton(context, "+");
        plus.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setZoomLevel(v.getContext(), sZoomLevel + 0.1f);
            }
        });
        sZoomRow.addView(plus);
        updateZoomLabel();

        sRoot.setOnTouchListener(new View.OnTouchListener() {
            private float downRawX;
            private float downRawY;
            private int startX;
            private int startY;
            private float startPanX;
            private float startPanY;
            private float startZoom;
            private float startDist;
            private long lastTapAt;

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getActionMasked()) {
                    case MotionEvent.ACTION_DOWN:
                        downRawX = event.getRawX();
                        downRawY = event.getRawY();
                        startX = sX;
                        startY = sY;
                        startPanX = sPanX;
                        startPanY = sPanY;
                        startZoom = sZoom;
                        startDist = 0f;
                        return true;
                    case MotionEvent.ACTION_POINTER_DOWN:
                        return true;
                    case MotionEvent.ACTION_MOVE:
                        if (sLocked) {
                            return true;
                        }
                        if (sEditMode) {
                            return true;
                        }
                        sX = startX + (int) (event.getRawX() - downRawX);
                        sY = startY + (int) (event.getRawY() - downRawY);
                        updateLayout();
                        return true;
                    case MotionEvent.ACTION_UP:
                        if (sLocked) {
                            showCloseTemporarily();
                            return true;
                        }
                        float dx = Math.abs(event.getRawX() - downRawX);
                        float dy = Math.abs(event.getRawY() - downRawY);
                        if (!sEditMode && (dx >= 20f || dy >= 20f)) {
                            // 拖动结束：限制窗口不要完全移出屏幕
                            sX = clamp(sX, -sW / 2, sScreenW - sW / 2);
                            sY = clamp(sY, 0, sScreenH - sH / 2);
                            updateLayout();
                        }
                        saveGeometry();
                        if (dx < 20f && dy < 20f) {
                            showCloseTemporarily();
                            long now = System.currentTimeMillis();
                            if (now - lastTapAt < 300L) {
                                toggleEditMode();
                                lastTapAt = 0L;
                            } else {
                                lastTapAt = now;
                            }
                        }
                        return true;
                    default:
                        return false;
                }
            }
        });
        applyEditVisibility();
    }

    private static TextView makeRoundButton(Context context, String text) {
        TextView button = new TextView(context);
        button.setText(text);
        button.setTextSize(20f);
        button.setTextColor(Color.WHITE);
        button.setGravity(Gravity.CENTER);
        android.graphics.drawable.GradientDrawable shape = new android.graphics.drawable.GradientDrawable();
        shape.setShape(android.graphics.drawable.GradientDrawable.OVAL);
        shape.setColor(0x66000000);
        shape.setStroke(dp(context, 2), Color.WHITE);
        button.setBackground(shape);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                dp(context, 40), dp(context, 40));
        button.setLayoutParams(params);
        return button;
    }

    private static void setZoomLevel(Context context, float level) {
        sZoomLevel = clamp(Math.round(level * 10f) / 10f, 1.0f, 3.0f);
        updateZoomLabel();
        applyTransform();
        try {
            context.getSharedPreferences(PREFS, 0).edit()
                    .putFloat("zoom_level", sZoomLevel).apply();
        } catch (Throwable ignored) {
        }
    }

    private static void updateZoomLabel() {
        if (sZoomLabel != null) {
            sZoomLabel.setText(String.format(java.util.Locale.US, "%.1fx", sZoomLevel));
        }
    }

    private static View makeHandle(Context context, boolean vertical) {
        View handle = new View(context);
        handle.setBackgroundColor(Color.argb(180, 255, 200, 0));
        handle.setVisibility(View.GONE);
        handle.setOnTouchListener(new View.OnTouchListener() {
            private float downRaw;
            private int startW;
            private int startH;
            private int startX;
            private int startY;

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                if (sLocked) {
                    return false;
                }
                switch (event.getActionMasked()) {
                    case MotionEvent.ACTION_DOWN:
                        downRaw = vertical ? event.getRawX() : event.getRawY();
                        startW = sW;
                        startH = sH;
                        startX = sX;
                        startY = sY;
                        return true;
                    case MotionEvent.ACTION_MOVE:
                        if (v == sHandleR) {
                            sW = Math.max(MIN_W, startW + (int) (event.getRawX() - downRaw));
                        } else if (v == sHandleL) {
                            int delta = (int) (event.getRawX() - downRaw);
                            sW = Math.max(MIN_W, startW - delta);
                            sX = startX + (startW - sW);
                        } else if (v == sHandleB) {
                            sH = Math.max(MIN_H, startH + (int) (event.getRawY() - downRaw));
                        } else if (v == sHandleT) {
                            int delta = (int) (event.getRawY() - downRaw);
                            sH = Math.max(MIN_H, startH - delta);
                            sY = startY + (startH - sH);
                        }
                        updateLayout();
                        applyTransform();
                        return true;
                    case MotionEvent.ACTION_UP:
                        saveGeometry();
                        return true;
                    default:
                        return false;
                }
            }
        });
        return handle;
    }

    private static final Runnable HIDE_CLOSE = new Runnable() {
        @Override
        public void run() {
            if (sClose != null && !sEditMode) {
                sClose.setVisibility(View.GONE);
            }
        }
    };

    /** 点击画面时短暂显示右上角关闭按钮。 */
    private static void showCloseTemporarily() {
        if (sClose == null) {
            return;
        }
        sClose.setVisibility(View.VISIBLE);
        MAIN.removeCallbacks(HIDE_CLOSE);
        MAIN.postDelayed(HIDE_CLOSE, 3000L);
    }

    private static void applyModeViaCamera2Async() {
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                applyModeViaCamera2();
            }
        }, "RearMirrorMode");
        thread.setDaemon(true);
        thread.start();
    }

    /** 用临时 2 号摄像头会话下发 AVM 视角（不触碰后视镜自己的预览）。 */
    private static void applyModeViaCamera2() {
        if (sContext == null || SignalGate.factoryActiveNow()) {
            return;
        }
        if (SignalGate.avmMode() <= 0) {
            // AVM 还没上报有效视角，此时下发可能把原厂画面卡黑
            return;
        }
        Camera camera = null;
        try {
            camera = Camera.open(2);
            Camera.Parameters parameters = camera.getParameters();
            try {
                parameters.getClass().getMethod("setAvmDisplayMode", Integer.TYPE)
                        .invoke(parameters, Integer.valueOf(REAR_AVM_MODE));
            } catch (Throwable t) {
                try {
                    parameters.set("display-mode", String.valueOf(REAR_AVM_MODE));
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
            camera.setParameters(parameters);
            Method target = null;
            for (Method method : camera.getClass().getMethods()) {
                if ("setCmdControlParameters".equals(method.getName())
                        && method.getParameterTypes().length == 1) {
                    target = method;
                    break;
                }
            }
            if (target != null) {
                target.invoke(camera, parameters);
            }
        } catch (Throwable ignored) {
        } finally {
            if (camera != null) {
                try {
                    camera.release();
                } catch (Throwable ignored) {
                }
            }
        }
    }

    private static void toggleEditMode() {
        sEditMode = !sEditMode;
        applyEditVisibility();
        if (!sEditMode) {
            saveGeometry();
        }
    }

    /** 上下 + 横向（外侧）双向渐变的红色竖条。 */
    private static final class BsdBarDrawable extends android.graphics.drawable.Drawable {
        private final boolean fadeToLeft;
        private final android.graphics.Paint paint =
                new android.graphics.Paint(android.graphics.Paint.ANTI_ALIAS_FLAG);
        private final android.graphics.Paint maskPaint =
                new android.graphics.Paint(android.graphics.Paint.ANTI_ALIAS_FLAG);

        BsdBarDrawable(boolean fadeToLeft) {
            this.fadeToLeft = fadeToLeft;
        }

        @Override
        public void draw(android.graphics.Canvas canvas) {
            android.graphics.Rect b = getBounds();
            if (b.width() <= 0 || b.height() <= 0) {
                return;
            }
            int save = canvas.saveLayer(new android.graphics.RectF(b), null);
            paint.setShader(new android.graphics.LinearGradient(
                    b.left, b.top, b.left, b.bottom,
                    new int[]{0x00FF3B30, 0xFFFF3B30, 0x00FF3B30}, null,
                    android.graphics.Shader.TileMode.CLAMP));
            canvas.drawRect(b, paint);
            int transparent = fadeToLeft ? 0x00FFFFFF : 0x00FFFFFF;
            int opaque = 0xFFFFFFFF;
            int[] colors = fadeToLeft
                    ? new int[]{0x00FFFFFF, 0xFFFFFFFF}
                    : new int[]{0xFFFFFFFF, 0x00FFFFFF};
            maskPaint.setShader(new android.graphics.LinearGradient(
                    b.left, 0f, b.right, 0f, colors, null,
                    android.graphics.Shader.TileMode.CLAMP));
            maskPaint.setXfermode(new android.graphics.PorterDuffXfermode(
                    android.graphics.PorterDuff.Mode.DST_IN));
            canvas.drawRect(b, maskPaint);
            canvas.restoreToCount(save);
        }

        @Override
        public void setAlpha(int alpha) {
        }

        @Override
        public void setColorFilter(android.graphics.ColorFilter colorFilter) {
        }

        @Override
        public int getOpacity() {
            return android.graphics.PixelFormat.TRANSLUCENT;
        }
    }

    /** 盲区警示：左右两条细红条，分别对应左/右盲区。 */
    private static void applyWarningBars(boolean left, boolean right) {
        if (sBsdBarL != null) {
            sBsdBarL.setVisibility(!sEditMode && left ? View.VISIBLE : View.GONE);
        }
        if (sBsdBarR != null) {
            sBsdBarR.setVisibility(!sEditMode && right ? View.VISIBLE : View.GONE);
        }
    }

    private static void applyEditVisibility() {
        if (sZoomRow != null) {
            sZoomRow.setVisibility(sEditMode ? View.VISIBLE : View.GONE);
        }
        int visibility = sEditMode ? View.VISIBLE : View.GONE;
        if (sHint != null) {
            // 平时不显示文字提示，只在编辑模式显示操作说明
            sHint.setVisibility(visibility);
        }
        if (sHandleL != null) {
            sHandleL.setVisibility(visibility);
        }
        if (sHandleR != null) {
            sHandleR.setVisibility(visibility);
        }
        if (sHandleT != null) {
            sHandleT.setVisibility(visibility);
        }
        if (sHandleB != null) {
            sHandleB.setVisibility(visibility);
        }
        if (sRoot != null) {
            sRoot.setBackgroundColor(Color.BLACK);
        }
        if (sBorder != null) {
            if (sEditMode) {
                android.graphics.drawable.GradientDrawable bg =
                        new android.graphics.drawable.GradientDrawable();
                bg.setColor(Color.TRANSPARENT);
                bg.setStroke(dp(sBorder.getContext(), 3), Color.rgb(255, 200, 0));
                sBorder.setBackground(bg);
                sBorder.setVisibility(View.VISIBLE);
            } else {
                sBorder.setBackgroundColor(Color.TRANSPARENT);
                sBorder.setVisibility(View.GONE);
            }
        }
        updateHint();
    }

    private static void updateHint() {
        if (sHint == null) {
            return;
        }
            sHint.setText("编辑模式：拖动黄色边缘调整窗口形状，双击退出并保存");
    }

    private static void updateLayout() {
        if (sRoot == null || sWm == null) {
            return;
        }
        try {
            WindowManager.LayoutParams lp = (WindowManager.LayoutParams) sRoot.getLayoutParams();
            if (lp == null) {
                return;
            }
            lp.width = sW;
            lp.height = sH;
            lp.x = sX;
            lp.y = sY;
            sWm.updateViewLayout(sRoot, lp);
        } catch (Throwable ignored) {
        }
    }

    // ------------------------------------------------------------------ 摄像头

    private static int camId(Context context) {
        return context.getSharedPreferences(PREFS, 0).getInt(KEY_CAM, 0);
    }

    private static void openCamera(final Context context) {
        if (sCamera != null) {
            return;
        }
        final int id = camId(context);
        try {
            sCamera = Camera.open(id);
        } catch (Throwable t) {
            sCamera = null;
            toast(context, "后视摄像头打开失败：" + t);
            retryOpen(context);
            return;
        }
        if (sCamera == null) {
            retryOpen(context);
            return;
        }
        try {
            Camera.Parameters parameters = sCamera.getParameters();
            parameters.setPreviewFormat(android.graphics.ImageFormat.NV21);
            Camera.Size size = chooseSize(parameters, 1280, 720);
            if (size != null) {
                parameters.setPreviewSize(size.width, size.height);
                sPreviewW = size.width;
                sPreviewH = size.height;
            }
            sCamera.setParameters(parameters);
        } catch (Throwable ignored) {
        }
        applyRearMode();
        try {
            sCamera.setErrorCallback(new Camera.ErrorCallback() {
                @Override
                public void onError(int error, Camera cam) {
                    MAIN.post(new Runnable() {
                        @Override
                        public void run() {
                            releaseCamera();
                            retryOpen(context);
                        }
                    });
                }
            });
        } catch (Throwable ignored) {
        }
        startPreviewIfReady();
    }

    private static void startPreviewIfReady() {
        if (sCamera == null || sTexture == null) {
            return;
        }
        android.graphics.SurfaceTexture surface = sTexture.getSurfaceTexture();
        if (surface == null) {
            return;
        }
        try {
            surface.setDefaultBufferSize(sPreviewW, sPreviewH);
            sCamera.setPreviewTexture(surface);
            sCamera.startPreview();
            sPreviewing = true;
            sPreviewRetries = 0;
            applyTransform();
        } catch (Throwable t) {
            sPreviewing = false;
            if (sPreviewRetries++ < 15) {
                MAIN.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        startPreviewIfReady();
                    }
                }, 200L);
            }
        }
    }

    private static void retryOpen(final Context context) {
        if (sOpenRetries >= 5) {
            sOpenRetries = 0;
            return;
        }
        sOpenRetries++;
        MAIN.postDelayed(new Runnable() {
            @Override
            public void run() {
                if (sShowing) {
                    openCamera(context);
                }
            }
        }, 1000L);
    }

    /** 读取当前摄像头会话的 AVM 视角。 */
    private static int readOwnMode() {
        if (sCamera == null) {
            return -1;
        }
        try {
            Method get = sCamera.getClass().getMethod("getCmdControlParameters");
            Object parameters = get.invoke(sCamera);
            if (parameters == null) {
                return -1;
            }
            Method mode = parameters.getClass().getMethod("getAvmDisplayMode");
            Object value = mode.invoke(parameters);
            return value instanceof Integer ? ((Integer) value).intValue() : -1;
        } catch (Throwable ignored) {
            return -1;
        }
    }

    /** 后视镜独占时把 AVM 设回后视视角（17）；原厂占用时不写。 */
    private static void applyRearMode() {
        if (sCamera == null || SignalGate.factoryActiveNow()) {
            return;
        }
        try {
            Camera.Parameters parameters = sCamera.getParameters();
            try {
                parameters.getClass().getMethod("setAvmDisplayMode", Integer.TYPE)
                        .invoke(parameters, Integer.valueOf(REAR_AVM_MODE));
            } catch (Throwable t) {
                try {
                    parameters.set("display-mode", String.valueOf(REAR_AVM_MODE));
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
            sCamera.setParameters(parameters);
            Method target = null;
            for (Method method : sCamera.getClass().getMethods()) {
                if ("setCmdControlParameters".equals(method.getName())
                        && method.getParameterTypes().length == 1) {
                    target = method;
                    break;
                }
            }
            if (target != null) {
                target.invoke(sCamera, parameters);
            }
        } catch (Throwable ignored) {
        }
    }

    private static void releaseCamera() {
        Camera camera = sCamera;
        sCamera = null;
        sPreviewing = false;
        sPreviewRetries = 0;
        if (camera == null) {
            return;
        }
        try {
            camera.stopPreview();
        } catch (Throwable ignored) {
        }
        try {
            camera.setPreviewTexture(null);
        } catch (Throwable ignored) {
        }
        try {
            camera.release();
        } catch (Throwable ignored) {
        }
    }

    private static Camera.Size chooseSize(Camera.Parameters parameters, int targetW, int targetH) {
        try {
            java.util.List<Camera.Size> sizes = parameters.getSupportedPreviewSizes();
            if (sizes == null || sizes.isEmpty()) {
                return null;
            }
            Camera.Size best = null;
            long bestScore = Long.MAX_VALUE;
            for (Camera.Size size : sizes) {
                long score = Math.abs(size.width - targetW) + Math.abs(size.height - targetH);
                if (score < bestScore) {
                    bestScore = score;
                    best = size;
                }
            }
            return best;
        } catch (Throwable ignored) {
            return null;
        }
    }

    // ------------------------------------------------------------------ 画面变换

    private static void applyTransform() {
        if (sTexture == null || sW <= 0 || sH <= 0) {
            return;
        }
        try {
            // 先按浮窗“宽度”等比缩放（不改变原画面比例），再按高度居中裁剪。
            float zoom = sZoom * sZoomLevel;
            float pixelsPerTexel = (sW / (float) sPreviewW) * zoom;
            float scaleX = sPreviewW * pixelsPerTexel / sW;
            float scaleY = sPreviewH * pixelsPerTexel / sH;
            // 顶部中央为固定点缩放（向左右和下方扩展）
            float dx = sW / 2f * (1f - zoom) + sPanX;
            // 贴顶裁剪：保留画面上部，裁掉下部
            float dy = sPanY;
            Matrix matrix = new Matrix();
            matrix.postScale(scaleX, scaleY);
            matrix.postTranslate(dx, dy);
            sTexture.setTransform(matrix);
        } catch (Throwable ignored) {
        }
    }

    // ------------------------------------------------------------------ 工具

    private static float distance(MotionEvent event) {
        if (event.getPointerCount() < 2) {
            return 0f;
        }
        float dx = event.getX(0) - event.getX(1);
        float dy = event.getY(0) - event.getY(1);
        return (float) Math.sqrt(dx * dx + dy * dy);
    }

    private static int clamp(int value, int min, int max) {
        if (max < min) {
            return min;
        }
        return Math.max(min, Math.min(max, value));
    }

    private static float clamp(float value, float min, float max) {
        return Math.max(min, Math.min(max, value));
    }

    private static int dp(Context context, int value) {
        return (int) (value * context.getResources().getDisplayMetrics().density + 0.5f);
    }

    private static void toast(Context context, String message) {
        try {
            Toast.makeText(context, message, Toast.LENGTH_SHORT).show();
        } catch (Throwable ignored) {
        }
    }
}
