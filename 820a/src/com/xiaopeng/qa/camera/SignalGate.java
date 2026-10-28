package com.xiaopeng.qa.camera;

import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.util.Log;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 浮窗让位逻辑：
 *  - 原厂 360 全景 / 「窄道激活全景影像」正在使用 2 号摄像头时，自动关闭本程序浮窗；
 *  - 原厂全景关闭后，如果转向灯还亮着，自动恢复本程序浮窗；
 *  - 双闪（左右转向灯同时亮）时不弹浮窗。
 *
 * 性能优化点：
 *  - 反射得到的 Field/Method 全部缓存，轮询时不再重复查找；
 *  - 弹窗判断只读缓存，不在主线程执行 shell；
 *  - 摄像头占用 500ms 轮询、双闪/转向 1500ms 轮询（转向灯本身由 SignalMonitor 300ms 轮询）；
 *  - Service 销毁时调用 detach() 退出巡检线程。
 */
public final class SignalGate {

    private static final String TAG = "CameraAssist";

    private static final String CMD_CAMERA =
            "dumpsys media.camera | grep -E 'Camera ID: 2.*Client Package Name'";

    private static final String CMD_CAR =
            "dumpsys car_service | grep -E 'lastEvent: ?Property=(BCM_LRTURNLAMP_ACTIVE_ST|BCM_(L|R)TURNLAMP_ST|VCU_CURRENT_GEARLEV|AVM_DISPLAY_MODE|SCU_BSD_LEFT_WARNING|SCU_BSD_RIGHT_WARNING)'; "
            + "dumpsys window | grep -E 'mCurrentFocus|mResumedActivity'";

    private static final String CMD_FOCUS =
            "dumpsys window | grep -E 'mCurrentFocus|mResumedActivity'";

    private static final String CMD_AVM_MODE =
            "dumpsys car_service | grep -E 'lastEvent: ?Property=AVM_DISPLAY_MODE'";

    private static final String FACTORY_PACKAGE = "com.xiaopeng.xmart.camera";

    private static final long CAMERA_POLL_MS = 1500L;
    private static final long CAR_POLL_MS = 800L;
    private static final long TICK_MS = 100L;
    private static final long FACTORY_CACHE_MS = 700L;
    private static final boolean DEBUG_LOG = false;

    private static final Pattern BOTH_PATTERN =
            Pattern.compile("BCM_LRTURNLAMP_ACTIVE_ST.*?int32Values: \\[(-?\\d+),\\s*(-?\\d+)\\]");
    private static final Pattern LEFT_PATTERN =
            Pattern.compile("BCM_LTURNLAMP_ST.*?int32Values: \\[(-?\\d+)\\]");
    private static final Pattern RIGHT_PATTERN =
            Pattern.compile("BCM_RTURNLAMP_ST.*?int32Values: \\[(-?\\d+)\\]");
    private static final Pattern CLIENT_PATTERN =
            Pattern.compile("Client Package Name: ([A-Za-z0-9_.]+)");
    private static final Pattern GEAR_PATTERN =
            Pattern.compile("VCU_CURRENT_GEARLEV.*?int32Values: \\[(-?\\d+)\\]");
    private static final Pattern BSD_LEFT_PATTERN =
            Pattern.compile("SCU_BSD_LEFT_WARNING.*?int32Values: \\[(-?\\d+)\\]");
    private static final Pattern BSD_RIGHT_PATTERN =
            Pattern.compile("SCU_BSD_RIGHT_WARNING.*?int32Values: \\[(-?\\d+)\\]");
    private static final Pattern FOCUS_PATTERN =
            Pattern.compile("(?:u0\\s+)([A-Za-z0-9_.]+)/");
    private static final Pattern AVM_MODE_PATTERN =
            Pattern.compile("AVM_DISPLAY_MODE.*?int32Values: \\[(-?\\d+)\\]");

    private static final Handler MAIN = new Handler(Looper.getMainLooper());

    private static volatile Object sService;
    private static volatile boolean sStarted;
    private static volatile boolean sRunning;

    private static volatile boolean sFactoryAvm;
    private static volatile boolean sHazard;
    private static volatile boolean sLeftOn;
    private static volatile boolean sRightOn;
    private static volatile boolean sSuppressed;
    private static volatile int sGear = -1;
    private static volatile String sForegroundPackage = "";
    private static volatile long sLastFocusPollAt;
    private static volatile int sNonDrivePolls;
    private static volatile boolean sBsdLeft;
    private static volatile boolean sBsdRight;
    private static volatile long sLastBsdAt;
    private static volatile int sAvmMode = -1;
    private static volatile String sLastDirection;
    private static volatile long sLastCameraPollAt;
    private static volatile long sLastCarPollAt;
    private static volatile boolean sLoggedHide;
    private static volatile boolean sRefreshing;
    private static volatile boolean sPollFailed;
    private static volatile boolean sHidePending;
    private static volatile int sGeneration;

    // 反射缓存
    private static Method sServiceLogMethod;
    private static Field sAdbField;
    private static Method sAdbExecMethod;
    private static Field sOverlayViewField;
    private static Method sHideMethod;
    private static Method sShowMethod;

    private SignalGate() {
    }

    /** 由 CameraOverlayService.onCreate 调用，启动后台巡检线程。 */
    public static void attach(Object service) {
        sService = service;
        if (sStarted) {
            return;
        }
        sStarted = true;
        sRunning = true;
        final int generation = ++sGeneration;
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                long lastCamera = 0L;
                long lastCar = 0L;
                while (sRunning && generation == sGeneration) {
                    try {
                        long now = SystemClock.elapsedRealtime();
                        if (now - lastCamera >= CAMERA_POLL_MS) {
                            refreshCamera(sService);
                            lastCamera = now;
                        }
                        if (now - lastCar >= CAR_POLL_MS) {
                            refreshCar(sService);
                            lastCar = now;
                        }
                        applyStateChange();
                        hideIfNeeded();
                    } catch (Throwable ignored) {
                    }
                    try {
                        Thread.sleep(TICK_MS);
                    } catch (InterruptedException ignored) {
                        return;
                    }
                }
            }
        }, "CameraAssist-SignalGate");
        thread.setDaemon(true);
        thread.start();
    }

    /** Service 销毁时调用，停止巡检线程。 */
    public static void detach() {
        sRunning = false;
        sGeneration++;
        sStarted = false;
        sService = null;
        sLoggedHide = false;
    }

    /** 打灯准备弹窗时调用：返回 true 表示本次不弹（双闪或原厂全景占用）。只读缓存，不做 IO。 */
    public static boolean shouldSuppress(Object service, String direction) {
        sService = service;
        sLastDirection = direction;
        // 只读缓存：不做任何 ADB/IO，避免阻塞主线程（弱车机上会明显卡顿）
        return isSuppressed();
    }

    public static boolean isSuppressed() {
        return sHazard || sFactoryAvm;
    }

    /** 是否处于倒车档（VCU 档位 3=R）。 */
    /** D gear (VCU gear 1). */
    public static boolean isDriveNow() {
        return sGear == 1;
    }

    /** Current foreground package. */
    public static String foregroundPackage() {
        return sForegroundPackage;
    }

    /** Left or right turn lamp currently on. */
    public static boolean isBsdLeft() {
        return sBsdLeft;
    }

    public static boolean isBsdRight() {
        return sBsdRight;
    }

    public static boolean isBsdActive() {
        return sBsdLeft || sBsdRight;
    }

    public static boolean isHazardNow() {
        return sHazard;
    }

    public static boolean isTurnActive() {
        return sLeftOn || sRightOn;
    }

    /** Last car poll succeeded. */
    public static boolean isPollOk() {
        return sLastCarPollAt > 0 && !sPollFailed;
    }

    public static boolean isReverseNow() {
        return sGear == 3;
    }

    /** 当前 AVM 视角（来自车机属性缓存）。 */
    public static int avmMode() {
        return sAvmMode;
    }

    /** 读取当前 AVM 视角（display-mode），用于打开前记录、关闭时恢复原厂视角。 */
    public static int readAvmMode() {
        if (sRefreshing) {
            return -1;
        }
        String output = exec(sService, CMD_AVM_MODE);
        if (output == null) {
            return -1;
        }
        try {
            Matcher matcher = AVM_MODE_PATTERN.matcher(output);
            if (matcher.find()) {
                return parseInt(matcher.group(1));
            }
        } catch (Throwable ignored) {
        }
        return -1;
    }

    /** 原厂全景是否正占用 2 号摄像头（缓存 700ms 内直接返回，避免主线程 IO）。 */
    public static boolean factoryActiveNow() {
        // 只读缓存（后台线程每 1.5 秒刷新一次），不在主线程执行 shell
        return sFactoryAvm;
    }

    /** 让外部（Camera1Preview）请求收起浮窗。 */
    public static void requestHide(String reason) {
        hideOverlay(reason);
    }

    /** 条件变化时：占用/双闪 → 收起；原厂关闭 → 若灯还亮着则恢复。 */
    private static void applyStateChange() {
        boolean now = isSuppressed();
        boolean before = sSuppressed;
        if (now == before) {
            return;
        }
        sSuppressed = now;
        if (now) {
            hideOverlay("原厂全景占用 2 号摄像头" + (sHazard ? "/双闪" : "") + "，关闭本程序浮窗");
        } else {
            sLoggedHide = false;
            final String direction = currentDirection();
            if (direction == null) {
                return;
            }
            final Object service = sService;
            MAIN.post(new Runnable() {
                @Override
                public void run() {
                    try {
                        Method show = sShowMethod;
                        if (show == null) {
                            show = service.getClass().getDeclaredMethod(
                                    "showOverlayForDirection", String.class);
                            show.setAccessible(true);
                            sShowMethod = show;
                        }
                        show.invoke(service, direction);
                        log("原厂全景已关闭且转向灯仍亮，恢复本程序浮窗（" + direction + "）");
                    } catch (Throwable ignored) {
                    }
                }
            });
        }
    }

    private static String currentDirection() {
        if (sLeftOn && !sRightOn) {
            return "LEFT";
        }
        if (sRightOn && !sLeftOn) {
            return "RIGHT";
        }
        return null;
    }

    private static void hideIfNeeded() {
        if (!isSuppressed()) {
            return;
        }
        hideOverlay(null);
    }

    private static void hideOverlay(final String reason) {
        final Object service = sService;
        if (service == null || sHidePending || !isOverlayVisible(service)) {
            return;
        }
        sHidePending = true;
        MAIN.post(new Runnable() {
            @Override
            public void run() {
                sHidePending = false;
                try {
                    Method hide = sHideMethod;
                    if (hide == null) {
                        hide = service.getClass().getDeclaredMethod("hideOverlayAndCamera");
                        hide.setAccessible(true);
                        sHideMethod = hide;
                    }
                    hide.invoke(service);
                    if (reason != null && !sLoggedHide) {
                        sLoggedHide = true;
                        log(reason);
                    }
                } catch (Throwable ignored) {
                }
            }
        });
    }

    private static boolean isOverlayVisible(Object service) {
        try {
            Field field = sOverlayViewField;
            if (field == null) {
                field = service.getClass().getDeclaredField("overlayView");
                field.setAccessible(true);
                sOverlayViewField = field;
            }
            return field.get(service) != null;
        } catch (Throwable ignored) {
            return false;
        }
    }

    private static void refreshCamera(Object service) {
        if (sRefreshing) {
            return;
        }
        sRefreshing = true;
        try {
            String output = exec(service, CMD_CAMERA);
            sLastCameraPollAt = SystemClock.elapsedRealtime();
            if (output == null) {
                // ADB 链路异常：不再让主线程反复尝试，交给后台轮询慢慢恢复
                sPollFailed = true;
                return;
            }
            sPollFailed = false;
            boolean active = false;
            Matcher client = CLIENT_PATTERN.matcher(output);
            while (client.find()) {
                if (!"com.xiaopeng.qa.camera".equals(client.group(1))) {
                    active = true;
                    break;
                }
            }
            if (active != sFactoryAvm) {
                sFactoryAvm = active;
                log(active ? "检测到原厂 360/窄道全景已占用 2 号摄像头"
                        : "原厂 360/窄道全景已释放 2 号摄像头");
            }
        } finally {
            sRefreshing = false;
        }
    }

    private static void refreshCar(Object service) {
        if (sRefreshing) {
            return;
        }
        sRefreshing = true;
        try {
            String output = exec(service, CMD_CAR);
            sLastCarPollAt = SystemClock.elapsedRealtime();
            if (output == null) {
                sPollFailed = true;
                return;
            }
            sPollFailed = false;
            boolean parsed = false;
            boolean left = sLeftOn;
            boolean right = sRightOn;
            try {
                Matcher both = BOTH_PATTERN.matcher(output);
                if (both.find()) {
                    left = parseInt(both.group(1)) != 0;
                    right = parseInt(both.group(2)) != 0;
                    parsed = true;
                } else {
                    Matcher m = LEFT_PATTERN.matcher(output);
                    if (m.find()) {
                        left = parseInt(m.group(1)) != 0;
                        parsed = true;
                    }
                    m = RIGHT_PATTERN.matcher(output);
                    if (m.find()) {
                        right = parseInt(m.group(1)) != 0;
                        parsed = true;
                    }
                }
            } catch (Throwable ignored) {
            }
            if (parsed) {
                sHazard = left && right;
                sLeftOn = left;
                sRightOn = right;
            }
            try {
                Matcher gear = GEAR_PATTERN.matcher(output);
                if (gear.find()) {
                    sGear = parseInt(gear.group(1));
            if (sGear == 2 || sGear == 3 || sGear == 4) {
                sNonDrivePolls++;
            } else {
                sNonDrivePolls = 0;
            }
            if (sNonDrivePolls >= 2) {
                Object svc = sService;
                boolean debug = svc instanceof android.content.Context
                        && OverlayPresets.isDebugMode((android.content.Context) svc);
                if (!debug) {
                    hideOverlay("\u975e D \u6863\uff0c\u6536\u8d77\u4fa7\u89c6\u6d6e\u7a97");
                }
            }
                }
                Matcher avm = AVM_MODE_PATTERN.matcher(output);
                if (avm.find()) {
                    sAvmMode = parseInt(avm.group(1));
                }
                Matcher fm = FOCUS_PATTERN.matcher(output);
                if (fm.find()) {
                    sForegroundPackage = fm.group(1);
                }
                Matcher bl = BSD_LEFT_PATTERN.matcher(output);
                if (bl.find()) {
                    sBsdLeft = parseInt(bl.group(1)) != 0;
                    sLastBsdAt = SystemClock.elapsedRealtime();
                }
                Matcher br = BSD_RIGHT_PATTERN.matcher(output);
                if (br.find()) {
                    sBsdRight = parseInt(br.group(1)) != 0;
                    sLastBsdAt = SystemClock.elapsedRealtime();
                }
                final Object svcForWarn = sService;
                MAIN.post(new Runnable() {
                    @Override
                    public void run() {
                        SideWarning.update(svcForWarn);
                    }
                });
            } catch (Throwable ignored) {
            }
        } finally {
            sRefreshing = false;
        }
    }

    private static String exec(Object service, String command) {
        if (service == null) {
            return null;
        }
        try {
            Field field = sAdbField;
            if (field == null) {
                field = service.getClass().getDeclaredField("adb");
                field.setAccessible(true);
                sAdbField = field;
            }
            Object adb = field.get(service);
            if (adb == null) {
                return null;
            }
            Method method = sAdbExecMethod;
            if (method == null) {
                method = adb.getClass().getMethod("exec", String.class);
                sAdbExecMethod = method;
            }
            Object result = method.invoke(adb, command);
            return result instanceof String ? (String) result : null;
        } catch (Throwable ignored) {
            return null;
        }
    }

    private static int parseInt(String text) {
        try {
            return Integer.parseInt(text.trim());
        } catch (Throwable ignored) {
            return 0;
        }
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
