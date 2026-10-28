.class public Lcom/xiaopeng/qa/camera/CameraOverlayService;
.super Landroid/app/Service;
.source "CameraOverlayService.java"

# interfaces
.implements Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;


# static fields
.field private static final ACTION_ALIGN_RIGHT_TO_LEFT:Ljava/lang/String; = "com.xiaopeng.qa.camera.ALIGN_RIGHT_TO_LEFT"

.field private static final ACTION_APPLY_SIZE:Ljava/lang/String; = "com.xiaopeng.qa.camera.APPLY_SIZE"

.field private static final ACTION_HIDE_ALL:Ljava/lang/String; = "com.xiaopeng.qa.camera.HIDE_ALL"

.field private static final ACTION_HIDE_MANUAL:Ljava/lang/String; = "com.xiaopeng.qa.camera.HIDE_MANUAL"

.field private static final ACTION_RECORD_POS:Ljava/lang/String; = "com.xiaopeng.qa.camera.RECORD_POS"

.field private static final ACTION_RESET_OVERLAY:Ljava/lang/String; = "com.xiaopeng.qa.camera.RESET_OVERLAY"

.field private static final ACTION_SHOW_MANUAL:Ljava/lang/String; = "com.xiaopeng.qa.camera.SHOW_MANUAL"

.field private static final ACTION_START_LINK:Ljava/lang/String; = "com.xiaopeng.qa.camera.START_LINK"

.field private static final ACTION_STOP_LINK:Ljava/lang/String; = "com.xiaopeng.qa.camera.STOP_LINK"

.field private static final BUFFER_H:I = 0x2d0

.field private static final BUFFER_W:I = 0x500

.field private static final CAM_SCALE_DEFAULT:F = 1.0f

.field private static final CAM_SCALE_MAX:F = 4.0f

.field private static final CAM_SCALE_MIN:F = 0.2f

.field private static final CHANNEL_ID:Ljava/lang/String; = "cameraassist_overlay"

.field public static final EXTRA_HOST:Ljava/lang/String; = "host"

.field public static final EXTRA_PORT:Ljava/lang/String; = "port"

.field private static final MIN_SIZE_RATIO:F = 0.15f

.field private static final NOTIF_ID:I = 0x1

.field private static final OVERLAY_DEF_W_RATIO:F = 0.4f

.field private static final PREFS_NAME:Ljava/lang/String; = "cameraassist"

.field private static final TAG:Ljava/lang/String; = "CameraAssist"

.field private static final linkActive:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private static final manualVisible:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private static final recentLogs:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# instance fields
.field private adb:Lcom/xiaopeng/qa/camera/AdbClient;

.field private avmModeActive:Z

.field private bgHandler:Landroid/os/Handler;

.field private bgThread:Landroid/os/HandlerThread;

.field private borderView:Landroid/view/View;

.field private bufferH:I

.field private bufferW:I

.field private camScale:F

.field private cameraDevice:Landroid/hardware/camera2/CameraDevice;

.field private cameraId:Ljava/lang/String;

.field private cameraManager:Landroid/hardware/camera2/CameraManager;

.field private captureSession:Landroid/hardware/camera2/CameraCaptureSession;

.field private closeSuppressedDir:Ljava/lang/String;

.field private cropHandleB:Landroid/view/View;

.field private cropHandleL:Landroid/view/View;

.field private cropHandleR:Landroid/view/View;

.field private cropHandleT:Landroid/view/View;

.field private final deviceCallback:Landroid/hardware/camera2/CameraDevice$StateCallback;

.field private direction:Ljava/lang/String;

.field private editHintView:Landroid/widget/TextView;

.field private editMode:Z

.field private labelView:Landroid/widget/TextView;

.field private lastActiveDir:Ljava/lang/String;

.field private mainHandler:Landroid/os/Handler;

.field private monitor:Lcom/xiaopeng/qa/camera/SignalMonitor;

.field private openedDirection:Ljava/lang/String;

.field private overlayView:Landroid/view/View;

.field private panX:F

.field private panY:F

.field private previewSurface:Landroid/view/Surface;

.field private final surfaceListener:Landroid/view/TextureView$SurfaceTextureListener;

.field private textureView:Landroid/view/TextureView;

.field private wm:Landroid/view/WindowManager;


# direct methods
.method static constructor <clinit>()V
    .locals 2

    .line 90
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    sput-object v0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->linkActive:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 92
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-direct {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    sput-object v0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->manualVisible:Ljava/util/concurrent/atomic/AtomicBoolean;

    .line 94
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 95
    invoke-static {v0}, Ljava/util/Collections;->synchronizedList(Ljava/util/List;)Ljava/util/List;

    move-result-object v0

    sput-object v0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->recentLogs:Ljava/util/List;

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 53
    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    const/16 v0, 0x500

    .line 104
    iput v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bufferW:I

    const/16 v0, 0x2d0

    .line 105
    iput v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bufferH:I

    const/4 v0, 0x0

    .line 109
    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editMode:Z

    const/high16 v1, 0x3f800000    # 1.0f

    .line 111
    iput v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    const/4 v1, 0x0

    .line 114
    iput v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    .line 116
    iput v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    const-string v1, "LEFT"

    .line 133
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    const/4 v1, 0x0

    .line 135
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->openedDirection:Ljava/lang/String;

    .line 137
    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->avmModeActive:Z

    .line 140
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->lastActiveDir:Ljava/lang/String;

    .line 145
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->closeSuppressedDir:Ljava/lang/String;

    .line 1447
    new-instance v0, Lcom/xiaopeng/qa/camera/CameraOverlayService$7;

    invoke-direct {v0, p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService$7;-><init>(Lcom/xiaopeng/qa/camera/CameraOverlayService;)V

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->surfaceListener:Landroid/view/TextureView$SurfaceTextureListener;

    .line 1683
    new-instance v0, Lcom/xiaopeng/qa/camera/CameraOverlayService$8;

    invoke-direct {v0, p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService$8;-><init>(Lcom/xiaopeng/qa/camera/CameraOverlayService;)V

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->deviceCallback:Landroid/hardware/camera2/CameraDevice$StateCallback;

    return-void
.end method

.method static synthetic access$000(Ljava/lang/String;)V
    .locals 0

    .line 53
    invoke-static {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$100(Lcom/xiaopeng/qa/camera/CameraOverlayService;)Ljava/lang/String;
    .locals 0

    .line 53
    iget-object p0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->closeSuppressedDir:Ljava/lang/String;

    return-object p0
.end method

.method static synthetic access$1000(Lcom/xiaopeng/qa/camera/CameraOverlayService;)Z
    .locals 0

    .line 53
    iget-boolean p0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editMode:Z

    return p0
.end method

.method static synthetic access$102(Lcom/xiaopeng/qa/camera/CameraOverlayService;Ljava/lang/String;)Ljava/lang/String;
    .locals 0

    .line 53
    iput-object p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->closeSuppressedDir:Ljava/lang/String;

    return-object p1
.end method

.method static synthetic access$1100(Lcom/xiaopeng/qa/camera/CameraOverlayService;Landroid/view/MotionEvent;)F
    .locals 0

    .line 53
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->computeSpan(Landroid/view/MotionEvent;)F

    move-result p0

    return p0
.end method

.method static synthetic access$1200(Lcom/xiaopeng/qa/camera/CameraOverlayService;)F
    .locals 0

    .line 53
    iget p0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    return p0
.end method

.method static synthetic access$1300(Lcom/xiaopeng/qa/camera/CameraOverlayService;F)V
    .locals 0

    .line 53
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyCamScale(F)V

    return-void
.end method

.method static synthetic access$1400(Lcom/xiaopeng/qa/camera/CameraOverlayService;)V
    .locals 0

    .line 53
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyRenderTransform()V

    return-void
.end method

.method static synthetic access$1500(Lcom/xiaopeng/qa/camera/CameraOverlayService;)Landroid/view/WindowManager;
    .locals 0

    .line 53
    iget-object p0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    return-object p0
.end method

.method static synthetic access$1600(Lcom/xiaopeng/qa/camera/CameraOverlayService;I)V
    .locals 0

    .line 53
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->sendAvmMode(I)V

    return-void
.end method

.method static synthetic access$1700(Lcom/xiaopeng/qa/camera/CameraOverlayService;)Landroid/hardware/camera2/CameraDevice;
    .locals 0

    .line 53
    iget-object p0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraDevice:Landroid/hardware/camera2/CameraDevice;

    return-object p0
.end method

.method static synthetic access$1702(Lcom/xiaopeng/qa/camera/CameraOverlayService;Landroid/hardware/camera2/CameraDevice;)Landroid/hardware/camera2/CameraDevice;
    .locals 0

    .line 53
    iput-object p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraDevice:Landroid/hardware/camera2/CameraDevice;

    return-object p1
.end method

.method static synthetic access$1800(Lcom/xiaopeng/qa/camera/CameraOverlayService;)V
    .locals 0

    .line 53
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->createPreviewSession()V

    return-void
.end method

.method static synthetic access$1900(Lcom/xiaopeng/qa/camera/CameraOverlayService;)V
    .locals 0

    .line 53
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->releaseCamera()V

    return-void
.end method

.method static synthetic access$200(Lcom/xiaopeng/qa/camera/CameraOverlayService;Ljava/lang/String;)V
    .locals 0

    .line 53
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->showOverlayForDirection(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$2000(Lcom/xiaopeng/qa/camera/CameraOverlayService;)Landroid/view/TextureView;
    .locals 0

    .line 53
    iget-object p0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    return-object p0
.end method

.method static synthetic access$2102(Lcom/xiaopeng/qa/camera/CameraOverlayService;Landroid/hardware/camera2/CameraCaptureSession;)Landroid/hardware/camera2/CameraCaptureSession;
    .locals 0

    .line 53
    iput-object p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->captureSession:Landroid/hardware/camera2/CameraCaptureSession;

    return-object p1
.end method

.method static synthetic access$2200(Lcom/xiaopeng/qa/camera/CameraOverlayService;)Landroid/os/Handler;
    .locals 0

    .line 53
    iget-object p0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bgHandler:Landroid/os/Handler;

    return-object p0
.end method

.method static synthetic access$300(Lcom/xiaopeng/qa/camera/CameraOverlayService;)V
    .locals 0

    .line 53
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->hideOverlayAndCamera()V

    return-void
.end method

.method static synthetic access$400(Lcom/xiaopeng/qa/camera/CameraOverlayService;)V
    .locals 0

    .line 53
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->closeOverlayFromButton()V

    return-void
.end method

.method static synthetic access$500(Lcom/xiaopeng/qa/camera/CameraOverlayService;)Landroid/view/View;
    .locals 0

    .line 53
    iget-object p0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    return-object p0
.end method

.method static synthetic access$600(Lcom/xiaopeng/qa/camera/CameraOverlayService;)F
    .locals 0

    .line 53
    iget p0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    return p0
.end method

.method static synthetic access$602(Lcom/xiaopeng/qa/camera/CameraOverlayService;F)F
    .locals 0

    .line 53
    iput p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    return p1
.end method

.method static synthetic access$700(Lcom/xiaopeng/qa/camera/CameraOverlayService;)F
    .locals 0

    .line 53
    iget p0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    return p0
.end method

.method static synthetic access$702(Lcom/xiaopeng/qa/camera/CameraOverlayService;F)F
    .locals 0

    .line 53
    iput p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    return p1
.end method

.method static synthetic access$800(Lcom/xiaopeng/qa/camera/CameraOverlayService;)Ljava/lang/String;
    .locals 0

    .line 53
    iget-object p0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    return-object p0
.end method

.method static synthetic access$900(Lcom/xiaopeng/qa/camera/CameraOverlayService;)V
    .locals 0

    .line 53
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->toggleEditMode()V

    return-void
.end method

.method public static alignRightToLeft(Landroid/content/Context;)V
    .locals 2

    .line 207
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/xiaopeng/qa/camera/CameraOverlayService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "com.xiaopeng.qa.camera.ALIGN_RIGHT_TO_LEFT"

    .line 208
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 209
    invoke-static {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->safeStart(Landroid/content/Context;Landroid/content/Intent;)V

    return-void
.end method

.method private alignRightToLeftInternal()V
    .locals 1

    # 通用“刷新浮窗位置”动作：位置已在 prefs 里写好，这里只让当前浮窗立即生效
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-eqz v0, :cond_0

    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyOverlayConfigForDirection()V

    :cond_0
    return-void
.end method

.method private applyCamScale(F)V
    .locals 2

    const v0, 0x3e4ccccd    # 0.2f

    cmpg-float v1, p1, v0

    if-gez v1, :cond_0

    const p1, 0x3e4ccccd    # 0.2f

    :cond_0
    const/high16 v0, 0x40800000    # 4.0f

    cmpl-float v1, p1, v0

    if-lez v1, :cond_1

    const/high16 p1, 0x40800000    # 4.0f

    .line 1099
    :cond_1
    iput p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    .line 1100
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyRenderTransform()V

    return-void
.end method

.method private applyOverlayConfigForDirection()V
    .locals 10

    .line 1260
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-nez v0, :cond_0

    return-void

    .line 1261
    :cond_0
    iget-boolean v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editMode:Z

    if-eqz v0, :cond_1

    const-string v0, "MANUAL"

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 1262
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->saveEditConfigInternal()V

    :cond_1
    const/4 v0, 0x0

    .line 1264
    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editMode:Z

    .line 1265
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->borderView:Landroid/view/View;

    const/16 v2, 0x8

    if-eqz v1, :cond_2

    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    .line 1266
    :cond_2
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleL:Landroid/view/View;

    if-eqz v1, :cond_3

    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    .line 1267
    :cond_3
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleR:Landroid/view/View;

    if-eqz v1, :cond_4

    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    .line 1268
    :cond_4
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleT:Landroid/view/View;

    if-eqz v1, :cond_5

    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    .line 1269
    :cond_5
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleB:Landroid/view/View;

    if-eqz v1, :cond_6

    invoke-virtual {v1, v2}, Landroid/view/View;->setVisibility(I)V

    .line 1270
    :cond_6
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editHintView:Landroid/widget/TextView;

    if-eqz v1, :cond_7

    const-string v2, "\u62d6\u52a8\u9ec4\u8272\u8fb9\u7f18\u8c03\u6574\u7a97\u53e3\u5f62\u72b6\uff0c\u53cc\u51fb\u9000\u51fa\u5e76\u4fdd\u5b58"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1271
    :cond_7
    new-instance v1, Landroid/util/DisplayMetrics;

    invoke-direct {v1}, Landroid/util/DisplayMetrics;-><init>()V

    .line 1272
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    invoke-interface {v2}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v2

    invoke-virtual {v2, v1}, Landroid/view/Display;->getRealMetrics(Landroid/util/DisplayMetrics;)V

    const-string v2, "cameraassist"

    .line 1273
    invoke-virtual {p0, v2, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 1274
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    const-string v4, "LEFT"

    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_8

    const-string v3, "left_"

    goto :goto_0

    :cond_8
    const-string v3, "right_"

    .line 1275
    :goto_0
    iget v5, v1, Landroid/util/DisplayMetrics;->widthPixels:I

    invoke-direct {p0, v5}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readOverlayW(I)I

    move-result v5

    .line 1276
    iget v6, v1, Landroid/util/DisplayMetrics;->heightPixels:I

    invoke-direct {p0, v6}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readOverlayH(I)I

    move-result v6

    .line 1277
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readCamScale()F

    move-result v7

    iput v7, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    .line 1278
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readPanX()F

    move-result v7

    iput v7, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    .line 1279
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readPanY()F

    move-result v7

    iput v7, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    const-string v7, "overlay_pos_recorded"

    .line 1280
    invoke-virtual {v3, v7}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    invoke-interface {v2, v7, v0}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    .line 1281
    iget-object v7, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    invoke-virtual {v7}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v7

    check-cast v7, Landroid/view/WindowManager$LayoutParams;

    .line 1282
    iput v5, v7, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 1283
    iput v6, v7, Landroid/view/WindowManager$LayoutParams;->height:I

    const/16 v8, 0x78

    if-eqz v0, :cond_a

    const-string v0, "overlay_pos_x"

    .line 1285
    invoke-virtual {v3, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iget-object v9, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v4, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_9

    const/16 v4, 0x78

    goto :goto_1

    :cond_9
    iget v4, v1, Landroid/util/DisplayMetrics;->widthPixels:I

    sub-int/2addr v4, v5

    sub-int/2addr v4, v8

    :goto_1
    invoke-interface {v2, v0, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    iput v0, v7, Landroid/view/WindowManager$LayoutParams;->x:I

    const-string v0, "overlay_pos_y"

    .line 1286
    invoke-virtual {v3, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iget v1, v1, Landroid/util/DisplayMetrics;->heightPixels:I

    sub-int/2addr v1, v6

    sub-int/2addr v1, v8

    invoke-interface {v2, v0, v1}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    iput v0, v7, Landroid/view/WindowManager$LayoutParams;->y:I

    goto :goto_3

    .line 1288
    :cond_a
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_b

    const/16 v0, 0x78

    goto :goto_2

    :cond_b
    iget v0, v1, Landroid/util/DisplayMetrics;->widthPixels:I

    sub-int/2addr v0, v5

    sub-int/2addr v0, v8

    :goto_2
    iput v0, v7, Landroid/view/WindowManager$LayoutParams;->x:I

    .line 1289
    iget v0, v1, Landroid/util/DisplayMetrics;->heightPixels:I

    sub-int/2addr v0, v6

    sub-int/2addr v0, v8

    iput v0, v7, Landroid/view/WindowManager$LayoutParams;->y:I

    .line 1292
    :goto_3
    :try_start_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    invoke-interface {v0, v1, v7}, Landroid/view/WindowManager;->updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1295
    :catch_0
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyRenderTransform()V

    .line 1296
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u65b9\u5411\u5207\u6362\uff0c\u5df2\u5e94\u7528 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " \u6d6e\u7a97\u914d\u7f6e"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    return-void
.end method

.method public static applyOverlaySize(Landroid/content/Context;)V
    .locals 2

    .line 192
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/xiaopeng/qa/camera/CameraOverlayService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "com.xiaopeng.qa.camera.APPLY_SIZE"

    .line 193
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 194
    invoke-static {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->safeStart(Landroid/content/Context;Landroid/content/Intent;)V

    return-void
.end method

.method private applyOverlaySizeInternal()V
    .locals 9

    .line 817
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-nez v0, :cond_0

    return-void

    .line 818
    :cond_0

    new-instance v0, Landroid/util/DisplayMetrics;

    invoke-direct {v0}, Landroid/util/DisplayMetrics;-><init>()V

    .line 819
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    invoke-interface {v1}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v1

    invoke-virtual {v1, v0}, Landroid/view/Display;->getRealMetrics(Landroid/util/DisplayMetrics;)V

    .line 820
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    check-cast v1, Landroid/view/WindowManager$LayoutParams;

    .line 823
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    const-string v3, "MANUAL"

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 824
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readOverlayScale()F

    move-result v2

    .line 825
    iget v4, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    int-to-float v4, v4

    mul-float v4, v4, v2

    float-to-int v2, v4

    int-to-float v4, v2

    const/high16 v5, 0x41100000    # 9.0f

    mul-float v4, v4, v5

    const/high16 v5, 0x41800000    # 16.0f

    div-float/2addr v4, v5

    float-to-int v4, v4

    .line 827
    iget v5, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    if-le v4, v5, :cond_1

    iget v4, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    :cond_1
    const/high16 v5, 0x3f800000    # 1.0f

    .line 828
    iput v5, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    goto :goto_0

    .line 830
    :cond_2
    iget v2, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    iget v4, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    invoke-direct {p0, v2, v4}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->migrateLegacyOverlayScale(II)V

    .line 831
    iget v2, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    invoke-direct {p0, v2}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readOverlayW(I)I

    move-result v2

    .line 832
    iget v4, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    invoke-direct {p0, v4}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readOverlayH(I)I

    move-result v4

    .line 833
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readCamScale()F

    move-result v5

    iput v5, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    .line 834
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readPanX()F

    move-result v5

    iput v5, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    .line 835
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readPanY()F

    move-result v5

    iput v5, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    .line 837
    :goto_0
    iput v2, v1, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 838
    iput v4, v1, Landroid/view/WindowManager$LayoutParams;->height:I

    const-string v5, "cameraassist"

    const/4 v6, 0x0

    .line 840
    invoke-virtual {p0, v5, v6}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v5

    .line 841
    iget-object v7, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v3, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-nez v3, :cond_5

    .line 842
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    const-string v7, "LEFT"

    invoke-virtual {v7, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_3

    const-string v3, "left_"

    goto :goto_1

    :cond_3
    const-string v3, "right_"

    :goto_1
    const-string v8, "overlay_pos_recorded"

    .line 843
    invoke-virtual {v3, v8}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-interface {v5, v3, v6}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v3

    if-nez v3, :cond_5

    .line 845
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v7, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const/16 v5, 0x78

    if-eqz v3, :cond_4

    const/16 v3, 0x78

    goto :goto_2

    :cond_4
    iget v3, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    sub-int/2addr v3, v2

    sub-int/2addr v3, v5

    :goto_2
    iput v3, v1, Landroid/view/WindowManager$LayoutParams;->x:I

    .line 846
    iget v0, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    sub-int/2addr v0, v4

    sub-int/2addr v0, v5

    iput v0, v1, Landroid/view/WindowManager$LayoutParams;->y:I

    .line 850
    :cond_5
    :try_start_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    invoke-interface {v0, v2, v1}, Landroid/view/WindowManager;->updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_3

    :catch_0
    move-exception v0

    const-string v1, "CameraAssist"

    const-string v2, "applyOverlaySize update failed"

    .line 852
    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 854
    :goto_3
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyRenderTransform()V

    return-void
.end method

.method private applyRenderTransform()V
    .locals 14

    .line 1111
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-eqz v0, :cond_b

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    if-nez v1, :cond_0

    goto/16 :goto_6

    .line 1114
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/view/WindowManager$LayoutParams;

    .line 1115
    iget v1, v0, Landroid/view/WindowManager$LayoutParams;->width:I

    .line 1116
    iget v0, v0, Landroid/view/WindowManager$LayoutParams;->height:I

    if-lez v1, :cond_1

    if-gtz v0, :cond_2

    .line 1118
    :cond_1
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    invoke-virtual {v0}, Landroid/view/TextureView;->getWidth()I

    move-result v1

    .line 1119
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    invoke-virtual {v0}, Landroid/view/TextureView;->getHeight()I

    move-result v0

    .line 1121
    :cond_2
    # 按浮窗实际尺寸计算基准：窗口被拖动/缩放后，四宫格裁切仍然准确
    invoke-static {p0}, Lcom/xiaopeng/qa/camera/OverlayPresets;->isRotate90(Landroid/content/Context;)Z

    move-result v11

    if-eqz v11, :no_rot_dims

    move v11, v1

    move v1, v0

    move v0, v11

    :no_rot_dims
    int-to-float v2, v1

    int-to-float v3, v0

    .line 1125
    # 固定按 1.0 比例计算四宫格裁切，避免用户缩放参数导致取景错位
    iget v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    const v5, 0x3e4ccccd    # 0.2f

    cmpg-float v6, v4, v5

    if-gez v6, :cond_3

    const v4, 0x3e4ccccd    # 0.2f

    :cond_3
    const/high16 v5, 0x40800000    # 4.0f

    cmpl-float v6, v4, v5

    if-lez v6, :cond_4

    const/high16 v4, 0x40800000    # 4.0f

    :cond_4
    mul-float v2, v2, v4

    mul-float v3, v3, v4

    const/high16 v4, 0x44a00000    # 1280.0f

    div-float v4, v2, v4

    .line 1140
    iget-object v5, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    const-string v6, "LEFT"

    invoke-virtual {v6, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    const/4 v7, 0x1

    const/4 v8, 0x0

    if-nez v5, :cond_6

    const-string v5, "RIGHT"

    iget-object v9, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v5, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_5

    goto :goto_0

    :cond_5
    const/4 v5, 0x0

    goto :goto_1

    :cond_6
    :goto_0
    const/4 v5, 0x1

    :goto_1
    if-eqz v5, :cond_8

    .line 1143
    iget-object v5, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v6, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_7

    const-string v5, "left_"

    goto :goto_2

    :cond_7
    const-string v5, "right_"

    :goto_2
    const-string v9, "cameraassist"

    .line 1144
    invoke-virtual {p0, v9, v8}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v9

    const-string v10, "cam_scale"

    invoke-virtual {v5, v10}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-interface {v9, v5}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v5

    # Camera1 使用 mode=8 四宫格，这里固定开启 2 倍裁切，取左下/右下鱼眼象限
    const/4 v5, 0x1

    goto :goto_3

    :cond_8
    const/4 v5, 0x0

    :goto_3
    const/high16 v9, 0x40000000    # 2.0f

    if-eqz v5, :cond_a

    .line 1148
    iget-object v5, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    const-string v6, "LEFT"

    invoke-virtual {v6, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    # scale = 2.0 * camScale  (v2 = width * camScale)
    int-to-float v10, v1

    div-float v6, v2, v10

    mul-float v4, v6, v9

    if-eqz v5, :cond_crop_right

    const/4 v5, 0x0

    int-to-float v5, v5

    goto :goto_4

    :cond_crop_right
    neg-float v5, v2

    :goto_4
    neg-float v10, v3

    iget v6, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    add-float/2addr v5, v6

    iget v6, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    add-float/2addr v10, v6

    # rear-side view: zoom 2x on the rear-middle of the side fish-eye
    invoke-static {p0}, Lcom/xiaopeng/qa/camera/OverlayPresets;->isRearSideView(Landroid/content/Context;)Z

    move-result v6

    if-eqz v6, :rear_side_off

    const/high16 v4, 0x40800000    # 4.0f

    int-to-float v10, v0

    const/high16 v11, 0x40200000    # 2.5f

    mul-float v10, v10, v11

    neg-float v10, v10

    iget-object v6, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    const-string v11, "LEFT"

    invoke-virtual {v11, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :rear_side_right

    const/4 v5, 0x0

    int-to-float v5, v5

    goto :rear_side_off

    :rear_side_right
    int-to-float v5, v1

    const/high16 v11, 0x40400000    # 3.0f

    mul-float v5, v5, v11

    neg-float v5, v5

    :rear_side_off
    goto :goto_5

    :cond_a
    int-to-float v5, v1

    sub-float/2addr v5, v2

    div-float/2addr v5, v9

    .line 1159
    iget v6, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    add-float/2addr v5, v6

    int-to-float v6, v0

    sub-float/2addr v6, v3

    div-float/2addr v6, v9

    .line 1160
    iget v9, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    add-float v10, v6, v9

    .line 1162
    :goto_5
    new-instance v6, Landroid/graphics/Matrix;

    invoke-direct {v6}, Landroid/graphics/Matrix;-><init>()V

    .line 1163
    invoke-virtual {v6}, Landroid/graphics/Matrix;->reset()V

    .line 1165
    invoke-virtual {v6, v4, v4}, Landroid/graphics/Matrix;->postScale(FF)Z

    .line 1166
    invoke-virtual {v6, v5, v10}, Landroid/graphics/Matrix;->postTranslate(FF)Z

    iget-object v11, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    const-string v5, "LEFT"

    invoke-virtual {v5, v11}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    iget-object v12, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    invoke-static {p0}, Lcom/xiaopeng/qa/camera/OverlayPresets;->isRotate90(Landroid/content/Context;)Z

    move-result v13

    if-eqz v13, :rot_view_off

    invoke-static {v12, v0, v1, v5}, Lcom/xiaopeng/qa/camera/OverlayPresets;->applyViewRotation(Landroid/view/TextureView;IIZ)V

    goto :rot_view_done

    :rot_view_off
    const/4 v13, 0x0

    invoke-static {v12, v13, v13, v13}, Lcom/xiaopeng/qa/camera/OverlayPresets;->applyViewRotation(Landroid/view/TextureView;IIZ)V

    :rot_view_done
    invoke-static {p0, v6, v1, v0, v5}, Lcom/xiaopeng/qa/camera/OverlayPresets;->applyFlip(Landroid/content/Context;Landroid/graphics/Matrix;IIZ)V

    .line 1167
    iget-object v5, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    invoke-virtual {v5, v6}, Landroid/view/TextureView;->setTransform(Landroid/graphics/Matrix;)V

    .line 1169
    new-instance v5, Ljava/lang/StringBuilder;

    const-string v6, "RT vw="

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " vh="

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " tv="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    invoke-virtual {v0}, Landroid/view/TextureView;->getWidth()I

    move-result v0

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "x"

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    invoke-virtual {v1}, Landroid/view/TextureView;->getHeight()I

    move-result v1

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " buf="

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bufferW:I

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bufferH:I

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " Wv="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    float-to-int v0, v2

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " Hv="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    float-to-int v0, v3

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " pan=("

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    float-to-int v0, v0

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ","

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    float-to-int v0, v0

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ") scale="

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-array v0, v7, [Ljava/lang/Object;

    .line 1171
    invoke-static {v4}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v1

    aput-object v1, v0, v8

    const-string v1, "%.4f"

    invoke-static {v1, v0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1169
    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    :cond_b
    :goto_6
    return-void
.end method

.method private static buildMethodSig(Ljava/lang/reflect/Method;)Ljava/lang/String;
    .locals 6

    .line 1628
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 1629
    invoke-virtual {p0}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v2, :cond_1

    aget-object v4, v1, v3

    .line 1630
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v5

    if-lez v5, :cond_0

    const-string v5, ", "

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1631
    :cond_0
    invoke-virtual {v4}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 1633
    :cond_1
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "("

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private callGetCmdControlParameters()Ljava/lang/Object;
    .locals 8

    const-string v0, "CameraAssist"

    .line 1548
    :try_start_0
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraManager:Landroid/hardware/camera2/CameraManager;

    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v1

    array-length v2, v1

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_0
    if-ge v4, v2, :cond_2

    aget-object v5, v1, v4

    const-string v6, "getCmdControlParameters"

    .line 1549
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_1

    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v6

    array-length v6, v6

    if-nez v6, :cond_1

    .line 1550
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraManager:Landroid/hardware/camera2/CameraManager;

    new-array v2, v3, [Ljava/lang/Object;

    invoke-virtual {v5, v1, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    .line 1551
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "AVM: getCmdControlParameters \u8c03\u7528\u6210\u529f -> "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez v1, :cond_0

    const-string v3, "null"

    goto :goto_1

    :cond_0
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v3

    :goto_1
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-object v1

    :cond_1
    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_2
    const-string v1, "AVM: CameraManager \u65e0 getCmdControlParameters() \u65b9\u6cd5\uff08\u624b\u673a\u65e0\u6b64\u63a5\u53e3\u5c5e\u9884\u671f\uff09"

    .line 1555
    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_2

    :catch_0
    move-exception v1

    .line 1557
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "AVM: getCmdControlParameters \u8c03\u7528\u5f02\u5e38: "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_2
    const/4 v0, 0x0

    return-object v0
.end method

.method private callSetCmdControlParameters(Ljava/lang/Object;)Z
    .locals 11

    const-string v0, "CameraAssist"

    const/4 v1, 0x0

    .line 1566
    :try_start_0
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    const-string v3, "flatten"

    new-array v4, v1, [Ljava/lang/Class;

    invoke-virtual {v2, v3, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    new-array v3, v1, [Ljava/lang/Object;

    invoke-virtual {v2, p1, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v2

    .line 1568
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "AVM: flatten() \u8c03\u7528\u5931\u8d25: "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v2, 0x0

    .line 1571
    :goto_0
    :try_start_1
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    .line 1572
    iget-object v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraManager:Landroid/hardware/camera2/CameraManager;

    invoke-virtual {v4}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/Class;->getMethods()[Ljava/lang/reflect/Method;

    move-result-object v4

    array-length v5, v4

    const/4 v6, 0x0

    :goto_1
    if-ge v6, v5, :cond_1

    aget-object v7, v4, v6

    const-string v8, "setCmdControlParameters"

    .line 1573
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v8, v9}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    if-eqz v8, :cond_0

    .line 1574
    invoke-interface {v3, v7}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    :cond_0
    add-int/lit8 v6, v6, 0x1

    goto :goto_1

    .line 1577
    :cond_1
    invoke-interface {v3}, Ljava/util/List;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_2

    const-string p1, "AVM: CameraManager \u65e0 setCmdControlParameters \u65b9\u6cd5\uff08\u624b\u673a\u65e0\u6b64\u63a5\u53e3\u5c5e\u9884\u671f\uff09"

    .line 1578
    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v1

    .line 1581
    :cond_2
    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v4

    :cond_3
    invoke-interface {v4}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    const/4 v6, 0x1

    if-eqz v5, :cond_4

    invoke-interface {v4}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/reflect/Method;

    .line 1582
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v7

    array-length v7, v7

    if-ne v7, v6, :cond_3

    .line 1583
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v7

    aget-object v7, v7, v1

    invoke-virtual {v7, p1}, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_3

    new-array v2, v6, [Ljava/lang/Object;

    aput-object p1, v2, v1

    .line 1584
    invoke-direct {p0, v5, v2}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->tryInvokeSet(Ljava/lang/reflect/Method;[Ljava/lang/Object;)Z

    move-result p1

    return p1

    :cond_4
    const/4 v4, 0x2

    if-eqz v2, :cond_8

    .line 1588
    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v5

    :cond_5
    invoke-interface {v5}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    if-eqz v7, :cond_6

    invoke-interface {v5}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/reflect/Method;

    .line 1589
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v8

    .line 1590
    array-length v9, v8

    if-ne v9, v4, :cond_5

    aget-object v9, v8, v1

    sget-object v10, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-ne v9, v10, :cond_5

    aget-object v8, v8, v6

    const-class v9, Ljava/lang/String;

    if-ne v8, v9, :cond_5

    new-array p1, v4, [Ljava/lang/Object;

    .line 1591
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, p1, v1

    aput-object v2, p1, v6

    invoke-direct {p0, v7, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->tryInvokeSet(Ljava/lang/reflect/Method;[Ljava/lang/Object;)Z

    move-result p1

    return p1

    .line 1594
    :cond_6
    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v5

    :cond_7
    invoke-interface {v5}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    if-eqz v7, :cond_8

    invoke-interface {v5}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/lang/reflect/Method;

    .line 1595
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v8

    array-length v8, v8

    if-ne v8, v6, :cond_7

    .line 1596
    invoke-virtual {v7}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v8

    aget-object v8, v8, v1

    const-class v9, Ljava/lang/String;

    if-ne v8, v9, :cond_7

    new-array p1, v6, [Ljava/lang/Object;

    aput-object v2, p1, v1

    .line 1597
    invoke-direct {p0, v7, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->tryInvokeSet(Ljava/lang/reflect/Method;[Ljava/lang/Object;)Z

    move-result p1

    return p1

    .line 1601
    :cond_8
    invoke-interface {v3}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_9
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_a

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/reflect/Method;

    .line 1602
    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v5

    .line 1603
    array-length v7, v5

    if-ne v7, v4, :cond_9

    aget-object v7, v5, v1

    sget-object v8, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-ne v7, v8, :cond_9

    aget-object v5, v5, v6

    invoke-virtual {v5, p1}, Ljava/lang/Class;->isInstance(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_9

    new-array v2, v4, [Ljava/lang/Object;

    .line 1604
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v2, v1

    aput-object p1, v2, v6

    invoke-direct {p0, v3, v2}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->tryInvokeSet(Ljava/lang/reflect/Method;[Ljava/lang/Object;)Z

    move-result p1

    return p1

    :cond_a
    const-string p1, "AVM: \u6240\u6709 setCmdControlParameters \u91cd\u8f7d\u5747\u5c1d\u8bd5\u5931\u8d25\u6216\u53c2\u6570\u4e0d\u5339\u914d"

    .line 1607
    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    goto :goto_2

    :catch_1
    move-exception p1

    .line 1609
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "AVM: setCmdControlParameters \u8c03\u7528\u5f02\u5e38: "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_2
    return v1
.end method

.method public static clearLogs()V
    .locals 2

    .line 249
    sget-object v0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->recentLogs:Ljava/util/List;

    monitor-enter v0

    .line 250
    :try_start_0
    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 251
    monitor-exit v0

    return-void

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method private closeCameraOnly()V
    .locals 2

    .line 1669
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->captureSession:Landroid/hardware/camera2/CameraCaptureSession;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 1670
    invoke-virtual {v0}, Landroid/hardware/camera2/CameraCaptureSession;->close()V

    .line 1671
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->captureSession:Landroid/hardware/camera2/CameraCaptureSession;

    .line 1673
    :cond_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraDevice:Landroid/hardware/camera2/CameraDevice;

    if-eqz v0, :cond_1

    .line 1674
    invoke-virtual {v0}, Landroid/hardware/camera2/CameraDevice;->close()V

    .line 1675
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraDevice:Landroid/hardware/camera2/CameraDevice;

    .line 1677
    :cond_1
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->previewSurface:Landroid/view/Surface;

    if-eqz v0, :cond_2

    .line 1678
    invoke-virtual {v0}, Landroid/view/Surface;->release()V

    .line 1679
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->previewSurface:Landroid/view/Surface;

    :cond_2
    return-void
.end method

.method private closeOverlayFromButton()V
    .locals 2

    .line 587
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-nez v0, :cond_0

    return-void

    :cond_0
    const-string v0, "MANUAL"

    .line 588
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 589
    sget-object v0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->manualVisible:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 590
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->hideOverlayAndCamera()V

    .line 591
    sget-object v0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->linkActive:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v0

    if-nez v0, :cond_1

    .line 592
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->stopSelfInternal()V

    :cond_1
    const-string v0, "\u624b\u52a8\u6d6e\u7a97\u5df2\u901a\u8fc7\u5173\u95ed\u6309\u94ae\u5173\u95ed"

    .line 594
    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    return-void

    .line 598
    :cond_2
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->closeSuppressedDir:Ljava/lang/String;

    .line 599
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->hideOverlayAndCamera()V

    .line 600
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u6d6e\u7a97\u5df2\u624b\u52a8\u5173\u95ed\uff08"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\uff09\uff0c\u8fdb\u5165\u5173\u95ed\u6291\u5236\uff1a\u540c\u65b9\u5411\u4eae\u8d77\u4e0d\u91cd\u5f00\uff0c\u7b491\u79d2\u7184\u706d\u6216\u6362\u65b9\u5411"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    return-void
.end method

.method private computeSpan(Landroid/view/MotionEvent;)F
    .locals 4

    .line 1022
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getPointerCount()I

    move-result v0

    const/4 v1, 0x2

    if-ge v0, v1, :cond_0

    const/4 p1, 0x0

    return p1

    :cond_0
    const/4 v0, 0x0

    .line 1023
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getX(I)F

    move-result v1

    const/4 v2, 0x1

    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getX(I)F

    move-result v3

    sub-float/2addr v1, v3

    .line 1024
    invoke-virtual {p1, v0}, Landroid/view/MotionEvent;->getY(I)F

    move-result v0

    invoke-virtual {p1, v2}, Landroid/view/MotionEvent;->getY(I)F

    move-result p1

    sub-float/2addr v0, p1

    mul-float v1, v1, v1

    mul-float v0, v0, v0

    add-float/2addr v1, v0

    float-to-double v0, v1

    .line 1025
    invoke-static {v0, v1}, Ljava/lang/Math;->sqrt(D)D

    move-result-wide v0

    double-to-float p1, v0

    return p1
.end method

.method private createNotificationChannel()V
    .locals 4

    .line 425
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_0

    .line 426
    new-instance v0, Landroid/app/NotificationChannel;

    const-string v1, "CameraAssist \u9884\u89c8"

    const/4 v2, 0x2

    const-string v3, "cameraassist_overlay"

    invoke-direct {v0, v3, v1, v2}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    const-string v1, "notification"

    .line 428
    invoke-virtual {p0, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/NotificationManager;

    .line 429
    invoke-virtual {v1, v0}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    :cond_0
    return-void
.end method

.method private createPreviewSession()V
    .locals 4

    .line 1706
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraDevice:Landroid/hardware/camera2/CameraDevice;

    if-eqz v0, :cond_3

    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    if-nez v0, :cond_0

    goto :goto_0

    .line 1708
    :cond_0
    :try_start_0
    invoke-virtual {v0}, Landroid/view/TextureView;->getSurfaceTexture()Landroid/graphics/SurfaceTexture;

    move-result-object v0

    if-nez v0, :cond_1

    return-void

    :cond_1
    const/16 v1, 0x2d0

    const/16 v2, 0x500

    .line 1710
    invoke-virtual {v0, v2, v1}, Landroid/graphics/SurfaceTexture;->setDefaultBufferSize(II)V

    .line 1711
    iput v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bufferW:I

    .line 1712
    iput v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bufferH:I

    .line 1713
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->previewSurface:Landroid/view/Surface;

    if-eqz v1, :cond_2

    .line 1714
    invoke-virtual {v1}, Landroid/view/Surface;->release()V

    const/4 v1, 0x0

    .line 1715
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->previewSurface:Landroid/view/Surface;

    .line 1717
    :cond_2
    new-instance v1, Landroid/view/Surface;

    invoke-direct {v1, v0}, Landroid/view/Surface;-><init>(Landroid/graphics/SurfaceTexture;)V

    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->previewSurface:Landroid/view/Surface;

    .line 1718
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraDevice:Landroid/hardware/camera2/CameraDevice;

    const/4 v1, 0x1

    .line 1719
    invoke-virtual {v0, v1}, Landroid/hardware/camera2/CameraDevice;->createCaptureRequest(I)Landroid/hardware/camera2/CaptureRequest$Builder;

    move-result-object v0

    .line 1720
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->previewSurface:Landroid/view/Surface;

    invoke-virtual {v0, v2}, Landroid/hardware/camera2/CaptureRequest$Builder;->addTarget(Landroid/view/Surface;)V

    .line 1721
    sget-object v2, Landroid/hardware/camera2/CaptureRequest;->CONTROL_MODE:Landroid/hardware/camera2/CaptureRequest$Key;

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, v2, v1}, Landroid/hardware/camera2/CaptureRequest$Builder;->set(Landroid/hardware/camera2/CaptureRequest$Key;Ljava/lang/Object;)V

    .line 1722
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraDevice:Landroid/hardware/camera2/CameraDevice;

    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->previewSurface:Landroid/view/Surface;

    invoke-static {v2}, Ljava/util/Collections;->singletonList(Ljava/lang/Object;)Ljava/util/List;

    move-result-object v2

    new-instance v3, Lcom/xiaopeng/qa/camera/CameraOverlayService$9;

    invoke-direct {v3, p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService$9;-><init>(Lcom/xiaopeng/qa/camera/CameraOverlayService;Landroid/hardware/camera2/CaptureRequest$Builder;)V

    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bgHandler:Landroid/os/Handler;

    invoke-virtual {v1, v2, v3, v0}, Landroid/hardware/camera2/CameraDevice;->createCaptureSession(Ljava/util/List;Landroid/hardware/camera2/CameraCaptureSession$StateCallback;Landroid/os/Handler;)V
    :try_end_0
    .catch Landroid/hardware/camera2/CameraAccessException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    const-string v1, "CameraAssist"

    const-string v2, "createPreviewSession failed"

    .line 1740
    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_3
    :goto_0
    return-void
.end method

.method private dp(I)I
    .locals 1

    int-to-float p1, p1

    .line 1030
    invoke-virtual {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    mul-float p1, p1, v0

    const/high16 v0, 0x3f000000    # 0.5f

    add-float/2addr p1, v0

    float-to-int p1, p1

    return p1
.end method

.method public static drainLogs()Ljava/util/List;
    .locals 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation

    .line 237
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 238
    sget-object v1, Lcom/xiaopeng/qa/camera/CameraOverlayService;->recentLogs:Ljava/util/List;

    monitor-enter v1

    .line 239
    :try_start_0
    invoke-interface {v1}, Ljava/util/List;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_0

    .line 240
    invoke-interface {v0, v1}, Ljava/util/List;->addAll(Ljava/util/Collection;)Z

    .line 241
    invoke-interface {v1}, Ljava/util/List;->clear()V

    .line 243
    :cond_0
    monitor-exit v1

    return-object v0

    :catchall_0
    move-exception v0

    monitor-exit v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v0
.end method

.method private ensureOverlay()V
    .locals 13

    .line 604
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const-string v0, "layout_inflater"

    .line 605
    invoke-virtual {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/LayoutInflater;

    const v1, 0x7f040002

    const/4 v2, 0x0

    .line 606
    invoke-virtual {v0, v1, v2}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    const v1, 0x7f030017

    .line 607
    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/view/TextureView;

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    .line 608
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    const v1, 0x7f030016

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->labelView:Landroid/widget/TextView;

    .line 609
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->updateLabel()V

    .line 611
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    const v1, 0x7f030013

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->borderView:Landroid/view/View;

    .line 612
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    const v1, 0x7f030010

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleL:Landroid/view/View;

    .line 613
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    const v1, 0x7f030011

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleR:Landroid/view/View;

    .line 614
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    const v1, 0x7f030012

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleT:Landroid/view/View;

    .line 615
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    const v1, 0x7f03000f

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleB:Landroid/view/View;

    .line 616
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    const v1, 0x7f030015

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/widget/TextView;

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editHintView:Landroid/widget/TextView;

    .line 617
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v1, 0x2

    .line 618
    invoke-direct {p0, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->dp(I)I

    move-result v1

    const/16 v3, -0x2676

    invoke-virtual {v0, v1, v3}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    const/4 v1, 0x0

    .line 619
    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    .line 620
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->borderView:Landroid/view/View;

    if-eqz v3, :cond_1

    invoke-virtual {v3, v0}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 621
    :cond_1
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editHintView:Landroid/widget/TextView;

    if-eqz v0, :cond_2

    const-string v3, ""

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/16 v3, 0x8

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setVisibility(I)V

    .line 623
    :cond_2
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    const v3, 0x7f030014

    invoke-virtual {v0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 625
    new-instance v3, Lcom/xiaopeng/qa/camera/CameraOverlayService$3;

    invoke-direct {v3, p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService$3;-><init>(Lcom/xiaopeng/qa/camera/CameraOverlayService;)V

    invoke-virtual {v0, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 633
    :cond_3
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleL:Landroid/view/View;

    const-string v3, "left"

    invoke-direct {p0, v0, v3}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->setupWindowEdgeHandle(Landroid/view/View;Ljava/lang/String;)V

    .line 634
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleR:Landroid/view/View;

    const-string v3, "right"

    invoke-direct {p0, v0, v3}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->setupWindowEdgeHandle(Landroid/view/View;Ljava/lang/String;)V

    .line 635
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleT:Landroid/view/View;

    const-string v3, "top"

    invoke-direct {p0, v0, v3}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->setupWindowEdgeHandle(Landroid/view/View;Ljava/lang/String;)V

    .line 636
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleB:Landroid/view/View;

    const-string v3, "bottom"

    invoke-direct {p0, v0, v3}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->setupWindowEdgeHandle(Landroid/view/View;Ljava/lang/String;)V

    .line 638
    new-instance v0, Landroid/util/DisplayMetrics;

    invoke-direct {v0}, Landroid/util/DisplayMetrics;-><init>()V

    .line 639
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    invoke-interface {v3}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v3

    invoke-virtual {v3, v0}, Landroid/view/Display;->getRealMetrics(Landroid/util/DisplayMetrics;)V

    const-string v3, "MANUAL"

    .line 642
    iget-object v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_5

    .line 646
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readOverlayScale()F

    move-result v4

    .line 647
    iget v5, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    int-to-float v5, v5

    mul-float v5, v5, v4

    float-to-int v4, v5

    int-to-float v5, v4

    const/high16 v6, 0x41100000    # 9.0f

    mul-float v5, v5, v6

    const/high16 v6, 0x41800000    # 16.0f

    div-float/2addr v5, v6

    float-to-int v5, v5

    .line 649
    iget v6, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    if-le v5, v6, :cond_4

    iget v5, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    :cond_4
    const/high16 v6, 0x3f800000    # 1.0f

    .line 650
    iput v6, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    goto :goto_0

    .line 652
    :cond_5
    iget v4, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    iget v5, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    invoke-direct {p0, v4, v5}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->migrateLegacyOverlayScale(II)V

    .line 653
    iget v4, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    invoke-direct {p0, v4}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readOverlayW(I)I

    move-result v4

    .line 654
    iget v5, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    invoke-direct {p0, v5}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readOverlayH(I)I

    move-result v5

    .line 655
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readCamScale()F

    move-result v6

    iput v6, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    .line 656
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readPanX()F

    move-result v6

    iput v6, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    .line 657
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readPanY()F

    move-result v6

    iput v6, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    .line 660
    :goto_0
    new-instance v6, Landroid/view/WindowManager$LayoutParams;

    const/16 v10, 0x7f6

    const/16 v11, 0x228

    const/4 v12, -0x3

    move-object v7, v6

    move v8, v4

    move v9, v5

    invoke-direct/range {v7 .. v12}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V

    const-string v7, "cameraassist"

    .line 667
    invoke-virtual {p0, v7, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v7

    const-string v8, "overlay_pos_recorded"

    const-string v9, "LEFT"

    if-eqz v3, :cond_6

    .line 673
    invoke-interface {v7, v8, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    .line 675
    iget v0, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    int-to-float v0, v0

    const/high16 v4, 0x3e800000    # 0.25f

    mul-float v0, v0, v4

    float-to-int v0, v0

    const/16 v4, 0x10

    goto :goto_3

    .line 678
    :cond_6
    iget-object v10, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_7

    const-string v10, "left_"

    goto :goto_1

    :cond_7
    const-string v10, "right_"

    .line 679
    :goto_1
    invoke-virtual {v10, v8}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    invoke-interface {v7, v8, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    .line 680
    iget-object v8, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v9, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v8

    const/16 v10, 0x78

    if-eqz v8, :cond_8

    const/16 v4, 0x78

    goto :goto_2

    :cond_8
    iget v8, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    sub-int/2addr v8, v4

    sub-int/2addr v8, v10

    move v4, v8

    .line 681
    :goto_2
    iget v0, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    sub-int/2addr v0, v5

    sub-int/2addr v0, v10

    :goto_3
    # 默认贴近屏幕顶部显示（原来在底部）
    const/16 v0, 0x5a

    const v5, 0x800033

    .line 684
    iput v5, v6, Landroid/view/WindowManager$LayoutParams;->gravity:I

    if-eqz v1, :cond_d

    if-eqz v3, :cond_9

    const-string v1, "overlay_pos_x"

    goto :goto_4

    .line 686
    :cond_9
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v9, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_a

    const-string v1, "left_overlay_pos_x"

    goto :goto_4

    :cond_a
    const-string v1, "right_overlay_pos_x"

    :goto_4
    invoke-interface {v7, v1, v4}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v1

    iput v1, v6, Landroid/view/WindowManager$LayoutParams;->x:I

    if-eqz v3, :cond_b

    const-string v1, "overlay_pos_y"

    goto :goto_5

    .line 687
    :cond_b
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v9, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_c

    const-string v1, "left_overlay_pos_y"

    goto :goto_5

    :cond_c
    const-string v1, "right_overlay_pos_y"

    :goto_5
    invoke-interface {v7, v1, v0}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    iput v0, v6, Landroid/view/WindowManager$LayoutParams;->y:I

    goto :goto_6

    .line 689
    :cond_d
    iput v4, v6, Landroid/view/WindowManager$LayoutParams;->x:I

    .line 690
    iput v0, v6, Landroid/view/WindowManager$LayoutParams;->y:I

    .line 693
    :goto_6
    :try_start_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    invoke-interface {v0, v1, v6}, Landroid/view/WindowManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_7

    :catch_0
    move-exception v0

    const-string v1, "CameraAssist"

    const-string v3, "addView overlay failed"

    .line 695
    invoke-static {v1, v3, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 696
    iput-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    .line 698
    :goto_7
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    invoke-direct {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->makeDraggable(Landroid/view/View;)V

    .line 699
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->surfaceListener:Landroid/view/TextureView$SurfaceTextureListener;

    invoke-virtual {v0, v1}, Landroid/view/TextureView;->setSurfaceTextureListener(Landroid/view/TextureView$SurfaceTextureListener;)V

    .line 701
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyOverlaySizeInternal()V

    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyRenderTransform()V

    return-void
.end method

.method private getAvmBinding(Ljava/lang/String;)I
    .locals 0

    const/16 p1, 0x8

    return p1
.end method

.method public static hideManual(Landroid/content/Context;)V
    .locals 2

    .line 178
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/xiaopeng/qa/camera/CameraOverlayService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "com.xiaopeng.qa.camera.HIDE_MANUAL"

    .line 179
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 180
    invoke-static {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->safeStart(Landroid/content/Context;Landroid/content/Intent;)V

    return-void
.end method

.method private hideOverlayAndCamera()V
    .locals 1

    const/4 v0, 0x0

    .line 574
    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->lastActiveDir:Ljava/lang/String;

    const/4 v0, 0x0

    .line 575
    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->avmModeActive:Z

    .line 576
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->removeOverlay()V

    .line 577
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->releaseCamera()V

    return-void
.end method

.method public static isLinkActive()Z
    .locals 1

    .line 228
    sget-object v0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->linkActive:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v0

    return v0
.end method

.method public static isManualVisible()Z
    .locals 1

    .line 232
    sget-object v0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->manualVisible:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v0

    return v0
.end method

.method private makeDraggable(Landroid/view/View;)V
    .locals 1

    if-nez p1, :cond_0

    return-void

    .line 879
    :cond_0
    new-instance v0, Lcom/xiaopeng/qa/camera/CameraOverlayService$4;

    invoke-direct {v0, p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService$4;-><init>(Lcom/xiaopeng/qa/camera/CameraOverlayService;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    return-void
.end method

.method private migrateLegacyOverlayScale(II)V
    .locals 11

    const-string v0, "cameraassist"

    const/4 v1, 0x0

    .line 772
    invoke-virtual {p0, v0, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 773
    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const/4 v3, 0x2

    new-array v4, v3, [Ljava/lang/String;

    const-string v5, "left_"

    aput-object v5, v4, v1

    const/4 v5, 0x1

    const-string v6, "right_"

    aput-object v6, v4, v5

    :goto_0
    if-ge v1, v3, :cond_4

    .line 774
    aget-object v5, v4, v1

    .line 775
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, "overlay_scale"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-interface {v0, v6}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_3

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, "overlay_w"

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-interface {v0, v6}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_3

    .line 776
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    const v9, 0x3ecccccd    # 0.4f

    invoke-interface {v0, v6, v9}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result v6

    const v9, 0x3e4ccccd    # 0.2f

    cmpg-float v10, v6, v9

    if-gez v10, :cond_0

    const v6, 0x3e4ccccd    # 0.2f

    :cond_0
    const/high16 v9, 0x3f800000    # 1.0f

    cmpl-float v10, v6, v9

    if-lez v10, :cond_1

    const/high16 v6, 0x3f800000    # 1.0f

    :cond_1
    int-to-float v9, p1

    mul-float v9, v9, v6

    float-to-int v6, v9

    int-to-float v9, v6

    const/high16 v10, 0x41100000    # 9.0f

    mul-float v9, v9, v10

    const/high16 v10, 0x41800000    # 16.0f

    div-float/2addr v9, v10

    float-to-int v9, v9

    if-le v9, p2, :cond_2

    move v9, p2

    .line 782
    :cond_2
    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v10, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v8

    invoke-interface {v2, v8, v6}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    .line 783
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, "overlay_h"

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-interface {v2, v6, v9}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    .line 785
    :cond_3
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-interface {v2, v6}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 786
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, "crop_l"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-interface {v2, v6}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 787
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, "crop_t"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-interface {v2, v6}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 788
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, "crop_r"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-interface {v2, v6}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 789
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "crop_b"

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-interface {v2, v5}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    add-int/lit8 v1, v1, 0x1

    goto/16 :goto_0

    .line 791
    :cond_4
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    return-void
.end method

.method private openCamera()V
    .locals 8

    move-object v5, p0
    iget-object v6, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;
    iget-object v7, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;
    invoke-static {v5, v6, v7}, Lcom/xiaopeng/qa/camera/Camera1Preview;->open(Landroid/content/Context;Landroid/view/TextureView;Ljava/lang/String;)Z
    move-result v5
    if-eqz v5, :cam2_path
    return-void

    :cam2_path
    const-string v0, "android.permission.CAMERA"

    .line 1481
    invoke-virtual {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->checkSelfPermission(Ljava/lang/String;)I

    move-result v0

    const-string v1, "CameraAssist"

    if-eqz v0, :cond_0

    const-string v0, "no CAMERA permission"

    .line 1483
    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 1487
    :cond_0
    :try_start_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraManager:Landroid/hardware/camera2/CameraManager;

    invoke-virtual {v0}, Landroid/hardware/camera2/CameraManager;->getCameraIdList()[Ljava/lang/String;

    move-result-object v0

    .line 1488
    array-length v2, v0

    if-nez v2, :cond_1

    const-string v0, "no camera device"

    .line 1489
    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 1492
    :cond_1
    invoke-direct {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->pickCameraId([Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraId:Ljava/lang/String;

    .line 1493
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    iput-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->openedDirection:Ljava/lang/String;

    .line 1494
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraManager:Landroid/hardware/camera2/CameraManager;

    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->deviceCallback:Landroid/hardware/camera2/CameraDevice$StateCallback;

    iget-object v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bgHandler:Landroid/os/Handler;

    invoke-virtual {v2, v0, v3, v4}, Landroid/hardware/camera2/CameraManager;->openCamera(Ljava/lang/String;Landroid/hardware/camera2/CameraDevice$StateCallback;Landroid/os/Handler;)V
    :try_end_0
    .catch Landroid/hardware/camera2/CameraAccessException; {:try_start_0 .. :try_end_0} :catch_1
    .catch Ljava/lang/SecurityException; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_1

    :catch_0
    move-exception v0

    goto :goto_0

    :catch_1
    move-exception v0

    :goto_0
    const-string v2, "openCamera failed"

    .line 1496
    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_1
    return-void
.end method

.method private pickCameraId([Ljava/lang/String;)Ljava/lang/String;
    .locals 6

    const-string v0, "cameraassist"

    const/4 v1, 0x0

    .line 1506
    invoke-virtual {p0, v0, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v2, "LEFT"

    .line 1507
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_0

    const-string v2, "left_camera_id"

    goto :goto_0

    :cond_0
    const-string v2, "right_camera_id"

    :goto_0
    const/4 v3, 0x0

    .line 1508
    invoke-interface {v0, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_2

    .line 1510
    array-length v2, p1

    const/4 v3, 0x0

    :goto_1
    if-ge v3, v2, :cond_2

    aget-object v4, p1, v3

    .line 1511
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_1

    return-object v4

    :cond_1
    add-int/lit8 v3, v3, 0x1

    goto :goto_1

    .line 1514
    :cond_2
    aget-object p1, p1, v1

    return-object p1
.end method

.method private readCamScale()F
    .locals 4

    const-string v0, "MANUAL"

    .line 743
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/high16 v1, 0x3f800000    # 1.0f

    if-eqz v0, :cond_0

    return v1

    :cond_0
    const-string v0, "cameraassist"

    const/4 v2, 0x0

    .line 744
    invoke-virtual {p0, v0, v2}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v2, "LEFT"

    .line 745
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    const-string v2, "left_"

    goto :goto_0

    :cond_1
    const-string v2, "right_"

    :goto_0
    const-string v3, "cam_scale"

    .line 746
    invoke-virtual {v2, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result v0

    const v1, 0x3e4ccccd    # 0.2f

    cmpg-float v2, v0, v1

    if-gez v2, :cond_2

    const v0, 0x3e4ccccd    # 0.2f

    :cond_2
    const/high16 v1, 0x40800000    # 4.0f

    cmpl-float v2, v0, v1

    if-lez v2, :cond_3

    const/high16 v0, 0x40800000    # 4.0f

    :cond_3
    return v0
.end method

.method private readOverlayH(I)I
    .locals 4

    const-string v0, "cameraassist"

    const/4 v1, 0x0

    .line 728
    invoke-virtual {p0, v0, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "LEFT"

    .line 729
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "left_"

    goto :goto_0

    :cond_0
    const-string v1, "right_"

    .line 730
    :goto_0
    new-instance v2, Landroid/util/DisplayMetrics;

    invoke-direct {v2}, Landroid/util/DisplayMetrics;-><init>()V

    .line 731
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    invoke-interface {v3}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v3

    invoke-virtual {v3, v2}, Landroid/view/Display;->getRealMetrics(Landroid/util/DisplayMetrics;)V

    .line 732
    iget v2, v2, Landroid/util/DisplayMetrics;->widthPixels:I

    int-to-float v2, v2

    const v3, 0x3ecccccd    # 0.4f

    mul-float v2, v2, v3

    float-to-int v2, v2

    int-to-float v2, v2

    const/high16 v3, 0x41100000    # 9.0f

    mul-float v2, v2, v3

    const/high16 v3, 0x41800000    # 16.0f

    div-float/2addr v2, v3

    float-to-int v2, v2

    const-string v3, "overlay_h"

    .line 734
    invoke-virtual {v1, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    int-to-float v1, p1

    const v2, 0x3e19999a    # 0.15f

    mul-float v1, v1, v2

    float-to-int v1, v1

    if-ge v0, v1, :cond_1

    move v0, v1

    :cond_1
    if-le v0, p1, :cond_2

    goto :goto_1

    :cond_2
    move p1, v0

    :goto_1
    return p1
.end method

.method private readOverlayScale()F
    .locals 3

    const-string v0, "cameraassist"

    const/4 v1, 0x0

    .line 707
    invoke-virtual {p0, v0, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "overlay_scale"

    const v2, 0x3ecccccd    # 0.4f

    .line 708
    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result v0

    const v1, 0x3e4ccccd    # 0.2f

    cmpg-float v2, v0, v1

    if-gez v2, :cond_0

    const v0, 0x3e4ccccd    # 0.2f

    :cond_0
    const/high16 v1, 0x3f800000    # 1.0f

    cmpl-float v2, v0, v1

    if-lez v2, :cond_1

    const/high16 v0, 0x3f800000    # 1.0f

    :cond_1
    return v0
.end method

.method private readOverlayW(I)I
    .locals 5

    const-string v0, "cameraassist"

    const/4 v1, 0x0

    .line 716
    invoke-virtual {p0, v0, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v1, "LEFT"

    .line 717
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_0

    const-string v1, "left_"

    goto :goto_0

    :cond_0
    const-string v1, "right_"

    :goto_0
    int-to-float v2, p1

    const v3, 0x3ecccccd    # 0.4f

    mul-float v3, v3, v2

    float-to-int v3, v3

    const-string v4, "overlay_w"

    .line 719
    invoke-virtual {v1, v4}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-interface {v0, v1, v3}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    const v1, 0x3e19999a    # 0.15f

    mul-float v2, v2, v1

    float-to-int v1, v2

    if-ge v0, v1, :cond_1

    move v0, v1

    :cond_1
    if-le v0, p1, :cond_2

    goto :goto_1

    :cond_2
    move p1, v0

    :goto_1
    return p1
.end method

.method private readPanX()F
    .locals 4

    const-string v0, "MANUAL"

    .line 755
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    return v1

    :cond_0
    const-string v0, "cameraassist"

    const/4 v2, 0x0

    .line 756
    invoke-virtual {p0, v0, v2}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v2, "LEFT"

    .line 757
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    const-string v2, "left_"

    goto :goto_0

    :cond_1
    const-string v2, "right_"

    :goto_0
    const-string v3, "pan_x"

    .line 758
    invoke-virtual {v2, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result v0

    return v0
.end method

.method private readPanY()F
    .locals 4

    const-string v0, "MANUAL"

    .line 763
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    return v1

    :cond_0
    const-string v0, "cameraassist"

    const/4 v2, 0x0

    .line 764
    invoke-virtual {p0, v0, v2}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v2, "LEFT"

    .line 765
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    const-string v2, "left_"

    goto :goto_0

    :cond_1
    const-string v2, "right_"

    :goto_0
    const-string v3, "pan_y"

    .line 766
    invoke-virtual {v2, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getFloat(Ljava/lang/String;F)F

    move-result v0

    return v0
.end method

.method private readRawAdbKey()[B
    .locals 6

    const/4 v0, 0x0

    .line 375
    :try_start_0
    invoke-virtual {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const/high16 v2, 0x7f060000

    invoke-virtual {v1, v2}, Landroid/content/res/Resources;->openRawResource(I)Ljava/io/InputStream;

    move-result-object v1

    .line 376
    new-instance v2, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v2}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v3, 0x1000

    new-array v3, v3, [B

    .line 379
    :goto_0
    invoke-virtual {v1, v3}, Ljava/io/InputStream;->read([B)I

    move-result v4

    const/4 v5, -0x1

    if-eq v4, v5, :cond_0

    .line 380
    invoke-virtual {v2, v3, v0, v4}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    .line 382
    :cond_0
    invoke-virtual {v1}, Ljava/io/InputStream;->close()V

    .line 383
    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    :catch_0
    move-exception v1

    .line 385
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "\u8bfb\u53d6\u5185\u7f6e\u5bc6\u94a5\u5931\u8d25: "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    new-array v0, v0, [B

    return-object v0
.end method

.method public static recordCurrentPosition(Landroid/content/Context;)V
    .locals 2

    .line 185
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/xiaopeng/qa/camera/CameraOverlayService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "com.xiaopeng.qa.camera.RECORD_POS"

    .line 186
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 187
    invoke-static {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->safeStart(Landroid/content/Context;Landroid/content/Intent;)V

    return-void
.end method

.method private recordPositionInternal()V
    .locals 6

    .line 797
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    const/4 v1, 0x0

    if-nez v0, :cond_0

    const-string v0, "\u8bf7\u5148\u6253\u5f00\u6d6e\u7a97\u5e76\u62d6\u52a8\u5230\u4f4d"

    .line 798
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    const-string v0, "\u8bb0\u5f55\u4f4d\u7f6e\u5931\u8d25\uff1a\u6d6e\u7a97\u672a\u663e\u793a"

    .line 799
    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    return-void

    .line 802
    :cond_0
    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/view/WindowManager$LayoutParams;

    const-string v2, "MANUAL"

    .line 803
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1

    const-string v2, ""

    goto :goto_0

    :cond_1
    const-string v2, "LEFT"

    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    const-string v2, "left_"

    goto :goto_0

    :cond_2
    const-string v2, "right_"

    :goto_0
    const-string v3, "cameraassist"

    .line 804
    invoke-virtual {p0, v3, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v3

    invoke-interface {v3}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    const-string v4, "overlay_pos_x"

    .line 805
    invoke-virtual {v2, v4}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    iget v5, v0, Landroid/view/WindowManager$LayoutParams;->x:I

    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    const-string v4, "overlay_pos_y"

    .line 806
    invoke-virtual {v2, v4}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    iget v5, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    const-string v4, "overlay_pos_recorded"

    .line 807
    invoke-virtual {v2, v4}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    const/4 v4, 0x1

    invoke-interface {v3, v2, v4}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    .line 808
    invoke-interface {v3}, Landroid/content/SharedPreferences$Editor;->apply()V

    const-string v2, "\u4f4d\u7f6e\u5df2\u8bb0\u5f55"

    .line 809
    invoke-static {p0, v2, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v1

    invoke-virtual {v1}, Landroid/widget/Toast;->show()V

    .line 810
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u6d6e\u7a97\u4f4d\u7f6e\u5df2\u8bb0\u5f55 x="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v2, v0, Landroid/view/WindowManager$LayoutParams;->x:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " y="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " dir="

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    return-void
.end method

.method private releaseCamera()V
    .locals 2

    invoke-static {}, Lcom/xiaopeng/qa/camera/Camera1Preview;->release()V

    .line 1750
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->captureSession:Landroid/hardware/camera2/CameraCaptureSession;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 1751
    invoke-virtual {v0}, Landroid/hardware/camera2/CameraCaptureSession;->close()V

    .line 1752
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->captureSession:Landroid/hardware/camera2/CameraCaptureSession;

    .line 1754
    :cond_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraDevice:Landroid/hardware/camera2/CameraDevice;

    if-eqz v0, :cond_1

    .line 1755
    invoke-virtual {v0}, Landroid/hardware/camera2/CameraDevice;->close()V

    .line 1756
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraDevice:Landroid/hardware/camera2/CameraDevice;

    .line 1758
    :cond_1
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->previewSurface:Landroid/view/Surface;

    if-eqz v0, :cond_2

    .line 1759
    invoke-virtual {v0}, Landroid/view/Surface;->release()V

    .line 1760
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->previewSurface:Landroid/view/Surface;

    .line 1762
    :cond_2
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    if-eqz v0, :cond_4

    .line 1763
    invoke-virtual {v0, v1}, Landroid/view/TextureView;->setSurfaceTextureListener(Landroid/view/TextureView$SurfaceTextureListener;)V

    .line 1764
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    invoke-virtual {v0}, Landroid/view/TextureView;->getSurfaceTexture()Landroid/graphics/SurfaceTexture;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 1766
    invoke-virtual {v0}, Landroid/graphics/SurfaceTexture;->release()V

    .line 1768
    :cond_3
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->textureView:Landroid/view/TextureView;

    :cond_4
    return-void
.end method

.method private removeOverlay()V
    .locals 2

    .line 1433
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-eqz v0, :cond_1

    .line 1435
    iget-boolean v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editMode:Z

    if-eqz v0, :cond_0

    const-string v0, "MANUAL"

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_0

    .line 1436
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->saveEditConfigInternal()V

    const/4 v0, 0x0

    .line 1437
    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editMode:Z

    .line 1440
    :cond_0
    :try_start_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    invoke-interface {v0, v1}, Landroid/view/WindowManager;->removeView(Landroid/view/View;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    const/4 v0, 0x0

    .line 1443
    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    :cond_1
    return-void
.end method

.method public static resetOverlayDefaults(Landroid/content/Context;)V
    .locals 2

    .line 199
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/xiaopeng/qa/camera/CameraOverlayService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "com.xiaopeng.qa.camera.RESET_OVERLAY"

    .line 200
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 201
    invoke-static {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->safeStart(Landroid/content/Context;Landroid/content/Intent;)V

    return-void
.end method

.method private resetOverlayDefaultsInternal()V
    .locals 6

    const-string v0, "cameraassist"

    const/4 v1, 0x0

    .line 1302
    invoke-virtual {p0, v0, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v2, "left_overlay_w"

    .line 1303
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_overlay_h"

    .line 1304
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_cam_scale"

    .line 1305
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_overlay_scale"

    .line 1306
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_overlay_pos_recorded"

    .line 1307
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_overlay_pos_x"

    .line 1308
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_overlay_pos_y"

    .line 1309
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_crop_l"

    .line 1310
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_crop_t"

    .line 1311
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_crop_r"

    .line 1312
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_crop_b"

    .line 1313
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_pan_x"

    .line 1314
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_pan_y"

    .line 1315
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_overlay_w"

    .line 1316
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_overlay_h"

    .line 1317
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_cam_scale"

    .line 1318
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_overlay_scale"

    .line 1319
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_overlay_pos_recorded"

    .line 1320
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_overlay_pos_x"

    .line 1321
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_overlay_pos_y"

    .line 1322
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_crop_l"

    .line 1323
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_crop_t"

    .line 1324
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_crop_r"

    .line 1325
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_crop_b"

    .line 1326
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_pan_x"

    .line 1327
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_pan_y"

    .line 1328
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "left_avm_mode"

    .line 1330
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    const-string v2, "right_avm_mode"

    .line 1331
    invoke-interface {v0, v2}, Landroid/content/SharedPreferences$Editor;->remove(Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    .line 1332
    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    const-string v0, "\u6d6e\u7a97\u914d\u7f6e\u5df2\u8fd8\u539f\u9ed8\u8ba4\uff08LEFT/RIGHT \u4f4d\u7f6e/\u5f62\u72b6/\u753b\u9762\uff09"

    .line 1333
    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    .line 1335
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bgHandler:Landroid/os/Handler;

    new-instance v2, Lcom/xiaopeng/qa/camera/CameraOverlayService$6;

    invoke-direct {v2, p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService$6;-><init>(Lcom/xiaopeng/qa/camera/CameraOverlayService;)V

    invoke-virtual {v0, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    const-string v0, "\u7ed1\u5b9a\u89c6\u89d2\u5df2\u5f52\u4f4d display-mode=8"

    .line 1341
    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    .line 1342
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-eqz v0, :cond_8

    .line 1343
    iget-boolean v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editMode:Z

    const-string v2, "MANUAL"

    if-eqz v0, :cond_5

    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_5

    .line 1344
    iput-boolean v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editMode:Z

    .line 1345
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->borderView:Landroid/view/View;

    const/16 v3, 0x8

    if-eqz v0, :cond_0

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    .line 1346
    :cond_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleL:Landroid/view/View;

    if-eqz v0, :cond_1

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    .line 1347
    :cond_1
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleR:Landroid/view/View;

    if-eqz v0, :cond_2

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    .line 1348
    :cond_2
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleT:Landroid/view/View;

    if-eqz v0, :cond_3

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    .line 1349
    :cond_3
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleB:Landroid/view/View;

    if-eqz v0, :cond_4

    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    .line 1350
    :cond_4
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editHintView:Landroid/widget/TextView;

    if-eqz v0, :cond_5

    const-string v3, "\u62d6\u52a8\u9ec4\u8272\u8fb9\u7f18\u8c03\u6574\u7a97\u53e3\u5f62\u72b6\uff0c\u53cc\u51fb\u9000\u51fa\u5e76\u4fdd\u5b58"

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_5
    const/high16 v0, 0x3f800000    # 1.0f

    .line 1352
    iput v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    const/4 v0, 0x0

    .line 1353
    iput v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    .line 1354
    iput v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    .line 1355
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyOverlaySizeInternal()V

    .line 1356
    new-instance v0, Landroid/util/DisplayMetrics;

    invoke-direct {v0}, Landroid/util/DisplayMetrics;-><init>()V

    .line 1357
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    invoke-interface {v3}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v3

    invoke-virtual {v3, v0}, Landroid/view/Display;->getRealMetrics(Landroid/util/DisplayMetrics;)V

    .line 1358
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    invoke-virtual {v3}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v3

    check-cast v3, Landroid/view/WindowManager$LayoutParams;

    .line 1359
    iget-object v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v2, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-nez v2, :cond_7

    const-string v2, "LEFT"

    .line 1360
    iget-object v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v2, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    const/16 v4, 0x78

    if-eqz v2, :cond_6

    const/16 v2, 0x78

    goto :goto_0

    :cond_6
    iget v2, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    iget v5, v3, Landroid/view/WindowManager$LayoutParams;->width:I

    sub-int/2addr v2, v5

    sub-int/2addr v2, v4

    :goto_0
    iput v2, v3, Landroid/view/WindowManager$LayoutParams;->x:I

    .line 1361
    iget v0, v0, Landroid/util/DisplayMetrics;->heightPixels:I

    iget v2, v3, Landroid/view/WindowManager$LayoutParams;->height:I

    sub-int/2addr v0, v2

    sub-int/2addr v0, v4

    iput v0, v3, Landroid/view/WindowManager$LayoutParams;->y:I

    .line 1364
    :cond_7
    :try_start_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    invoke-interface {v0, v2, v3}, Landroid/view/WindowManager;->updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 1367
    :catch_0
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyRenderTransform()V

    :cond_8
    const-string v0, "\u6d6e\u7a97\u5df2\u8fd8\u539f\u9ed8\u8ba4\u4f4d\u7f6e/\u5f62\u72b6/\u753b\u9762"

    .line 1369
    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private static safeStart(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 2

    .line 214
    :try_start_0
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_0

    .line 215
    invoke-virtual {p0, p1}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    goto :goto_0

    .line 217
    :cond_0
    invoke-virtual {p0, p1}, Landroid/content/Context;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p0

    .line 220
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "\u542f\u52a8\u524d\u53f0\u670d\u52a1\u88ab\u62d2\u7edd: "

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "CameraAssist"

    invoke-static {p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const-string p0, "\u542f\u52a8\u670d\u52a1\u88ab\u7cfb\u7edf\u62d2\u7edd\uff0c\u8bf7\u4ece\u4e3b\u754c\u9762\u91cd\u65b0\u5f00\u542f"

    .line 223
    invoke-static {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method private saveEditConfigInternal()V
    .locals 5

    .line 1077
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-eqz v0, :cond_2

    const-string v0, "MANUAL"

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    goto/16 :goto_1

    .line 1078
    :cond_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/view/WindowManager$LayoutParams;

    const-string v1, "LEFT"

    .line 1079
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v1, "left_"

    goto :goto_0

    :cond_1
    const-string v1, "right_"

    :goto_0
    const-string v2, "cameraassist"

    const/4 v3, 0x0

    .line 1080
    invoke-virtual {p0, v2, v3}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "overlay_w"

    .line 1081
    invoke-virtual {v1, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    iget v4, v0, Landroid/view/WindowManager$LayoutParams;->width:I

    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    const-string v3, "overlay_h"

    .line 1082
    invoke-virtual {v1, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    iget v4, v0, Landroid/view/WindowManager$LayoutParams;->height:I

    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    const-string v3, "cam_scale"

    .line 1083
    invoke-virtual {v1, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    iget v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    const-string v3, "pan_x"

    .line 1084
    invoke-virtual {v1, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    iget v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    const-string v3, "pan_y"

    .line 1085
    invoke-virtual {v1, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    iget v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putFloat(Ljava/lang/String;F)Landroid/content/SharedPreferences$Editor;

    const-string v3, "overlay_pos_x"

    .line 1086
    invoke-virtual {v1, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    iget v4, v0, Landroid/view/WindowManager$LayoutParams;->x:I

    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    const-string v3, "overlay_pos_y"

    .line 1087
    invoke-virtual {v1, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    iget v4, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    const-string v3, "overlay_pos_recorded"

    .line 1088
    invoke-virtual {v1, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const/4 v3, 0x1

    invoke-interface {v2, v1, v3}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    .line 1089
    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 1090
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u7f16\u8f91\u914d\u7f6e\u5df2\u4fdd\u5b58 dir="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " w="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, v0, Landroid/view/WindowManager$LayoutParams;->width:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " h="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, v0, Landroid/view/WindowManager$LayoutParams;->height:I

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " camScale="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v2, " pan=("

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v2, ","

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(F)Ljava/lang/StringBuilder;

    const-string v3, ") pos=("

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v3, v0, Landroid/view/WindowManager$LayoutParams;->x:I

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget v0, v0, Landroid/view/WindowManager$LayoutParams;->y:I

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ")"

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    :cond_2
    :goto_1
    return-void
.end method

.method private sendAvmMode(I)V
    .locals 3

    .line 1529
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "AVM: \u8f6c\u5411\u706f\u4e0b\u53d1\u89c6\u89d2 mode="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "CameraAssist"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 1530
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->callGetCmdControlParameters()Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_0

    const-string p1, "AVM: getCmdControlParameters \u8fd4\u56de null/\u8c03\u7528\u5931\u8d25\uff0c\u8f6c\u5411\u706f AVM \u4e0b\u53d1\u5931\u8d25"

    .line 1532
    invoke-static {v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 1535
    :cond_0
    invoke-direct {p0, v0, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->writeAvmDisplayMode(Ljava/lang/Object;I)Z

    move-result v2

    if-nez v2, :cond_1

    .line 1537
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "AVM: \u4e09\u4f18\u5148\u7ea7\u5199\u5165\u5747\u5931\u8d25\uff0c\u65e0\u6cd5\u4e0b\u53d1 display-mode="

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 1540
    :cond_1
    invoke-direct {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->callSetCmdControlParameters(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_2

    const-string p1, "AVM: setCmdControlParameters \u8c03\u7528\u5931\u8d25\uff0c\u8f6c\u5411\u706f AVM \u4e0b\u53d1\u5931\u8d25"

    .line 1541
    invoke-static {v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_2
    return-void
.end method

.method public static serviceLog(Ljava/lang/String;)V
    .locals 0

    # 日志功能已移除：保持空实现，供内部调用
    return-void
.end method

.method private setEditMode(Z)V
    .locals 4

    .line 1062
    iput-boolean p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editMode:Z

    .line 1063
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->borderView:Landroid/view/View;

    const/4 v1, 0x0

    const/16 v2, 0x8

    if-eqz v0, :cond_1

    if-eqz p1, :cond_0

    const/4 v3, 0x0

    goto :goto_0

    :cond_0
    const/16 v3, 0x8

    :goto_0
    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    .line 1064
    :cond_1
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleL:Landroid/view/View;

    if-eqz v0, :cond_3

    if-eqz p1, :cond_2

    const/4 v3, 0x0

    goto :goto_1

    :cond_2
    const/16 v3, 0x8

    :goto_1
    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    .line 1065
    :cond_3
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleR:Landroid/view/View;

    if-eqz v0, :cond_5

    if-eqz p1, :cond_4

    const/4 v3, 0x0

    goto :goto_2

    :cond_4
    const/16 v3, 0x8

    :goto_2
    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    .line 1066
    :cond_5
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleT:Landroid/view/View;

    if-eqz v0, :cond_7

    if-eqz p1, :cond_6

    const/4 v3, 0x0

    goto :goto_3

    :cond_6
    const/16 v3, 0x8

    :goto_3
    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    .line 1067
    :cond_7
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cropHandleB:Landroid/view/View;

    if-eqz v0, :cond_9

    if-eqz p1, :cond_8

    goto :goto_4

    :cond_8
    const/16 v1, 0x8

    :goto_4
    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    .line 1068
    :cond_9
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editHintView:Landroid/widget/TextView;

    if-eqz v0, :cond_b

    if-eqz p1, :cond_a

    const-string v1, "\u7f16\u8f91\u6a21\u5f0f\uff1a\u62d6\u52a8\u9ec4\u8272\u8fb9\u7f18\u8c03\u6574\u7a97\u53e3\u5f62\u72b6\uff0c\u53cc\u51fb\u9000\u51fa\u5e76\u4fdd\u5b58"

    const/4 v2, 0x0

    goto :goto_5

    :cond_a
    const-string v1, ""

    const/16 v2, 0x8

    .line 1069
    :goto_5
    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setVisibility(I)V

    :cond_b
    if-eqz p1, :cond_c

    nop

    :cond_c
    return-void
.end method

.method private setupWindowEdgeHandle(Landroid/view/View;Ljava/lang/String;)V
    .locals 1

    if-nez p1, :cond_0

    return-void

    .line 1179
    :cond_0
    new-instance v0, Lcom/xiaopeng/qa/camera/CameraOverlayService$5;

    invoke-direct {v0, p0, p2}, Lcom/xiaopeng/qa/camera/CameraOverlayService$5;-><init>(Lcom/xiaopeng/qa/camera/CameraOverlayService;Ljava/lang/String;)V

    invoke-virtual {p1, v0}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    return-void
.end method

.method public static showManual(Landroid/content/Context;)V
    .locals 2

    .line 171
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/xiaopeng/qa/camera/CameraOverlayService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "com.xiaopeng.qa.camera.SHOW_MANUAL"

    .line 172
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 173
    invoke-static {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->safeStart(Landroid/content/Context;Landroid/content/Intent;)V

    return-void
.end method

.method private showOverlayForDirection(Ljava/lang/String;)V
    .locals 2

    # D 档/调试模式限制
    invoke-static {p0}, Lcom/xiaopeng/qa/camera/OverlayPresets;->canShowSide(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :gate_blocked

    goto :gate_proceed

    :gate_blocked
    return-void

    :gate_proceed
    # 双闪或原厂 360/窄道全景占用摄像头时不弹本程序浮窗
    invoke-static {p0, p1}, Lcom/xiaopeng/qa/camera/SignalGate;->shouldSuppress(Ljava/lang/Object;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :gate_ok

    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->hideOverlayAndCamera()V

    return-void

    :gate_ok
    .line 518
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->lastActiveDir:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0

    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-eqz v0, :cond_0

    # Camera1 通路下 cameraDevice 始终为 null；这里不再要求 Camera2 设备，
    # 只要同方向且浮窗仍在，就忽略重复触发（避免每次轮询都重设视角）。
    nop

    nop

    nop

    nop

    const-string p1, "\u540c\u65b9\u5411\u4fe1\u53f7\u6301\u7eed\u4eae\u8d77\uff0c\u5ffd\u7565\u91cd\u590d\u89e6\u53d1\uff0c\u4e0d\u91cd\u53d1 AVM \u89c6\u89d2"

    .line 519
    invoke-static {p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    return-void

    .line 522
    :cond_0
    iput-object p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->lastActiveDir:Ljava/lang/String;

    .line 523
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    .line 524
    iput-object p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    .line 527
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-eqz v1, :cond_1

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 528
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyOverlayConfigForDirection()V

    :cond_1
    const-string v0, "MANUAL"

    .line 532
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_4

    .line 533
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getAvmBinding(Ljava/lang/String;)I

    move-result v0

    const/4 v1, -0x1

    if-eq v0, v1, :cond_4

    const/4 p1, 0x1

    .line 535
    iput-boolean p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->avmModeActive:Z

    .line 536
    iget-object p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-nez p1, :cond_2

    .line 537
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->startForegroundCompat()V

    .line 538
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->ensureOverlay()V

    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyOverlaySizeInternal()V

    goto :goto_0

    .line 540
    :cond_2
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->updateLabel()V

    .line 542
    :goto_0
    iget-object p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraDevice:Landroid/hardware/camera2/CameraDevice;

    if-eqz p1, :cond_3

    .line 543
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->closeCameraOnly()V

    .line 545
    :cond_3
    invoke-direct {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->sendAvmMode(I)V

    .line 548
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->openCamera()V

    return-void

    :cond_4
    const/4 v0, 0x0

    .line 552
    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->avmModeActive:Z

    .line 553
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-nez v0, :cond_5

    .line 554
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->startForegroundCompat()V

    .line 555
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->ensureOverlay()V

    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyOverlaySizeInternal()V

    .line 556
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->openCamera()V

    goto :goto_1

    .line 557
    :cond_5
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraDevice:Landroid/hardware/camera2/CameraDevice;

    if-nez v0, :cond_6

    .line 559
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->startForegroundCompat()V

    .line 560
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->openCamera()V

    goto :goto_1

    .line 561
    :cond_6
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->openedDirection:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_7

    .line 563
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->startForegroundCompat()V

    .line 564
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->closeCameraOnly()V

    .line 565
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->openCamera()V

    goto :goto_1

    .line 567
    :cond_7
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->updateLabel()V

    :goto_1
    return-void
.end method

.method private startForegroundCompat()V
    .locals 5

    .line 405
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_0

    .line 406
    new-instance v0, Landroid/app/Notification$Builder;

    const-string v1, "cameraassist_overlay"

    invoke-direct {v0, p0, v1}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    goto :goto_0

    .line 407
    :cond_0
    new-instance v0, Landroid/app/Notification$Builder;

    invoke-direct {v0, p0}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;)V

    :goto_0
    const-string v1, "CameraAssist"

    .line 408
    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v1

    .line 409
    sget-object v2, Lcom/xiaopeng/qa/camera/CameraOverlayService;->linkActive:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v2

    if-eqz v2, :cond_1

    const-string v2, "\u8054\u52a8\u8f6e\u8be2\u8fd0\u884c\u4e2d \u00b7 \u8f6c\u5411\u706f\u5f39\u7a97\u5c31\u7eea"

    goto :goto_1

    :cond_1
    const-string v2, "\u4fa7\u8fb9\u6444\u50cf\u5934\u9884\u89c8\u8fd0\u884c\u4e2d"

    :goto_1
    invoke-virtual {v1, v2}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v1

    const v2, 0x7f020003

    .line 411
    invoke-virtual {v1, v2}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object v1

    const/4 v2, 0x1

    .line 412
    invoke-virtual {v1, v2}, Landroid/app/Notification$Builder;->setOngoing(Z)Landroid/app/Notification$Builder;

    .line 413
    new-instance v1, Landroid/content/Intent;

    const-class v3, Lcom/xiaopeng/qa/camera/MainActivity;

    invoke-direct {v1, p0, v3}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const/4 v3, 0x0

    const/high16 v4, 0x4000000

    .line 414
    invoke-static {p0, v3, v1, v4}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v1

    .line 415
    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroid/app/Notification$Builder;

    .line 416
    invoke-virtual {v0}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object v0

    .line 417
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x1d

    if-lt v1, v3, :cond_2

    const/16 v1, 0x40

    .line 418
    invoke-virtual {p0, v2, v0, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->startForeground(ILandroid/app/Notification;I)V

    goto :goto_2

    .line 420
    :cond_2
    invoke-virtual {p0, v2, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->startForeground(ILandroid/app/Notification;)V

    :goto_2
    return-void
.end method

.method public static startLink(Landroid/content/Context;Ljava/lang/String;I)V
    .locals 2

    .line 155
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/xiaopeng/qa/camera/CameraOverlayService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "com.xiaopeng.qa.camera.START_LINK"

    .line 156
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    const-string v1, "host"

    .line 157
    invoke-virtual {v0, v1, p1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string p1, "port"

    .line 158
    invoke-virtual {v0, p1, p2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 159
    invoke-static {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->safeStart(Landroid/content/Context;Landroid/content/Intent;)V

    return-void
.end method

.method private startLinkInternal(Ljava/lang/String;I)V
    .locals 7

    const-string v0, "\u8054\u52a8\u5df2\u5f00\u542f\uff0cADB \u8f6e\u8be2\u542f\u52a8 ("

    .line 317
    sget-object v1, Lcom/xiaopeng/qa/camera/CameraOverlayService;->linkActive:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v2

    const-string v3, ":"

    if-eqz v2, :cond_0

    .line 319
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u8054\u52a8\u5df2\u5728\u8fd0\u884c\uff0c\u66f4\u65b0 ADB \u53c2\u6570 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    return-void

    .line 322
    :cond_0
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readRawAdbKey()[B

    move-result-object v2

    .line 323
    array-length v4, v2

    if-nez v4, :cond_1

    const-string p1, "\u5185\u7f6e\u5bc6\u94a5\u8bfb\u53d6\u5931\u8d25\uff0c\u65e0\u6cd5\u5efa\u7acb ADB \u8fde\u63a5"

    .line 324
    invoke-static {p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    return-void

    .line 328
    :cond_1
    :try_start_0
    new-instance v4, Lcom/xiaopeng/qa/camera/AdbClient;

    invoke-direct {v4, p1, p2, v2}, Lcom/xiaopeng/qa/camera/AdbClient;-><init>(Ljava/lang/String;I[B)V

    iput-object v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->adb:Lcom/xiaopeng/qa/camera/AdbClient;

    .line 329
    new-instance v2, Lcom/xiaopeng/qa/camera/SignalMonitor;

    iget-object v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->adb:Lcom/xiaopeng/qa/camera/AdbClient;

    const-wide/16 v5, 0xfa

    invoke-direct {v2, v4, p0, v5, v6}, Lcom/xiaopeng/qa/camera/SignalMonitor;-><init>(Lcom/xiaopeng/qa/camera/AdbClient;Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;J)V

    iput-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->monitor:Lcom/xiaopeng/qa/camera/SignalMonitor;

    .line 330
    invoke-virtual {v2}, Lcom/xiaopeng/qa/camera/SignalMonitor;->start()Z

    move-result v2

    if-eqz v2, :cond_2

    const/4 v2, 0x1

    .line 331
    invoke-virtual {v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 332
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ")"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    const-string p1, "\u8054\u52a8\u8f6e\u8be2\u8fd0\u884c\u4e2d \u00b7 \u8f6c\u5411\u706f\u5f39\u7a97\u5c31\u7eea"

    .line 333
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->updateNotificationText(Ljava/lang/String;)V

    goto :goto_0

    :cond_2
    const-string p1, "\u65e7\u8f6e\u8be2\u7ebf\u7a0b\u4ecd\u5728\u9000\u51fa\uff08Socket read \u6700\u957f 15s\uff09\uff0c\u8bf7\u7a0d\u540e\u91cd\u65b0\u5f00\u542f\u8054\u52a8"

    .line 335
    invoke-static {p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    const/4 p1, 0x0

    .line 336
    iput-object p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->adb:Lcom/xiaopeng/qa/camera/AdbClient;

    .line 337
    iput-object p1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->monitor:Lcom/xiaopeng/qa/camera/SignalMonitor;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception p1

    .line 340
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "\u521d\u59cb\u5316\u5931\u8d25: "

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    :goto_0
    return-void
.end method

.method public static stopLink(Landroid/content/Context;)V
    .locals 2

    .line 164
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/xiaopeng/qa/camera/CameraOverlayService;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v1, "com.xiaopeng.qa.camera.STOP_LINK"

    .line 165
    invoke-virtual {v0, v1}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    .line 166
    invoke-static {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->safeStart(Landroid/content/Context;Landroid/content/Intent;)V

    return-void
.end method

.method private stopLinkInternal()V
    .locals 2

    .line 346
    sget-object v0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->linkActive:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 347
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->monitor:Lcom/xiaopeng/qa/camera/SignalMonitor;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 348
    invoke-virtual {v0}, Lcom/xiaopeng/qa/camera/SignalMonitor;->stop()V

    .line 349
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->monitor:Lcom/xiaopeng/qa/camera/SignalMonitor;

    .line 351
    :cond_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->adb:Lcom/xiaopeng/qa/camera/AdbClient;

    if-eqz v0, :cond_1

    .line 352
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->adb:Lcom/xiaopeng/qa/camera/AdbClient;

    .line 354
    :cond_1
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->hideOverlayAndCamera()V

    const-string v0, "\u8054\u52a8\u5df2\u5173\u95ed\uff0c\u8f6e\u8be2\u505c\u6b62"

    .line 355
    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    .line 356
    sget-object v0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->manualVisible:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v0

    if-nez v0, :cond_2

    .line 357
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->stopSelfInternal()V

    :cond_2
    return-void
.end method

.method private stopSelfInternal()V
    .locals 3

    .line 363
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->hideOverlayAndCamera()V

    .line 364
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x18

    const/4 v2, 0x1

    if-lt v0, v1, :cond_0

    .line 365
    invoke-virtual {p0, v2}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->stopForeground(I)V

    goto :goto_0

    .line 367
    :cond_0
    invoke-virtual {p0, v2}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->stopForeground(Z)V

    .line 369
    :goto_0
    invoke-virtual {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->stopSelf()V

    return-void
.end method

.method private toggleEditMode()V
    .locals 5

    const-string v0, "MANUAL"

    .line 1035
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_5

    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->overlayView:Landroid/view/View;

    if-nez v0, :cond_0

    goto/16 :goto_2

    .line 1036
    :cond_0
    iget-boolean v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->editMode:Z

    const/4 v1, 0x0

    if-eqz v0, :cond_1

    .line 1037
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->saveEditConfigInternal()V

    .line 1038
    invoke-direct {p0, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->setEditMode(Z)V

    const-string v0, "\u7f16\u8f91\u6a21\u5f0f\u9000\u51fa\uff0c\u914d\u7f6e\u5df2\u4fdd\u5b58"

    .line 1039
    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    goto/16 :goto_2

    .line 1041
    :cond_1
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readCamScale()F

    move-result v0

    iput v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    .line 1042
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readPanX()F

    move-result v0

    iput v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    .line 1043
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readPanY()F

    move-result v0

    iput v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    .line 1045
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    const-string v2, "LEFT"

    invoke-virtual {v2, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    const-string v0, "left_"

    goto :goto_0

    :cond_2
    const-string v0, "right_"

    :goto_0
    const-string v3, "cameraassist"

    .line 1046
    invoke-virtual {p0, v3, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v3, "cam_scale"

    invoke-virtual {v0, v3}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-interface {v1, v0}, Landroid/content/SharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_4

    .line 1047
    new-instance v0, Landroid/util/DisplayMetrics;

    invoke-direct {v0}, Landroid/util/DisplayMetrics;-><init>()V

    .line 1048
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    invoke-interface {v1}, Landroid/view/WindowManager;->getDefaultDisplay()Landroid/view/Display;

    move-result-object v1

    invoke-virtual {v1, v0}, Landroid/view/Display;->getRealMetrics(Landroid/util/DisplayMetrics;)V

    .line 1049
    iget v0, v0, Landroid/util/DisplayMetrics;->widthPixels:I

    int-to-float v0, v0

    const v1, 0x3ecccccd    # 0.4f

    mul-float v0, v0, v1

    const/high16 v1, 0x41100000    # 9.0f

    mul-float v1, v1, v0

    const/high16 v3, 0x41800000    # 16.0f

    div-float/2addr v1, v3

    const/high16 v3, 0x40000000    # 2.0f

    .line 1051
    iput v3, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->camScale:F

    .line 1052
    iget-object v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v2, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_3

    goto :goto_1

    :cond_3
    neg-float v0, v0

    :goto_1
    div-float/2addr v0, v3

    iput v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panX:F

    neg-float v0, v1

    div-float/2addr v0, v3

    .line 1053
    iput v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->panY:F

    :cond_4
    const/4 v0, 0x1

    .line 1055
    invoke-direct {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->setEditMode(Z)V

    .line 1056
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u7f16\u8f91\u6a21\u5f0f\u8fdb\u5165\uff08"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\uff09\uff0c\u53cc\u51fb\u4fdd\u5b58\u9000\u51fa"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    :cond_5
    :goto_2
    return-void
.end method

.method private varargs tryInvokeSet(Ljava/lang/reflect/Method;[Ljava/lang/Object;)Z
    .locals 3

    const-string v0, "CameraAssist"

    const-string v1, "AVM: setCmdControlParameters \u547d\u4e2d\u91cd\u8f7d "

    .line 1617
    :try_start_0
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraManager:Landroid/hardware/camera2/CameraManager;

    invoke-virtual {p1, v2, p2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1618
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->buildMethodSig(Ljava/lang/reflect/Method;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {v0, p2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const/4 p1, 0x1

    return p1

    :catch_0
    move-exception p2

    .line 1621
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "AVM: setCmdControlParameters \u91cd\u8f7d "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->buildMethodSig(Ljava/lang/reflect/Method;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " \u8c03\u7528\u5931\u8d25: "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p1, 0x0

    return p1
.end method

.method private updateLabel()V
    .locals 2

    .line 859
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->labelView:Landroid/widget/TextView;

    if-nez v0, :cond_0

    return-void

    :cond_0
    const-string v0, "MANUAL"

    .line 860
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    .line 861
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->labelView:Landroid/widget/TextView;

    const-string v1, "\u624b\u52a8\u9884\u89c8 \u00b7 \u53ef\u62d6\u52a8"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_2

    .line 862
    :cond_1
    iget-boolean v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->avmModeActive:Z

    const-string v1, "LEFT"

    if-eqz v0, :cond_3

    .line 863
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    .line 864
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->labelView:Landroid/widget/TextView;

    if-eqz v0, :cond_2

    const-string v0, "\u5de6\u8f6c\u5411 \u00b7 AVM \u89c6\u89d2"

    goto :goto_0

    :cond_2
    const-string v0, "\u53f3\u8f6c\u5411 \u00b7 AVM \u89c6\u89d2"

    :goto_0
    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_2

    .line 866
    :cond_3
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->direction:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    .line 867
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->labelView:Landroid/widget/TextView;

    if-eqz v0, :cond_4

    const-string v0, "\u5de6\u8f6c\u5411 \u00b7 \u6444\u50cf\u5934\u9884\u89c8"

    goto :goto_1

    :cond_4
    const-string v0, "\u53f3\u8f6c\u5411 \u00b7 \u6444\u50cf\u5934\u9884\u89c8"

    :goto_1
    invoke-virtual {v1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :goto_2
    return-void
.end method

.method private updateNotificationText(Ljava/lang/String;)V
    .locals 4

    .line 391
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_0

    .line 392
    new-instance v0, Landroid/app/Notification$Builder;

    const-string v1, "cameraassist_overlay"

    invoke-direct {v0, p0, v1}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    goto :goto_0

    .line 393
    :cond_0
    new-instance v0, Landroid/app/Notification$Builder;

    invoke-direct {v0, p0}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;)V

    :goto_0
    const-string v1, "CameraAssist"

    .line 394
    invoke-virtual {v0, v1}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v1

    .line 395
    invoke-virtual {v1, p1}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object p1

    const v1, 0x7f020003

    .line 396
    invoke-virtual {p1, v1}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object p1

    const/4 v1, 0x1

    .line 397
    invoke-virtual {p1, v1}, Landroid/app/Notification$Builder;->setOngoing(Z)Landroid/app/Notification$Builder;

    .line 398
    new-instance p1, Landroid/content/Intent;

    const-class v2, Lcom/xiaopeng/qa/camera/MainActivity;

    invoke-direct {p1, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const/4 v2, 0x0

    const/high16 v3, 0x4000000

    .line 399
    invoke-static {p0, v2, p1, v3}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object p1

    .line 400
    invoke-virtual {v0, p1}, Landroid/app/Notification$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroid/app/Notification$Builder;

    .line 401
    invoke-virtual {v0}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object p1

    invoke-virtual {p0, v1, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->startForeground(ILandroid/app/Notification;)V

    return-void
.end method

.method private writeAvmDisplayMode(Ljava/lang/Object;I)Z
    .locals 11

    const-string v0, "display-mode"

    const-string v1, "CameraAssist"

    const-string v2, "AVM: \u4f18\u5148\u7ea73 \u79c1\u6709 put(String,String) \u8c03\u7528\u6210\u529f display-mode="

    const-string v3, "AVM: \u4f18\u5148\u7ea72 set(String,int) \u8c03\u7528\u6210\u529f display-mode="

    const-string v4, "AVM: \u4f18\u5148\u7ea71 setAvmDisplayMode(int) \u8c03\u7528\u6210\u529f = "

    .line 1638
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    const/4 v6, 0x0

    const/4 v7, 0x1

    :try_start_0
    const-string v8, "setAvmDisplayMode"

    new-array v9, v7, [Ljava/lang/Class;

    .line 1640
    sget-object v10, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v10, v9, v6

    invoke-virtual {v5, v8, v9}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v8

    new-array v9, v7, [Ljava/lang/Object;

    .line 1641
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    aput-object v10, v9, v6

    invoke-virtual {v8, p1, v9}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1642
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v8, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v1, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return v7

    :catch_0
    move-exception v4

    .line 1645
    new-instance v8, Ljava/lang/StringBuilder;

    const-string v9, "AVM: \u4f18\u5148\u7ea71 setAvmDisplayMode(int) \u5931\u8d25: "

    invoke-direct {v8, v9}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v8, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v1, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v4, 0x2

    :try_start_1
    const-string v8, "set"

    new-array v9, v4, [Ljava/lang/Class;

    .line 1648
    const-class v10, Ljava/lang/String;

    aput-object v10, v9, v6

    sget-object v10, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v10, v9, v7

    invoke-virtual {v5, v8, v9}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v8

    new-array v9, v4, [Ljava/lang/Object;

    aput-object v0, v9, v6

    .line 1649
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    aput-object v10, v9, v7

    invoke-virtual {v8, p1, v9}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1650
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v8, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    return v7

    :catch_1
    move-exception v3

    .line 1653
    new-instance v8, Ljava/lang/StringBuilder;

    const-string v9, "AVM: \u4f18\u5148\u7ea72 set(String,int) \u5931\u8d25: "

    invoke-direct {v8, v9}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v8, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :try_start_2
    const-string v3, "put"

    new-array v8, v4, [Ljava/lang/Class;

    .line 1656
    const-class v9, Ljava/lang/String;

    aput-object v9, v8, v6

    const-class v9, Ljava/lang/String;

    aput-object v9, v8, v7

    invoke-virtual {v5, v3, v8}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    .line 1657
    invoke-virtual {v3, v7}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    new-array v4, v4, [Ljava/lang/Object;

    aput-object v0, v4, v6

    .line 1658
    invoke-static {p2}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    aput-object v0, v4, v7

    invoke-virtual {v3, p1, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 1659
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_2

    return v7

    :catch_2
    move-exception p1

    .line 1662
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "AVM: \u4f18\u5148\u7ea73 \u79c1\u6709 put(String,String) \u5931\u8d25: "

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return v6
.end method


# virtual methods
.method public onAdbConnected()V
    .locals 7

    const-string v0, "ADB \u6388\u6743\u60ac\u6d6e\u7a97(pm grant)\uff1a"

    const-string v1, "pm grant "

    const-string v2, "ADB \u6388\u6743\u60ac\u6d6e\u7a97(appops)\uff1a"

    const-string v3, "appops set "

    .line 487
    invoke-static {p0}, Landroid/provider/Settings;->canDrawOverlays(Landroid/content/Context;)Z

    move-result v4

    if-eqz v4, :cond_0

    return-void

    .line 490
    :cond_0
    iget-object v4, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->adb:Lcom/xiaopeng/qa/camera/AdbClient;

    if-nez v4, :cond_1

    return-void

    :cond_1
    :try_start_0
    const-string v5, "ADB \u5df2\u8fde\u63a5\uff0c\u68c0\u6d4b\u5230\u60ac\u6d6e\u7a97\u672a\u6388\u6743\uff0c\u81ea\u52a8\u7533\u8bf7\u6743\u9650\u2026"

    .line 495
    invoke-static {v5}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    .line 496
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " SYSTEM_ALERT_WINDOW allow"

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v4, v3}, Lcom/xiaopeng/qa/camera/AdbClient;->exec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 497
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    const-string v2, "\u5df2\u6267\u884c\uff08\u65e0\u8f93\u51fa\uff09"

    if-eqz v3, :cond_3

    :try_start_1
    invoke-virtual {v3}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_2

    goto :goto_0

    :cond_2
    invoke-virtual {v3}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v3

    goto :goto_1

    :cond_3
    :goto_0
    move-object v3, v2

    :goto_1
    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    .line 498
    invoke-static {p0}, Landroid/provider/Settings;->canDrawOverlays(Landroid/content/Context;)Z

    move-result v3

    if-nez v3, :cond_6

    .line 499
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " android.permission.SYSTEM_ALERT_WINDOW"

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Lcom/xiaopeng/qa/camera/AdbClient;->exec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 500
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-eqz v1, :cond_5

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_4

    goto :goto_2

    :cond_4
    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    :cond_5
    :goto_2
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    .line 502
    :cond_6
    invoke-static {p0}, Landroid/provider/Settings;->canDrawOverlays(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :cond_7

    const-string v0, "\u60ac\u6d6e\u7a97\u6743\u9650\u5df2\u751f\u6548\uff0c\u6d6e\u7a97\u53ef\u6b63\u5e38\u5f39\u51fa"

    .line 503
    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    goto :goto_3

    :cond_7
    const-string v0, "\u60ac\u6d6e\u7a97\u6388\u6743\u547d\u4ee4\u5df2\u6267\u884c\uff0c\u4f46\u5c1a\u672a\u751f\u6548\uff0c\u8bf7\u786e\u8ba4\u8f66\u673a\u5141\u8bb8"

    .line 505
    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_3

    :catch_0
    move-exception v0

    .line 508
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "ADB \u81ea\u52a8\u6388\u6743\u60ac\u6d6e\u7a97\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u8054\u52a8\uff09\uff1a"

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    :goto_3
    return-void
.end method

.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .locals 0

    const/4 p1, 0x0

    return-object p1
.end method

.method public onCreate()V
    .locals 5

    .line 266
    invoke-super {p0}, Landroid/app/Service;->onCreate()V

    # ADB 轮询总开关关闭时不启动巡检
    invoke-static {p0}, Lcom/xiaopeng/qa/camera/OverlayPresets;->isAdbPolling(Landroid/content/Context;)Z

    move-result v0

    if-eqz v0, :no_polling

    # 轮询开启时确保 ADB 客户端已建立（不依赖打灯联动）
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->adb:Lcom/xiaopeng/qa/camera/AdbClient;

    if-nez v0, :adb_ready

    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->readRawAdbKey()[B

    move-result-object v0

    new-instance v1, Lcom/xiaopeng/qa/camera/AdbClient;

    const-string v2, "127.0.0.1"

    const/16 v3, 0x15b3

    invoke-direct {v1, v2, v3, v0}, Lcom/xiaopeng/qa/camera/AdbClient;-><init>(Ljava/lang/String;I[B)V

    iput-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->adb:Lcom/xiaopeng/qa/camera/AdbClient;

    :adb_ready
    invoke-static {p0}, Lcom/xiaopeng/qa/camera/SignalGate;->attach(Ljava/lang/Object;)V

    :no_polling
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->startForegroundCompat()V

    # 如果流媒体后视镜开关是打开的，服务启动时自动恢复浮窗
    invoke-static {p0}, Lcom/xiaopeng/qa/camera/RearMirror;->restoreIfEnabled(Landroid/content/Context;)V

    const-string v0, "window"

    .line 267
    invoke-virtual {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/view/WindowManager;

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->wm:Landroid/view/WindowManager;

    const-string v0, "camera"

    .line 268
    invoke-virtual {p0, v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/hardware/camera2/CameraManager;

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->cameraManager:Landroid/hardware/camera2/CameraManager;

    .line 269
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->mainHandler:Landroid/os/Handler;

    .line 270
    new-instance v0, Landroid/os/HandlerThread;

    const-string v1, "camera-bg"

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bgThread:Landroid/os/HandlerThread;

    .line 271
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 272
    new-instance v0, Landroid/os/Handler;

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bgThread:Landroid/os/HandlerThread;

    invoke-virtual {v1}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bgHandler:Landroid/os/Handler;

    .line 273
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->createNotificationChannel()V

    const-string v0, "\u524d\u53f0\u670d\u52a1\u5df2\u5e38\u9a7b\uff08\u540e\u53f0\u53ef\u5f39\u7a97\uff09"

    .line 274
    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    return-void
.end method

.method public onDestroy()V
    .locals 2

    # 停止车速/双闪/原厂占用巡检线程，避免 Service 销毁后仍轮询
    invoke-static {}, Lcom/xiaopeng/qa/camera/SignalGate;->detach()V

    .line 1774
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->monitor:Lcom/xiaopeng/qa/camera/SignalMonitor;

    if-eqz v0, :cond_0

    .line 1775
    invoke-virtual {v0}, Lcom/xiaopeng/qa/camera/SignalMonitor;->stop()V

    const/4 v0, 0x0

    .line 1776
    iput-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->monitor:Lcom/xiaopeng/qa/camera/SignalMonitor;

    .line 1778
    :cond_0
    sget-object v0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->linkActive:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 1779
    sget-object v0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->manualVisible:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 1780
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->releaseCamera()V

    .line 1781
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->removeOverlay()V

    .line 1782
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->bgThread:Landroid/os/HandlerThread;

    if-eqz v0, :cond_1

    invoke-virtual {v0}, Landroid/os/HandlerThread;->quitSafely()Z

    :cond_1
    const-string v0, "\u524d\u53f0\u670d\u52a1\u5df2\u505c\u6b62"

    .line 1783
    invoke-static {v0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->serviceLog(Ljava/lang/String;)V

    .line 1784
    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    return-void
.end method

.method public onLog(Ljava/lang/String;)V
    .locals 2

    .line 437
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->mainHandler:Landroid/os/Handler;

    new-instance v1, Lcom/xiaopeng/qa/camera/CameraOverlayService$1;

    invoke-direct {v1, p0, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService$1;-><init>(Lcom/xiaopeng/qa/camera/CameraOverlayService;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public onSignalChanged(Ljava/lang/String;Z)V
    .locals 2

    .line 447
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/CameraOverlayService;->mainHandler:Landroid/os/Handler;

    new-instance v1, Lcom/xiaopeng/qa/camera/CameraOverlayService$2;

    invoke-direct {v1, p0, p2, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService$2;-><init>(Lcom/xiaopeng/qa/camera/CameraOverlayService;ZLjava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 2

    const/4 p2, 0x1

    if-nez p1, :cond_0

    return p2

    .line 282
    :cond_0
    invoke-virtual {p1}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p3

    if-nez p3, :cond_1

    const-string p3, ""

    :cond_1
    const-string v0, "com.xiaopeng.qa.camera.REFRESH"

    invoke-virtual {v0, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :not_refresh

    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->hideOverlayAndCamera()V

    return p2

    :not_refresh
    const-string v0, "com.xiaopeng.qa.camera.START_LINK"

    .line 284
    invoke-virtual {v0, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 285
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->startForegroundCompat()V

    const-string p3, "host"

    .line 286
    invoke-virtual {p1, p3}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p3

    const-string v0, "port"

    const/16 v1, 0x15b3

    .line 287
    invoke-virtual {p1, v0, v1}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p1

    .line 288
    invoke-direct {p0, p3, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->startLinkInternal(Ljava/lang/String;I)V

    goto/16 :goto_0

    :cond_2
    const-string p1, "com.xiaopeng.qa.camera.STOP_LINK"

    .line 289
    invoke-virtual {p1, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_3

    .line 290
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->stopLinkInternal()V

    goto/16 :goto_0

    :cond_3
    const-string p1, "com.xiaopeng.qa.camera.SHOW_MANUAL"

    .line 291
    invoke-virtual {p1, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_4

    .line 292
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->startForegroundCompat()V

    .line 293
    sget-object p1, Lcom/xiaopeng/qa/camera/CameraOverlayService;->manualVisible:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p1, p2}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    const-string p1, "MANUAL"

    .line 294
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->showOverlayForDirection(Ljava/lang/String;)V

    goto :goto_0

    :cond_4
    const-string p1, "com.xiaopeng.qa.camera.HIDE_MANUAL"

    .line 295
    invoke-virtual {p1, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_5

    .line 296
    sget-object p1, Lcom/xiaopeng/qa/camera/CameraOverlayService;->manualVisible:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 p3, 0x0

    invoke-virtual {p1, p3}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 297
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->hideOverlayAndCamera()V

    .line 298
    sget-object p1, Lcom/xiaopeng/qa/camera/CameraOverlayService;->linkActive:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {p1}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result p1

    if-nez p1, :cond_a

    .line 299
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->stopSelfInternal()V

    goto :goto_0

    :cond_5
    const-string p1, "com.xiaopeng.qa.camera.HIDE_ALL"

    .line 301
    invoke-virtual {p1, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_6

    .line 302
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->stopLinkInternal()V

    goto :goto_0

    :cond_6
    const-string p1, "com.xiaopeng.qa.camera.RECORD_POS"

    .line 303
    invoke-virtual {p1, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_7

    .line 304
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->recordPositionInternal()V

    goto :goto_0

    :cond_7
    const-string p1, "com.xiaopeng.qa.camera.APPLY_SIZE"

    .line 305
    invoke-virtual {p1, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_8

    .line 306
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->applyOverlaySizeInternal()V

    goto :goto_0

    :cond_8
    const-string p1, "com.xiaopeng.qa.camera.RESET_OVERLAY"

    .line 307
    invoke-virtual {p1, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_9

    .line 308
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->resetOverlayDefaultsInternal()V

    goto :goto_0

    :cond_9
    const-string p1, "com.xiaopeng.qa.camera.ALIGN_RIGHT_TO_LEFT"

    .line 309
    invoke-virtual {p1, p3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_a

    .line 310
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->alignRightToLeftInternal()V

    :cond_a
    :goto_0
    return p2
.end method
