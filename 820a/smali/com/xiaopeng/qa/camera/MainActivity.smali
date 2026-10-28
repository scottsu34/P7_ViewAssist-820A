.class public Lcom/xiaopeng/qa/camera/MainActivity;
.super Landroid/app/Activity;
.source "MainActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# static fields
.field private static final CAMERA_TEST_CLICK_REQUIRED:I = 0xa

.field private static final CAMERA_TEST_CLICK_WINDOW_MS:J = 0x7d0L

.field private static final MAX_LOG_LINES:I = 0x1f4

.field private static final REQ_CAMERA:I = 0x64

.field private static final TAG:Ljava/lang/String; = "CameraAssist"


# instance fields
.field private btnAlignRightToLeft:Landroid/widget/Button;

.field private btnCamera:Landroid/widget/Button;

.field private btnCameraTest:Landroid/widget/Button;

.field private btnClearLog:Landroid/widget/Button;

.field private btnOverlay:Landroid/widget/Button;

.field private btnResetOverlay:Landroid/widget/Button;

.field private cameraTestClickCount:I

.field private cameraTestLastClickTime:J

.field private etHost:Landroid/widget/EditText;

.field private etPort:Landroid/widget/EditText;

.field private linkOn:Z

.field private final logPoller:Landroid/os/Handler;

.field private pollerRunning:Z

.field private prefs:Landroid/content/SharedPreferences;

.field private final refreshRunnable:Ljava/lang/Runnable;

.field private scrollLog:Landroid/widget/ScrollView;

.field private swEnable:Landroid/widget/Button;

.field private tvLog:Landroid/widget/TextView;

.field private tvState:Landroid/widget/TextView;


# direct methods
.method public constructor <init>()V
    .locals 3

    .line 33
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    const/4 v0, 0x0

    .line 42
    iput v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->cameraTestClickCount:I

    const-wide/16 v1, 0x0

    .line 43
    iput-wide v1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->cameraTestLastClickTime:J

    .line 62
    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->linkOn:Z

    .line 65
    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->logPoller:Landroid/os/Handler;

    .line 66
    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->pollerRunning:Z

    .line 67
    new-instance v0, Lcom/xiaopeng/qa/camera/MainActivity$1;

    invoke-direct {v0, p0}, Lcom/xiaopeng/qa/camera/MainActivity$1;-><init>(Lcom/xiaopeng/qa/camera/MainActivity;)V

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->refreshRunnable:Ljava/lang/Runnable;

    return-void
.end method

.method static synthetic access$000(Lcom/xiaopeng/qa/camera/MainActivity;)Z
    .locals 0

    .line 33
    iget-boolean p0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->pollerRunning:Z

    return p0
.end method

.method static synthetic access$102(Lcom/xiaopeng/qa/camera/MainActivity;Z)Z
    .locals 0

    .line 33
    iput-boolean p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->linkOn:Z

    return p1
.end method

.method static synthetic access$200(Lcom/xiaopeng/qa/camera/MainActivity;)V
    .locals 0

    .line 33
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->updateLinkButton()V

    invoke-static {}, Lcom/xiaopeng/qa/camera/OverlayPresets;->refreshMirrorButton()V

    return-void
.end method

.method static synthetic access$300(Lcom/xiaopeng/qa/camera/MainActivity;)V
    .locals 0

    .line 33
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->updateStateText()V

    return-void
.end method

.method static synthetic access$400(Lcom/xiaopeng/qa/camera/MainActivity;Ljava/lang/String;)V
    .locals 0

    .line 33
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$500(Lcom/xiaopeng/qa/camera/MainActivity;)Landroid/os/Handler;
    .locals 0

    .line 33
    iget-object p0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->logPoller:Landroid/os/Handler;

    return-object p0
.end method

.method private appendLog(Ljava/lang/String;)V
    .locals 0

    return-void
.end method

.method private autoGrant(Ljava/lang/String;I)V
    .locals 8

    const-string v0, "ADB \u6388\u6743\u60ac\u6d6e\u7a97\uff1a"

    const-string v1, "ADB \u6388\u6743\u76f8\u673a\uff1a"

    const-string v2, "appops set "

    const-string v3, "pm grant "

    const-string v4, "ADB \u81ea\u52a8\u6388\u6743\u5931\u8d25\uff08\u4e0d\u5f71\u54cd\u8054\u52a8\u5f00\u5173\uff09\uff1a"

    .line 266
    :try_start_0
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->readRawAdbKey()[B

    move-result-object v5
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_2

    const/4 v6, 0x0

    .line 273
    :try_start_1
    new-instance v7, Lcom/xiaopeng/qa/camera/AdbClient;

    invoke-direct {v7, p1, p2, v5}, Lcom/xiaopeng/qa/camera/AdbClient;-><init>(Ljava/lang/String;I[B)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    :try_start_2
    const-string p1, "android.permission.CAMERA"

    .line 274
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->checkSelfPermission(Ljava/lang/String;)I

    move-result p1
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-nez p1, :cond_0

    const/4 p1, 0x1

    goto :goto_0

    :cond_0
    const/4 p1, 0x0

    :goto_0
    const-string p2, "\u5df2\u6267\u884c\uff08\u65e0\u8f93\u51fa\uff09"

    if-nez p1, :cond_3

    .line 277
    :try_start_3
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, " android.permission.CAMERA"

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v7, p1}, Lcom/xiaopeng/qa/camera/AdbClient;->exec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 278
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-eqz p1, :cond_2

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_1

    goto :goto_1

    :cond_1
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    goto :goto_2

    :cond_2
    :goto_1
    move-object p1, p2

    :goto_2
    invoke-virtual {v3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    goto :goto_3

    :cond_3
    const-string p1, "\u76f8\u673a\u6743\u9650\u5df2\u6388\u4e88\uff0c\u8df3\u8fc7\u6388\u6743\u547d\u4ee4"

    .line 280
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    .line 282
    :goto_3
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->hasOverlay()Z

    move-result p1

    if-nez p1, :cond_6

    .line 283
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " SYSTEM_ALERT_WINDOW allow"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v7, p1}, Lcom/xiaopeng/qa/camera/AdbClient;->exec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 284
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-eqz p1, :cond_5

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_4

    goto :goto_4

    :cond_4
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p2

    :cond_5
    :goto_4
    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    goto :goto_5

    :cond_6
    const-string p1, "\u60ac\u6d6e\u7a97\u6743\u9650\u5df2\u6388\u4e88\uff0c\u8df3\u8fc7\u6388\u6743\u547d\u4ee4"

    .line 286
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 291
    :goto_5
    invoke-virtual {v7}, Lcom/xiaopeng/qa/camera/AdbClient;->close()V

    goto :goto_7

    :catchall_0
    move-exception p1

    move-object v6, v7

    goto :goto_8

    :catch_0
    move-exception p1

    move-object v6, v7

    goto :goto_6

    :catchall_1
    move-exception p1

    goto :goto_8

    :catch_1
    move-exception p1

    .line 289
    :goto_6
    :try_start_4
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    if-eqz v6, :cond_7

    .line 291
    invoke-virtual {v6}, Lcom/xiaopeng/qa/camera/AdbClient;->close()V

    :cond_7
    :goto_7
    return-void

    :goto_8
    if-eqz v6, :cond_8

    invoke-virtual {v6}, Lcom/xiaopeng/qa/camera/AdbClient;->close()V

    .line 292
    :cond_8
    throw p1

    :catch_2
    move-exception p1

    .line 268
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "\u8bfb\u53d6 adb_key.pem \u5931\u8d25\uff0c\u8df3\u8fc7\u81ea\u52a8\u6388\u6743\uff1a"

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    return-void
.end method

.method private disableLink()V
    .locals 1

    .line 310
    invoke-static {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->stopLink(Landroid/content/Context;)V

    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/xiaopeng/qa/camera/OverlayPresets;->setLinkWanted(Landroid/content/Context;Z)V

    const/4 v0, 0x0

    .line 311
    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->linkOn:Z

    .line 312
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->updateLinkButton()V

    .line 313
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->updateStateText()V

    return-void
.end method

.method private enableLink()V
    .locals 4

    .line 230
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->etHost:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    .line 233
    :try_start_0
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->etPort:Landroid/widget/EditText;

    invoke-virtual {v1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 240
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/MainActivity;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "host"

    invoke-interface {v2, v3, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "port"

    invoke-interface {v2, v3, v1}, Landroid/content/SharedPreferences$Editor;->putInt(Ljava/lang/String;I)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    const-string v2, "\u6b63\u5728\u7ecf ADB \u81ea\u52a8\u6388\u6743\u76f8\u673a\u4e0e\u60ac\u6d6e\u7a97\u6743\u9650\u2026"

    .line 242
    invoke-direct {p0, v2}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    .line 243
    invoke-direct {p0, v0, v1}, Lcom/xiaopeng/qa/camera/MainActivity;->autoGrant(Ljava/lang/String;I)V

    .line 244
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->hasOverlay()Z

    move-result v2

    if-nez v2, :cond_0

    const-string v2, "\u60ac\u6d6e\u7a97\u6743\u9650\u4ecd\u4e0d\u53ef\u7528\uff08\u81ea\u52a8\u6388\u6743\u672a\u751f\u6548\u6216\u5df2\u8df3\u8fc7\uff09\uff0c\u6d6e\u7a97\u53ef\u80fd\u65e0\u6cd5\u5f39\u51fa"

    .line 245
    invoke-direct {p0, v2}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    :cond_0
    const-string v2, "android.permission.CAMERA"

    .line 247
    invoke-virtual {p0, v2}, Lcom/xiaopeng/qa/camera/MainActivity;->checkSelfPermission(Ljava/lang/String;)I

    move-result v2

    if-eqz v2, :cond_1

    const-string v2, "\u76f8\u673a\u6743\u9650\u4ecd\u4e0d\u53ef\u7528\uff08\u81ea\u52a8\u6388\u6743\u672a\u751f\u6548\u6216\u5df2\u8df3\u8fc7\uff09\uff0c\u9884\u89c8\u53ef\u80fd\u9ed1\u5c4f"

    .line 249
    invoke-direct {p0, v2}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    .line 252
    :cond_1
    invoke-static {p0, v0, v1}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->startLink(Landroid/content/Context;Ljava/lang/String;I)V

    const/4 v0, 0x1

    invoke-static {p0, v0}, Lcom/xiaopeng/qa/camera/OverlayPresets;->setLinkWanted(Landroid/content/Context;Z)V

    .line 253
    invoke-static {}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->isLinkActive()Z

    move-result v0

    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->linkOn:Z

    .line 254
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->updateLinkButton()V

    .line 255
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->updateStateText()V

    return-void

    :catch_0
    const-string v0, "\u7aef\u53e3\u683c\u5f0f\u9519\u8bef"

    .line 235
    invoke-direct {p0, v0}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    const/4 v0, 0x0

    .line 236
    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->linkOn:Z

    .line 237
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->updateLinkButton()V

    return-void
.end method

.method private hasOverlay()Z
    .locals 1

    .line 207
    invoke-static {p0}, Landroid/provider/Settings;->canDrawOverlays(Landroid/content/Context;)Z

    move-result v0

    return v0
.end method

.method private readRawAdbKey()[B
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 297
    invoke-virtual {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const/high16 v1, 0x7f060000

    invoke-virtual {v0, v1}, Landroid/content/res/Resources;->openRawResource(I)Ljava/io/InputStream;

    move-result-object v0

    .line 299
    :try_start_0
    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/16 v2, 0x1000

    new-array v2, v2, [B

    .line 302
    :goto_0
    invoke-virtual {v0, v2}, Ljava/io/InputStream;->read([B)I

    move-result v3

    if-lez v3, :cond_0

    const/4 v4, 0x0

    invoke-virtual {v1, v2, v4, v3}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_0

    .line 303
    :cond_0
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v1
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    .line 305
    invoke-virtual {v0}, Ljava/io/InputStream;->close()V

    return-object v1

    :catchall_0
    move-exception v1

    invoke-virtual {v0}, Ljava/io/InputStream;->close()V

    .line 306
    goto :goto_2

    :goto_1
    throw v1

    :goto_2
    goto :goto_1
.end method

.method private refreshPermissionButtons()V
    .locals 3

    .line 211
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->hasOverlay()Z

    move-result v0

    const-string v1, "android.permission.CAMERA"

    .line 212
    invoke-virtual {p0, v1}, Lcom/xiaopeng/qa/camera/MainActivity;->checkSelfPermission(Ljava/lang/String;)I

    move-result v1

    if-nez v1, :cond_0

    const/4 v1, 0x1

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    .line 214
    :goto_0
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnOverlay:Landroid/widget/Button;

    if-eqz v0, :cond_1

    const-string v0, "\u60ac\u6d6e\u7a97\u6743\u9650\uff1a\u5df2\u6388\u4e88"

    goto :goto_1

    :cond_1
    const-string v0, "\u7533\u8bf7\u60ac\u6d6e\u7a97\u6743\u9650\uff08\u672a\u6388\u4e88\uff09"

    :goto_1
    invoke-virtual {v2, v0}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 215
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnCamera:Landroid/widget/Button;

    if-eqz v1, :cond_2

    const-string v1, "\u76f8\u673a\u6743\u9650\uff1a\u5df2\u6388\u4e88"

    goto :goto_2

    :cond_2
    const-string v1, "\u7533\u8bf7\u76f8\u673a\u6743\u9650\uff08\u672a\u6388\u4e88\uff09"

    :goto_2
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method private startLogPoller()V
    .locals 2

    .line 318
    iget-boolean v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->pollerRunning:Z

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x1

    .line 319
    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->pollerRunning:Z

    .line 320
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->logPoller:Landroid/os/Handler;

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->refreshRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private stopLogPoller()V
    .locals 2

    const/4 v0, 0x0

    .line 325
    iput-boolean v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->pollerRunning:Z

    .line 326
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->logPoller:Landroid/os/Handler;

    iget-object v1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->refreshRunnable:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    return-void
.end method

.method private updateLinkButton()V
    .locals 2

    .line 331
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->swEnable:Landroid/widget/Button;

    if-nez v0, :cond_0

    return-void

    .line 332
    :cond_0
    iget-boolean v1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->linkOn:Z

    if-eqz v1, :cond_1

    const v1, 0x7f020001

    goto :goto_0

    :cond_1
    const/high16 v1, 0x7f020000

    :goto_0
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setBackgroundResource(I)V

    .line 333
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->swEnable:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->linkOn:Z

    if-eqz v1, :cond_2

    const/16 v1, -0x2676

    goto :goto_1

    :cond_2
    const/4 v1, -0x1

    :goto_1
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setTextColor(I)V

    .line 334
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->swEnable:Landroid/widget/Button;

    iget-boolean v1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->linkOn:Z

    if-eqz v1, :cond_3

    const-string v1, "\u6253\u706f\u8054\u52a8\uff1a\u5f00\u542f"

    goto :goto_2

    :cond_3
    const-string v1, "\u6253\u706f\u8054\u52a8\uff1a\u5173\u95ed"

    :goto_2
    invoke-virtual {v0, v1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method private updateStateText()V
    .locals 2

    .line 219
    invoke-static {p0}, Lcom/xiaopeng/qa/camera/OverlayPresets;->refreshStatus(Landroid/content/Context;)V

    return-void
.end method


# virtual methods
.method synthetic lambda$appendLog$0$com-xiaopeng-qa-camera-MainActivity()V
    .locals 3

    .line 352
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->scrollLog:Landroid/widget/ScrollView;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/ScrollView;->getChildAt(I)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_0

    .line 353
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->scrollLog:Landroid/widget/ScrollView;

    .line 354
    invoke-virtual {v1}, Landroid/widget/ScrollView;->getScrollY()I

    move-result v1

    iget-object v2, p0, Lcom/xiaopeng/qa/camera/MainActivity;->scrollLog:Landroid/widget/ScrollView;

    invoke-virtual {v2}, Landroid/widget/ScrollView;->getHeight()I

    move-result v2

    add-int/2addr v1, v2

    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v0

    add-int/lit8 v0, v0, -0x28

    if-lt v1, v0, :cond_0

    .line 355
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->scrollLog:Landroid/widget/ScrollView;

    const/16 v1, 0x82

    invoke-virtual {v0, v1}, Landroid/widget/ScrollView;->fullScroll(I)Z

    :cond_0
    return-void
.end method

.method public onClick(Landroid/view/View;)V
    .locals 9

    .line 140
    invoke-virtual {p1}, Landroid/view/View;->getId()I

    move-result p1

    const v0, 0x7f030007

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-ne p1, v0, :cond_1

    .line 143
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    move-result-wide v3

    .line 144
    iget-wide v5, p0, Lcom/xiaopeng/qa/camera/MainActivity;->cameraTestLastClickTime:J

    sub-long v5, v3, v5

    const-wide/16 v7, 0x7d0

    cmp-long p1, v5, v7

    if-lez p1, :cond_0

    .line 145
    iput v2, p0, Lcom/xiaopeng/qa/camera/MainActivity;->cameraTestClickCount:I

    .line 147
    :cond_0
    iput-wide v3, p0, Lcom/xiaopeng/qa/camera/MainActivity;->cameraTestLastClickTime:J

    .line 148
    iget p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->cameraTestClickCount:I

    add-int/2addr p1, v1

    iput p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->cameraTestClickCount:I

    const-string p1, "\u5f00\u53d1\u9875\u9762\u65e0\u6cd5\u8bbf\u95ee"

    .line 149
    invoke-static {p0, p1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 150
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "btn_camera_test clicked "

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->cameraTestClickCount:I

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "/10"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "CameraAssist"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 151
    iget p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->cameraTestClickCount:I

    const/16 v0, 0xa

    if-lt p1, v0, :cond_a

    .line 152
    iput v2, p0, Lcom/xiaopeng/qa/camera/MainActivity;->cameraTestClickCount:I

    const-string p1, "\u6b63\u5728\u6253\u5f00\u6444\u50cf\u5934\u9884\u89c8\u9875"

    .line 153
    invoke-static {p0, p1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 154
    new-instance p1, Landroid/content/Intent;

    const-class v0, Lcom/xiaopeng/qa/camera/CameraTestActivity;

    invoke-direct {p1, p0, v0}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->startActivity(Landroid/content/Intent;)V

    goto/16 :goto_0

    :cond_1
    const v0, 0x7f03000a

    if-ne p1, v0, :cond_3

    .line 157
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->hasOverlay()Z

    move-result p1

    if-eqz p1, :cond_2

    const-string p1, "\u60ac\u6d6e\u7a97\u6743\u9650\u5df2\u6388\u4e88"

    .line 158
    invoke-static {p0, p1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    goto/16 :goto_0

    .line 160
    :cond_2
    new-instance p1, Landroid/content/Intent;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "package:"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 161
    invoke-virtual {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v0

    const-string v1, "android.settings.action.MANAGE_OVERLAY_PERMISSION"

    invoke-direct {p1, v1, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;Landroid/net/Uri;)V

    .line 162
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->startActivity(Landroid/content/Intent;)V

    goto/16 :goto_0

    :cond_3
    const v0, 0x7f030006

    if-ne p1, v0, :cond_5

    const-string p1, "android.permission.CAMERA"

    .line 165
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->checkSelfPermission(Ljava/lang/String;)I

    move-result v0

    if-nez v0, :cond_4

    const-string p1, "\u76f8\u673a\u6743\u9650\u5df2\u6388\u4e88"

    .line 167
    invoke-static {p0, p1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    goto :goto_0

    :cond_4
    new-array v0, v1, [Ljava/lang/String;

    aput-object p1, v0, v2

    const/16 p1, 0x64

    .line 169
    invoke-virtual {p0, v0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->requestPermissions([Ljava/lang/String;I)V

    goto :goto_0

    :cond_5
    const v0, 0x7f030019

    if-ne p1, v0, :cond_7

    .line 172
    iget-boolean p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->linkOn:Z

    if-eqz p1, :cond_6

    .line 173
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->disableLink()V

    goto :goto_0

    .line 175
    :cond_6
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->enableLink()V

    goto :goto_0

    :cond_7
    const v0, 0x7f03000b

    if-ne p1, v0, :cond_8

    .line 179
    invoke-static {p0}, Lcom/xiaopeng/qa/camera/OverlayPresets;->reset(Landroid/content/Context;)V

    const-string p1, "\u5df2\u8bf7\u6c42\u8fd8\u539f\u5de6\u53f3\u6d6e\u7a97\u9ed8\u8ba4\uff08\u4f4d\u7f6e/\u5f62\u72b6/\u753b\u9762\uff09"

    .line 180
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    const-string p1, "\u5df2\u8fd8\u539f\u6d6e\u7a97\u9ed8\u8ba4"

    .line 181
    invoke-static {p0, p1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    goto :goto_0

    :cond_8
    const/high16 v0, 0x7f030000

    if-ne p1, v0, :cond_9

    .line 184
    invoke-static {p0}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->alignRightToLeft(Landroid/content/Context;)V

    const-string p1, "\u5df2\u8bf7\u6c42\u53f3\u6d6e\u7a97\u5bf9\u9f50\u5de6\u6d6e\u7a97\uff08\u4f4d\u7f6e/\u5927\u5c0f/\u5f62\u72b6\uff09"

    .line 185
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    const-string p1, "\u53f3\u6d6e\u7a97\u5df2\u5bf9\u9f50\u5de6\u6d6e\u7a97"

    .line 186
    invoke-static {p0, p1, v2}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    goto :goto_0

    :cond_9
    const v0, 0x7f030008

    if-ne p1, v0, :cond_a

    .line 189
    iget-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->tvLog:Landroid/widget/TextView;

    const-string v0, ""

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 190
    invoke-static {}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->clearLogs()V

    const-string p1, "\u65e5\u5fd7\u5df2\u6e05\u7a7a"

    .line 191
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    :cond_a
    :goto_0
    return-void
.end method

.method protected onCreate(Landroid/os/Bundle;)V
    .locals 3

    .line 83
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    const p1, 0x7f040001

    .line 84
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->setContentView(I)V

    invoke-static {p0}, Lcom/xiaopeng/qa/camera/OverlayPresets;->install(Landroid/app/Activity;)V

    const-string p1, "cameraassist"

    const/4 v0, 0x0

    .line 85
    invoke-virtual {p0, p1, v0}, Lcom/xiaopeng/qa/camera/MainActivity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p1

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const p1, 0x7f03000a

    .line 87
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/Button;

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnOverlay:Landroid/widget/Button;

    const p1, 0x7f030006

    .line 88
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/Button;

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnCamera:Landroid/widget/Button;

    const p1, 0x7f030007

    .line 89
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/Button;

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnCameraTest:Landroid/widget/Button;

    const p1, 0x7f03000d

    .line 90
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/EditText;

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->etHost:Landroid/widget/EditText;

    const p1, 0x7f03000e

    .line 91
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/EditText;

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->etPort:Landroid/widget/EditText;

    const p1, 0x7f030019

    .line 92
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/Button;

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->swEnable:Landroid/widget/Button;

    const p1, 0x7f03000b

    .line 93
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/Button;

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnResetOverlay:Landroid/widget/Button;

    const/high16 p1, 0x7f030000

    .line 94
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/Button;

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnAlignRightToLeft:Landroid/widget/Button;

    const p1, 0x7f030008

    .line 95
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/Button;

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnClearLog:Landroid/widget/Button;

    const p1, 0x7f03001f

    .line 96
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->tvState:Landroid/widget/TextView;

    const p1, 0x7f03001e

    .line 97
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/TextView;

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->tvLog:Landroid/widget/TextView;

    const p1, 0x7f030018

    .line 98
    invoke-virtual {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->findViewById(I)Landroid/view/View;

    move-result-object p1

    check-cast p1, Landroid/widget/ScrollView;

    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->scrollLog:Landroid/widget/ScrollView;

    .line 100
    iget-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnOverlay:Landroid/widget/Button;

    invoke-virtual {p1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 101
    iget-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnCamera:Landroid/widget/Button;

    invoke-virtual {p1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 102
    iget-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnCameraTest:Landroid/widget/Button;

    invoke-virtual {p1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 103
    iget-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnResetOverlay:Landroid/widget/Button;

    invoke-virtual {p1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 104
    iget-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnAlignRightToLeft:Landroid/widget/Button;

    invoke-virtual {p1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 105
    iget-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->btnClearLog:Landroid/widget/Button;

    invoke-virtual {p1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 107
    iget-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->etHost:Landroid/widget/EditText;

    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "host"

    const-string v2, "127.0.0.1"

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 108
    iget-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->etPort:Landroid/widget/EditText;

    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "port"

    const/16 v2, 0x15b3

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result v0

    invoke-static {v0}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 110
    iget-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity;->swEnable:Landroid/widget/Button;

    invoke-virtual {p1, p0}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    const-string p1, "CameraAssist \u542f\u52a8\uff08Camera1 \u9c7c\u773c\u5207\u89c6\uff09"

    .line 113
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    return-void
.end method

.method protected onDestroy()V
    .locals 0

    .line 134
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->stopLogPoller()V

    .line 135
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    return-void
.end method

.method protected onPause()V
    .locals 0

    .line 127
    invoke-super {p0}, Landroid/app/Activity;->onPause()V

    .line 128
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->stopLogPoller()V

    invoke-static {p0}, Lcom/xiaopeng/qa/camera/RearMirror;->onSettingsHidden(Landroid/content/Context;)V

    return-void
.end method

.method public onRequestPermissionsResult(I[Ljava/lang/String;[I)V
    .locals 0

    .line 197
    invoke-super {p0, p1, p2, p3}, Landroid/app/Activity;->onRequestPermissionsResult(I[Ljava/lang/String;[I)V

    const/16 p2, 0x64

    if-ne p1, p2, :cond_2

    .line 199
    array-length p1, p3

    const/4 p2, 0x0

    if-lez p1, :cond_0

    aget p1, p3, p2

    if-nez p1, :cond_0

    const/4 p2, 0x1

    :cond_0
    if-eqz p2, :cond_1

    const-string p1, "\u76f8\u673a\u6743\u9650\u5df2\u6388\u4e88"

    goto :goto_0

    :cond_1
    const-string p1, "\u76f8\u673a\u6743\u9650\u88ab\u62d2\u7edd"

    .line 201
    :goto_0
    invoke-direct {p0, p1}, Lcom/xiaopeng/qa/camera/MainActivity;->appendLog(Ljava/lang/String;)V

    .line 202
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->refreshPermissionButtons()V

    :cond_2
    return-void
.end method

.method protected onResume()V
    .locals 0

    .line 118
    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    .line 119
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->refreshPermissionButtons()V

    .line 120
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->updateStateText()V

    .line 121
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->updateLinkButton()V

    .line 122
    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/MainActivity;->startLogPoller()V

    invoke-static {p0}, Lcom/xiaopeng/qa/camera/RearMirror;->onSettingsVisible(Landroid/content/Context;)V

    return-void
.end method
