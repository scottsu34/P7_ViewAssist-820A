.class Lcom/xiaopeng/qa/camera/MainActivity$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/xiaopeng/qa/camera/MainActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/xiaopeng/qa/camera/MainActivity;


# direct methods
.method constructor <init>(Lcom/xiaopeng/qa/camera/MainActivity;)V
    .locals 0

    .line 67
    iput-object p1, p0, Lcom/xiaopeng/qa/camera/MainActivity$1;->this$0:Lcom/xiaopeng/qa/camera/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 70
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity$1;->this$0:Lcom/xiaopeng/qa/camera/MainActivity;

    invoke-static {v0}, Lcom/xiaopeng/qa/camera/MainActivity;->access$000(Lcom/xiaopeng/qa/camera/MainActivity;)Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 71
    :cond_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity$1;->this$0:Lcom/xiaopeng/qa/camera/MainActivity;

    invoke-static {}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->isLinkActive()Z

    move-result v1

    invoke-static {v0, v1}, Lcom/xiaopeng/qa/camera/MainActivity;->access$102(Lcom/xiaopeng/qa/camera/MainActivity;Z)Z

    .line 72
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity$1;->this$0:Lcom/xiaopeng/qa/camera/MainActivity;

    invoke-static {v0}, Lcom/xiaopeng/qa/camera/MainActivity;->access$200(Lcom/xiaopeng/qa/camera/MainActivity;)V

    .line 73
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity$1;->this$0:Lcom/xiaopeng/qa/camera/MainActivity;

    invoke-static {v0}, Lcom/xiaopeng/qa/camera/MainActivity;->access$300(Lcom/xiaopeng/qa/camera/MainActivity;)V

    .line 74
    invoke-static {}, Lcom/xiaopeng/qa/camera/CameraOverlayService;->drainLogs()Ljava/util/List;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_0
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_1

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/String;

    .line 75
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/MainActivity$1;->this$0:Lcom/xiaopeng/qa/camera/MainActivity;

    invoke-static {v2, v1}, Lcom/xiaopeng/qa/camera/MainActivity;->access$400(Lcom/xiaopeng/qa/camera/MainActivity;Ljava/lang/String;)V

    goto :goto_0

    .line 77
    :cond_1
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/MainActivity$1;->this$0:Lcom/xiaopeng/qa/camera/MainActivity;

    invoke-static {v0}, Lcom/xiaopeng/qa/camera/MainActivity;->access$500(Lcom/xiaopeng/qa/camera/MainActivity;)Landroid/os/Handler;

    move-result-object v0

    const-wide/16 v1, 0x7d0

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method
