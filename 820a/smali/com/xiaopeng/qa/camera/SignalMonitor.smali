.class public final Lcom/xiaopeng/qa/camera/SignalMonitor;
.super Ljava/lang/Object;
.source "SignalMonitor.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;
    }
.end annotation


# static fields
.field private static final CMD:Ljava/lang/String; = "dumpsys car_service | grep -E \'lastEvent: ?Property=BCM_(L|R)TURNLAMP_ST\'"

.field private static final MIN_POLL_INTERVAL_MS:J = 0xc8L

.field private static final OFF_DEBOUNCE_MS:J = 0x9c4L

.field private static final PATTERN:Ljava/util/regex/Pattern;

.field private static final TAG:Ljava/lang/String; = "SignalMonitor"


# instance fields
.field private final adb:Lcom/xiaopeng/qa/camera/AdbClient;

.field private connectedNotified:Z

.field private final listener:Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;

.field private final lock:Ljava/lang/Object;

.field private offSinceMs:J

.field private final periodMs:J

.field private final running:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private thread:Ljava/lang/Thread;


# direct methods
.method public static synthetic $r8$lambda$iIVZgnbh_mJO6Pr-uWgignK66Vg(Lcom/xiaopeng/qa/camera/SignalMonitor;)V
    .locals 0

    invoke-direct {p0}, Lcom/xiaopeng/qa/camera/SignalMonitor;->loop()V

    return-void
.end method

.method static constructor <clinit>()V
    .locals 1

    const-string v0, "Property=(\\w+).*?int32Values:\\s*\\[([^\\]]*)\\]"

    .line 43
    invoke-static {v0}, Ljava/util/regex/Pattern;->compile(Ljava/lang/String;)Ljava/util/regex/Pattern;

    move-result-object v0

    sput-object v0, Lcom/xiaopeng/qa/camera/SignalMonitor;->PATTERN:Ljava/util/regex/Pattern;

    return-void
.end method

.method public constructor <init>(Lcom/xiaopeng/qa/camera/AdbClient;Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;J)V
    .locals 4

    .line 62
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 55
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->running:Ljava/util/concurrent/atomic/AtomicBoolean;

    const-wide/16 v2, -0x1

    .line 56
    iput-wide v2, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->offSinceMs:J

    .line 58
    new-instance v0, Ljava/lang/Object;

    invoke-direct {v0}, Ljava/lang/Object;-><init>()V

    iput-object v0, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->lock:Ljava/lang/Object;

    .line 60
    iput-boolean v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->connectedNotified:Z

    .line 63
    iput-object p1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->adb:Lcom/xiaopeng/qa/camera/AdbClient;

    .line 64
    iput-object p2, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->listener:Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;

    .line 65
    iput-wide p3, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->periodMs:J

    return-void
.end method

.method private loop()V
    .locals 14

    const/4 v0, 0x0

    const/4 v1, 0x0

    const/4 v2, 0x0

    const/4 v3, 0x0

    .line 115
    :goto_0
    :try_start_0
    iget-object v4, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->running:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v4}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v4
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    if-eqz v4, :cond_14

    const/4 v4, 0x1

    .line 117
    :try_start_1
    iget-object v5, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->adb:Lcom/xiaopeng/qa/camera/AdbClient;

    const-string v6, "dumpsys car_service | grep -E \'lastEvent: ?Property=BCM_(L|R)TURNLAMP_ST\'"

    invoke-virtual {v5, v6}, Lcom/xiaopeng/qa/camera/AdbClient;->exec(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_3

    const-string v6, "\\r?\\n"

    .line 123
    invoke-virtual {v5, v6}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v5

    array-length v6, v5

    move v8, v1

    move v9, v2

    const/4 v7, 0x0

    :goto_1
    if-ge v7, v6, :cond_4

    aget-object v10, v5, v7

    .line 124
    sget-object v11, Lcom/xiaopeng/qa/camera/SignalMonitor;->PATTERN:Ljava/util/regex/Pattern;

    invoke-virtual {v11, v10}, Ljava/util/regex/Pattern;->matcher(Ljava/lang/CharSequence;)Ljava/util/regex/Matcher;

    move-result-object v10

    .line 125
    invoke-virtual {v10}, Ljava/util/regex/Matcher;->find()Z

    move-result v11
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_3
    .catchall {:try_start_1 .. :try_end_1} :catchall_1

    if-eqz v11, :cond_2

    const/4 v11, 0x2

    .line 128
    :try_start_2
    invoke-virtual {v10, v11}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v11

    invoke-virtual {v11}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v11

    invoke-static {v11}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v11
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_1

    goto :goto_2

    :catch_0
    nop

    const/4 v11, 0x0

    :goto_2
    if-eqz v11, :cond_0

    const/4 v11, 0x1

    goto :goto_3

    :cond_0
    const/4 v11, 0x0

    .line 132
    :goto_3
    :try_start_3
    invoke-virtual {v10, v4}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v12

    const-string v13, "LTURNLAMP"

    invoke-virtual {v12, v13}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v12

    if-eqz v12, :cond_1

    move v8, v11

    goto :goto_4

    .line 133
    :cond_1
    invoke-virtual {v10, v4}, Ljava/util/regex/Matcher;->group(I)Ljava/lang/String;

    move-result-object v10

    const-string v12, "RTURNLAMP"

    invoke-virtual {v10, v12}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v10
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    if-eqz v10, :cond_2

    move v9, v11

    :cond_2
    :goto_4
    add-int/lit8 v7, v7, 0x1

    goto :goto_1

    :cond_3
    move v8, v1

    move v9, v2

    .line 139
    :cond_4
    :try_start_4
    iget-boolean v3, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->connectedNotified:Z

    if-nez v3, :cond_5

    .line 140
    iput-boolean v4, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->connectedNotified:Z
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_2
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    .line 142
    :try_start_5
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->listener:Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;

    invoke-interface {v3}, Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;->onAdbConnected()V
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_1
    .catchall {:try_start_5 .. :try_end_5} :catchall_1

    goto :goto_5

    :catch_1
    move-exception v3

    :try_start_6
    const-string v5, "SignalMonitor"

    .line 144
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "onAdbConnected \u56de\u8c03\u5f02\u5e38: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v5, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_5
    :goto_5
    if-eqz v8, :cond_6

    if-nez v1, :cond_6

    const/4 v3, 0x1

    goto :goto_6

    :cond_6
    const/4 v3, 0x0

    :goto_6
    if-eqz v9, :cond_7

    if-nez v2, :cond_7

    const/4 v5, 0x1

    goto :goto_7

    :cond_7
    const/4 v5, 0x0

    :goto_7
    if-nez v8, :cond_9

    if-eqz v9, :cond_8

    goto :goto_8

    :cond_8
    const/4 v6, 0x0

    goto :goto_9

    :cond_9
    :goto_8
    const/4 v6, 0x1

    :goto_9
    if-nez v1, :cond_b

    if-eqz v2, :cond_a

    goto :goto_a

    :cond_a
    const/4 v7, 0x0

    goto :goto_b

    :cond_b
    :goto_a
    const/4 v7, 0x1

    :goto_b
    const-wide/16 v10, -0x1

    # hazard: both lamps on -> clear new-edge flags (v3/v5)
    if-eqz v8, :not_hazard1
    if-eqz v9, :not_hazard1
    const/4 v3, 0x0
    const/4 v5, 0x0
    :not_hazard1

    if-nez v3, :cond_f

    if-eqz v5, :cond_c

    goto :goto_c

    :cond_c
    if-nez v6, :cond_e

    if-eqz v7, :cond_d

    .line 161
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    iput-wide v5, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->offSinceMs:J

    goto :goto_e

    .line 162
    :cond_d
    iget-wide v5, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->offSinceMs:J

    cmp-long v3, v5, v10

    if-eqz v3, :cond_11

    .line 163
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    iget-wide v12, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->offSinceMs:J

    sub-long/2addr v5, v12

    const-wide/16 v12, 0x9c4

    cmp-long v3, v5, v12

    if-ltz v3, :cond_11

    const-string v3, "SignalMonitor"

    .line 165
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "\u8f6c\u5411\u4fe1\u53f7 \u7184\u706d L="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v8}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v6, " R="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v3, v5}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 166
    iget-object v3, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->listener:Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;

    const/4 v5, 0x0

    invoke-interface {v3, v5, v0}, Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;->onSignalChanged(Ljava/lang/String;Z)V

    .line 167
    iput-wide v10, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->offSinceMs:J

    goto :goto_e

    .line 172
    :cond_e
    iput-wide v10, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->offSinceMs:J

    goto :goto_e

    :cond_f
    :goto_c
    # hazard: both lamps on -> skip side overlay
    if-nez v8, :hazard_ok
    if-nez v9, :hazard_ok
    const-string v5, "SignalMonitor"
    const-string v6, "both_on_skip"
    invoke-static {v5, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    goto :goto_e
    :hazard_ok
    if-eqz v3, :cond_10

    const-string v3, "LEFT"

    goto :goto_d

    :cond_10
    const-string v3, "RIGHT"

    :goto_d
    const-string v5, "SignalMonitor"

    .line 155
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "\u8f6c\u5411\u4fe1\u53f7 \u4eae\u8d77\u8fb9\u6cbf dir="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " L="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v8}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v7, " R="

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v9}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 156
    iget-object v5, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->listener:Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;

    invoke-interface {v5, v3, v4}, Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;->onSignalChanged(Ljava/lang/String;Z)V

    .line 157
    iput-wide v10, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->offSinceMs:J
    :try_end_6
    .catch Ljava/lang/Exception; {:try_start_6 .. :try_end_6} :catch_2
    .catchall {:try_start_6 .. :try_end_6} :catchall_1

    :cond_11
    :goto_e
    move v1, v8

    move v2, v9

    const/4 v3, 0x0

    goto :goto_10

    :catch_2
    move-exception v5

    const/4 v3, 0x0

    goto :goto_f

    :catch_3
    move-exception v5

    :goto_f
    add-int/2addr v3, v4

    :try_start_7
    const-string v6, "AdbClient"

    .line 178
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    const-string v8, "\u8f6e\u8be2\u5931\u8d25: "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-static {v6, v7}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    if-eq v3, v4, :cond_12

    .line 179
    rem-int/lit8 v4, v3, 0xa

    if-nez v4, :cond_13

    .line 180
    :cond_12
    iget-object v4, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->listener:Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "\u8f6e\u8be2\u5931\u8d25(\u7b2c"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, "\u6b21): "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-interface {v4, v5}, Lcom/xiaopeng/qa/camera/SignalMonitor$Listener;->onLog(Ljava/lang/String;)V
    :try_end_7
    .catchall {:try_start_7 .. :try_end_7} :catchall_1

    .line 185
    :cond_13
    :goto_10
    :try_start_8
    iget-wide v4, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->periodMs:J

    const-wide/16 v6, 0xc8

    invoke-static {v4, v5, v6, v7}, Ljava/lang/Math;->max(JJ)J

    move-result-wide v4

    invoke-static {v4, v5}, Ljava/lang/Thread;->sleep(J)V
    :try_end_8
    .catch Ljava/lang/InterruptedException; {:try_start_8 .. :try_end_8} :catch_4
    .catchall {:try_start_8 .. :try_end_8} :catchall_1

    goto/16 :goto_0

    .line 193
    :catch_4
    :cond_14
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->running:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v1, v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 194
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->lock:Ljava/lang/Object;

    monitor-enter v1

    .line 195
    :try_start_9
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->lock:Ljava/lang/Object;

    invoke-virtual {v0}, Ljava/lang/Object;->notifyAll()V

    .line 196
    monitor-exit v1

    return-void

    :catchall_0
    move-exception v0

    monitor-exit v1
    :try_end_9
    .catchall {:try_start_9 .. :try_end_9} :catchall_0

    throw v0

    :catchall_1
    move-exception v1

    .line 193
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->running:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v2, v0}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 194
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 195
    :try_start_a
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->lock:Ljava/lang/Object;

    invoke-virtual {v2}, Ljava/lang/Object;->notifyAll()V

    .line 196
    monitor-exit v0
    :try_end_a
    .catchall {:try_start_a .. :try_end_a} :catchall_2

    .line 197
    throw v1

    :catchall_2
    move-exception v1

    .line 196
    :try_start_b
    monitor-exit v0
    :try_end_b
    .catchall {:try_start_b .. :try_end_b} :catchall_2

    goto :goto_12

    :goto_11
    throw v1

    :goto_12
    goto :goto_11
.end method


# virtual methods
.method public start()Z
    .locals 5

    .line 72
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 73
    :try_start_0
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->running:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v1}, Ljava/util/concurrent/atomic/AtomicBoolean;->get()Z

    move-result v1

    const/4 v2, 0x1

    if-eqz v1, :cond_0

    monitor-exit v0

    return v2

    .line 74
    :cond_0
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->thread:Ljava/lang/Thread;

    if-eqz v1, :cond_1

    invoke-virtual {v1}, Ljava/lang/Thread;->isAlive()Z

    move-result v1

    if-eqz v1, :cond_1

    const-string v1, "SignalMonitor"

    const-string v2, "\u65e7\u8f6e\u8be2\u7ebf\u7a0b\u672a\u9000\u51fa\uff08\u53ef\u80fd\u963b\u585e\u4e8e Socket read 15s\uff09\uff0c\u6682\u4e0d\u542f\u52a8\u65b0\u7ebf\u7a0b"

    .line 75
    invoke-static {v1, v2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 76
    monitor-exit v0

    const/4 v0, 0x0

    return v0

    :cond_1
    const/4 v1, 0x0

    .line 78
    iput-object v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->thread:Ljava/lang/Thread;

    .line 79
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->running:Ljava/util/concurrent/atomic/AtomicBoolean;

    invoke-virtual {v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 80
    new-instance v1, Ljava/lang/Thread;

    new-instance v3, Lcom/xiaopeng/qa/camera/SignalMonitor$$ExternalSyntheticLambda0;

    invoke-direct {v3, p0}, Lcom/xiaopeng/qa/camera/SignalMonitor$$ExternalSyntheticLambda0;-><init>(Lcom/xiaopeng/qa/camera/SignalMonitor;)V

    const-string v4, "signal-monitor"

    invoke-direct {v1, v3, v4}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    iput-object v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->thread:Ljava/lang/Thread;

    .line 81
    invoke-virtual {v1, v2}, Ljava/lang/Thread;->setDaemon(Z)V

    .line 82
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->thread:Ljava/lang/Thread;

    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    .line 83
    monitor-exit v0

    return v2

    :catchall_0
    move-exception v1

    .line 84
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    throw v1
.end method

.method public stop()V
    .locals 4

    .line 91
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 92
    :try_start_0
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->running:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Ljava/util/concurrent/atomic/AtomicBoolean;->set(Z)V

    .line 93
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->thread:Ljava/lang/Thread;

    .line 94
    monitor-exit v0
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    if-eqz v1, :cond_1

    .line 96
    invoke-virtual {v1}, Ljava/lang/Thread;->interrupt()V

    const-wide/16 v2, 0x7d0

    .line 98
    :try_start_1
    invoke-virtual {v1, v2, v3}, Ljava/lang/Thread;->join(J)V
    :try_end_1
    .catch Ljava/lang/InterruptedException; {:try_start_1 .. :try_end_1} :catch_0

    .line 101
    :catch_0
    iget-object v0, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->lock:Ljava/lang/Object;

    monitor-enter v0

    .line 105
    :try_start_2
    iget-object v2, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->thread:Ljava/lang/Thread;

    if-ne v2, v1, :cond_0

    invoke-virtual {v1}, Ljava/lang/Thread;->isAlive()Z

    move-result v1

    if-nez v1, :cond_0

    const/4 v1, 0x0

    iput-object v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->thread:Ljava/lang/Thread;

    .line 106
    :cond_0
    iget-object v1, p0, Lcom/xiaopeng/qa/camera/SignalMonitor;->lock:Ljava/lang/Object;

    invoke-virtual {v1}, Ljava/lang/Object;->notifyAll()V

    .line 107
    monitor-exit v0

    goto :goto_0

    :catchall_0
    move-exception v1

    monitor-exit v0
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    throw v1

    :cond_1
    :goto_0
    return-void

    :catchall_1
    move-exception v1

    .line 94
    :try_start_3
    monitor-exit v0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_1

    throw v1
.end method
