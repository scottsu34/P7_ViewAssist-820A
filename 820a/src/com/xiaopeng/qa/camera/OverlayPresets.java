package com.xiaopeng.qa.camera;

import android.app.Activity;
import android.view.Gravity;
import android.view.TextureView;
import android.widget.FrameLayout;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.Matrix;
import android.graphics.Typeface;
import android.util.DisplayMetrics;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

/**
 * 浮窗位置预设：
 *  - 隐藏原来的“右浮窗对齐左浮窗”；
 *  - 六个按钮（还原 + 5 个位置）排成两行三列；
 *  - 还原时左右两侧位置都回到左上角；
 *  - 使用说明追加作者信息。
 *
 * 位置直接写入 SharedPreferences（left_/right_overlay_pos_x/y + recorded），
 * 再通过既有的 ALIGN 动作让正在显示的浮窗立即应用新位置。
 */
public final class OverlayPresets {

    private static final String PREFS = "cameraassist";
    private static final int MARGIN_X = 120;
    private static final int MARGIN_Y = 90;
    private static final int BUTTON_H = 64;

    private static Button sMirrorButton;
    private static View sAdbRow;
    private static View sDebugRow;
    private static View sLinkRow;
    private static View sFlipRow;
    private static View sMirrorRow;
    private static View sGrid;
    private static TextView sUsageHint;
    private static TextView sStatusLeft;
    private static TextView sStatusRight;
    private static Button sLockButton;

    private static final int PRESET_TOP_LEFT = 0;
    private static final int PRESET_BOTTOM_LEFT = 1;
    private static final int PRESET_TOP_RIGHT = 2;
    private static final int PRESET_BOTTOM_RIGHT = 3;
    private static final int PRESET_SIDES = 4;

    private static final String[] LABELS = {
            "浮窗靠左上", "浮窗靠左下", "浮窗靠右上", "浮窗靠右下", "浮窗靠两侧"
    };

    private OverlayPresets() {
    }

    /** 在 Activity 的按钮列表里生成两行三列的位置按钮。 */
    /** 轮询开启且后视镜开启时，确保后台服务在运行（不依赖打灯联动）。 */
    /** 打灯联动是否应在下次启动时自动恢复。 */
    public static boolean isLinkWanted(Context context) {
        return context != null
                && context.getSharedPreferences(PREFS, 0).getBoolean("link_wanted", false);
    }

    public static void setLinkWanted(Context context, boolean wanted) {
        if (context != null) {
            context.getSharedPreferences(PREFS, 0).edit().putBoolean("link_wanted", wanted).apply();
        }
    }

    /** 启动联动服务（恢复上次开启状态）。 */
    public static void startLinkService(Context context) {
        if (context == null) {
            return;
        }
        try {
            Class<?> serviceClass = Class.forName("com.xiaopeng.qa.camera.CameraOverlayService");
            Intent intent = new Intent(context, serviceClass);
            intent.setAction("com.xiaopeng.qa.camera.START_LINK");
            intent.putExtra("host", "127.0.0.1");
            intent.putExtra("port", 5555);
            context.startService(intent);
        } catch (Throwable ignored) {
        }
    }

    /** 如果上次是开启状态且轮询开启，自动恢复联动。 */
    public static void restoreLinkIfWanted(Context context) {
        if (context == null || !isAdbPolling(context) || !isLinkWanted(context)) {
            return;
        }
        startLinkService(context);
    }

    static void ensureService(Context context) {
        if (context == null || !isAdbPolling(context)) {
            return;
        }
        try {
            Class<?> serviceClass = Class.forName("com.xiaopeng.qa.camera.CameraOverlayService");
            context.startService(new Intent(context, serviceClass));
        } catch (Throwable ignored) {
        }
    }

    public static void install(final Activity activity) {
        ensureService(activity);
        restoreLinkIfWanted(activity);
        try {
            LinearLayout container = findContainer(activity.findViewById(android.R.id.content));
            if (container == null) {
                return;
            }
            int alignId = activity.getResources().getIdentifier(
                    "btn_align_right_to_left", "id", activity.getPackageName());
            if (alignId != 0) {
                View align = activity.findViewById(alignId);
                if (align != null) {
                    // 只隐藏，不移除：MainActivity.onCreate 稍后还会 findViewById 它并设置监听
                    align.setVisibility(View.GONE);
                }
            }
            int resetId = activity.getResources().getIdentifier(
                    "btn_reset_overlay", "id", activity.getPackageName());
            View reset = resetId == 0 ? null : activity.findViewById(resetId);
            int insertIndex = reset == null ? container.getChildCount() : container.indexOfChild(reset);
            if (reset != null) {
                reset.setVisibility(View.GONE);
            }
            int bg = activity.getResources().getIdentifier(
                    "bg_button", "drawable", activity.getPackageName());

            LinearLayout grid = new LinearLayout(activity);
            sGrid = grid;
            grid.setOrientation(LinearLayout.VERTICAL);
            grid.setLayoutParams(new LinearLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

            LinearLayout row1 = newRow(activity);
            row1.addView(makeButton(activity, "还原浮窗设置", bg, new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    try {
                        reset(view.getContext());
                    } catch (Throwable t) {
                        Toast.makeText(view.getContext(), "还原失败: " + t, Toast.LENGTH_SHORT).show();
                    }
                }
            }));
            row1.addView(makeButton(activity, LABELS[0], bg, presetListener(PRESET_TOP_LEFT)));
            row1.addView(makeButton(activity, LABELS[1], bg, presetListener(PRESET_BOTTOM_LEFT)));
            LinearLayout row2 = newRow(activity);
            row2.addView(makeButton(activity, LABELS[2], bg, presetListener(PRESET_TOP_RIGHT)));
            row2.addView(makeButton(activity, LABELS[3], bg, presetListener(PRESET_BOTTOM_RIGHT)));
            row2.addView(makeButton(activity, LABELS[4], bg, presetListener(PRESET_SIDES)));
            grid.addView(row1);
            grid.addView(row2);
            container.addView(grid, Math.max(0, insertIndex));

            // 「打灯联动」同一行右侧：流媒体后视镜开关
            int linkId = activity.getResources().getIdentifier(
                    "sw_enable", "id", activity.getPackageName());
            View link = linkId == 0 ? null : activity.findViewById(linkId);
            if (link != null && link.getParent() instanceof ViewGroup) {
                ViewGroup parent = (ViewGroup) link.getParent();
                int gridIndex = parent.indexOfChild(grid);

                // 「打灯联动」单独一行（保持原样），位置按钮下方一行放后视镜与锁定开关
                LinearLayout row = new LinearLayout(activity);
                row.setOrientation(LinearLayout.HORIZONTAL);
                LinearLayout.LayoutParams rowParams = new LinearLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT, dp(activity, BUTTON_H));
                rowParams.topMargin = dp(activity, 8);
                row.setLayoutParams(rowParams);

                sMirrorButton = new Button(activity);
                sMirrorButton.setTextSize(19.0f);
                sMirrorButton.setTextColor(Color.WHITE);
                if (bg != 0) {
                    sMirrorButton.setBackgroundResource(bg);
                }
                LinearLayout.LayoutParams mirrorParams = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                mirrorParams.rightMargin = dp(activity, 5);
                sMirrorButton.setLayoutParams(mirrorParams);
                updateMirrorButton(activity, sMirrorButton);
                sMirrorButton.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        boolean on = RearMirror.toggle(view.getContext());
                        if (on) {
                            ensureService(view.getContext());
                        }
                        updateMirrorButton(view.getContext(), (Button) view);
                        Toast.makeText(view.getContext(),
                                on ? "\u6d41\u5a92\u4f53\u540e\u89c6\u955c\u5df2\u5f00\u542f" : "\u6d41\u5a92\u4f53\u540e\u89c6\u955c\u5df2\u5173\u95ed",
                                Toast.LENGTH_SHORT).show();
                    }
                });
                row.addView(sMirrorButton);

                sLockButton = new Button(activity);
                sLockButton.setTextSize(19.0f);
                sLockButton.setTextColor(Color.WHITE);
                if (bg != 0) {
                    sLockButton.setBackgroundResource(bg);
                }
                LinearLayout.LayoutParams lockParams = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                lockParams.leftMargin = dp(activity, 5);
                sLockButton.setLayoutParams(lockParams);
                updateLockButton(activity, sLockButton);
                sLockButton.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        boolean locked = !RearMirror.isLocked(view.getContext());
                        RearMirror.setLocked(view.getContext(), locked);
                        updateLockButton(view.getContext(), (Button) view);
                        Toast.makeText(view.getContext(),
                                locked ? "\u5df2\u9501\u5b9a\u540e\u89c6\u955c\u4f4d\u7f6e/\u5927\u5c0f" : "\u5df2\u89e3\u9501\u540e\u89c6\u955c\u4f4d\u7f6e/\u5927\u5c0f",
                                Toast.LENGTH_SHORT).show();
                    }
                });
                row.addView(sLockButton);

                Button bsdMirror = new Button(activity);
                bsdMirror.setTextSize(19.0f);
                bsdMirror.setTextColor(Color.WHITE);
                if (bg != 0) {
                    bsdMirror.setBackgroundResource(bg);
                }
                final Button bsdMirrorRef = bsdMirror;
                updateBsdButton(activity, bsdMirror, true);
                bsdMirror.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        boolean on = !isBsdMirror(view.getContext());
                        setBsdMirror(view.getContext(), on);
                        updateBsdButton(view.getContext(), bsdMirrorRef, true);
                    }
                });
                LinearLayout.LayoutParams bsdMirrorParams = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                bsdMirrorParams.leftMargin = dp(activity, 5);
                bsdMirror.setLayoutParams(bsdMirrorParams);
                row.addView(bsdMirror);

                parent.addView(row, Math.max(0, gridIndex + 1));
            sMirrorRow = row;
            }

            int hintId = activity.getResources().getIdentifier(
                    "tv_usage_hint", "id", activity.getPackageName());
            if (hintId != 0) {
                TextView hint = activity.findViewById(hintId);
                sUsageHint = hint;
                if (hint != null) {
                    hint.setTextSize(20.0f);
        hint.setText(""
                + "1. \u4f7f\u7528\u524d\u8bf7\u5148\u5728\u8f66\u8f86\u8bbe\u7f6e\u4e2d\u5173\u95ed\u300c\u8f6c\u5411\u6fc0\u6d3b\u5168\u666f\u5f71\u50cf\u300d\u529f\u80fd\uff0c\u5426\u5219\u65e0\u6cd5\u4f7f\u7528\u8be5\u7a0b\u5e8f\u3002\n"
                + "2. \u9996\u6b21\u5f00\u542f\u300cADB \u8f6e\u8be2\u300d\u65f6\uff0c\u8f66\u673a\u4f1a\u5f39\u51fa ADB \u914d\u5bf9\u786e\u8ba4\uff0c\u8bf7\u70b9\u51fb\u786e\u8ba4\uff0c\u786e\u8ba4\u540e\u5e94\u7528\u53ef\u80fd\u4f1a\u81ea\u52a8\u91cd\u542f\u4e00\u6b21\uff0c\u91cd\u65b0\u8fdb\u5165\u5373\u53ef\u6b63\u5e38\u4f7f\u7528\u3002\n"
                + "3. \u300c\u8c03\u8bd5\u6a21\u5f0f\u300d\u5f00\u542f\u540e\uff0cP \u6863\u4e5f\u4f1a\u663e\u793a\u753b\u9762\uff0c\u5173\u95ed\u540e\u5219\u53ea\u6709\u5728 D \u6863\u624d\u663e\u793a\u753b\u9762\u3002\n"
                + "4. \u6d6e\u7a97\u64cd\u4f5c\uff1a\u5355\u6307\u62d6\u52a8\u6d6e\u7a97\u5230\u5408\u9002\u4f4d\u7f6e\uff08\u677e\u624b\u81ea\u52a8\u4fdd\u5b58\uff09\uff0c\u53cc\u51fb\u6d6e\u7a97\u8fdb\u5165\u7f16\u8f91\u6a21\u5f0f\uff08\u7f16\u8f91\u65b9\u5f0f\u53c2\u89c1\u6d6e\u7a97\u63d0\u793a\uff09\uff0c\u518d\u6b21\u53cc\u51fb\u9000\u51fa\u7f16\u8f91\u6a21\u5f0f\u3002\n"
                + "5. \u82e5\u753b\u9762\u8c03\u6574\u4e71\u4e86\u8c03\u4e0d\u56de\u6765\uff0c\u53ef\u4ee5\u70b9\u51fb\u300c\u8fd8\u539f\u6d6e\u7a97\u8bbe\u7f6e\u300d\uff0c\u6d6e\u7a97\u4f4d\u7f6e\u3001\u5f62\u72b6\u3001\u753b\u9762\u4e0e\u89c6\u89d2\u5c06\u5168\u90e8\u6062\u590d\u9ed8\u8ba4\u3002\n"
                + "6. \u672c\u7a0b\u5e8f\u4ec5\u4f5c\u4e3a\u4e2a\u4eba\u6d4b\u8bd5\u4f7f\u7528\uff0c\u7981\u6b62\u5546\u7528\u3001\u7981\u6b62\u4f20\u64ad\uff01\n"
                + "7. \u7a0b\u5e8f\u53ef\u80fd\u5b58\u5728\u4e0d\u53ef\u9884\u77e5\u7684\u95ee\u9898\uff0c\u7531\u6b64\u9020\u6210\u7684\u540e\u679c\uff0c\u7531\u4f7f\u7528\u8005\u81ea\u884c\u627f\u62c5!\n"
                + "8. \u672c\u7a0b\u5e8f\u7531 Heyds \u539f\u521b\uff0cSS \u4fee\u6539\u9002\u914d 820A\uff0c\u7279\u522b\u611f\u8c22\u539f\u4f5c\u8005 Heyds!");
                }
            }
            // 打灯联动 + 后侧方画面 同一行
            int linkId2 = activity.getResources().getIdentifier(
                    "sw_enable", "id", activity.getPackageName());
            View linkView = linkId2 == 0 ? null : activity.findViewById(linkId2);
            Button rearSide = new Button(activity);
            rearSide.setTextSize(19.0f);
            rearSide.setTextColor(Color.WHITE);
            if (bg != 0) {
                rearSide.setBackgroundResource(bg);
            }
            updateRearSideButton(activity, rearSide);
            rearSide.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    boolean on = !isRearSideView(view.getContext());
                    setRearSideView(view.getContext(), on);
                    updateRearSideButton(view.getContext(), (Button) view);
                    Toast.makeText(view.getContext(),
                            on ? "\u540e\u4fa7\u65b9\u753b\u9762\u5df2\u5f00\u542f" : "\u540e\u4fa7\u65b9\u753b\u9762\u5df2\u5173\u95ed",
                            Toast.LENGTH_SHORT).show();
                }
            });
            if (linkView != null && linkView.getParent() instanceof ViewGroup) {
                ViewGroup linkParent = (ViewGroup) linkView.getParent();
                int linkIndex = linkParent.indexOfChild(linkView);
                LinearLayout linkRow = new LinearLayout(activity);
                linkRow.setOrientation(LinearLayout.HORIZONTAL);
                LinearLayout.LayoutParams rowParams = new LinearLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT, dp(activity, BUTTON_H));
                rowParams.topMargin = dp(activity, 8);
                linkRow.setLayoutParams(rowParams);
                linkRow.setClipChildren(false);
                linkRow.setClipToPadding(false);
                linkRow.setBaselineAligned(false);
                linkParent.removeView(linkView);
                LinearLayout.LayoutParams linkParams = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                linkParams.rightMargin = dp(activity, 5);
                ((Button) linkView).setTextSize(19.0f);
                linkView.setLayoutParams(linkParams);
                linkRow.addView(linkView);
                LinearLayout.LayoutParams rearParams = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                rearParams.leftMargin = dp(activity, 5);
                rearSide.setLayoutParams(rearParams);
                linkRow.addView(rearSide);
                Button rotate = new Button(activity);
                rotate.setTextSize(19.0f);
                rotate.setTextColor(Color.WHITE);
                if (bg != 0) {
                    rotate.setBackgroundResource(bg);
                }
                updateRotateButton(activity, rotate);
                rotate.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        boolean on = !isRotate90(view.getContext());
                        setRotate90(view.getContext(), on);
                        updateRotateButton(view.getContext(), (Button) view);
                        Toast.makeText(view.getContext(),
                                on ? "\u753b\u9762\u65cb\u8f6c 90\u00b0\u5df2\u5f00\u542f" : "\u753b\u9762\u65cb\u8f6c 90\u00b0\u5df2\u5173\u95ed",
                                Toast.LENGTH_SHORT).show();
                    }
                });
                LinearLayout.LayoutParams rotateParams = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                rotateParams.leftMargin = dp(activity, 5);
                rotate.setLayoutParams(rotateParams);
                Button bsdSide = new Button(activity);
                bsdSide.setTextSize(19.0f);
                bsdSide.setTextColor(Color.WHITE);
                if (bg != 0) {
                    bsdSide.setBackgroundResource(bg);
                }
                final Button bsdSideRef = bsdSide;
                updateBsdButton(activity, bsdSide, false);
                bsdSide.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        boolean on = !isBsdSide(view.getContext());
                        setBsdSide(view.getContext(), on);
                        updateBsdButton(view.getContext(), bsdSideRef, false);
                    }
                });
                LinearLayout.LayoutParams bsdParams = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                bsdParams.leftMargin = dp(activity, 5);
                bsdSide.setLayoutParams(bsdParams);
                linkRow.addView(bsdSide);
                linkParent.addView(linkRow, Math.max(0, linkIndex));
                sLinkRow = linkRow;

                LinearLayout flipRow = new LinearLayout(activity);
                flipRow.setOrientation(LinearLayout.HORIZONTAL);
                flipRow.setLayoutParams(new LinearLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT, dp(activity, BUTTON_H)));
                flipRow.setBaselineAligned(false);
                final Button flipLeft = new Button(activity);
                flipLeft.setTextSize(19.0f);
                flipLeft.setTextColor(Color.WHITE);
                if (bg != 0) {
                    flipLeft.setBackgroundResource(bg);
                }
                updateFlipButton(activity, flipLeft, true);
                flipLeft.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        boolean on = !isFlipLeft(view.getContext());
                        setFlipLeft(view.getContext(), on);
                        updateFlipButton(view.getContext(), (Button) view, true);
                    }
                });
                LinearLayout.LayoutParams flp = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                flp.rightMargin = dp(activity, 3);
                flipLeft.setLayoutParams(flp);
                flipRow.addView(flipLeft);

                final Button flipRight = new Button(activity);
                flipRight.setTextSize(19.0f);
                flipRight.setTextColor(Color.WHITE);
                if (bg != 0) {
                    flipRight.setBackgroundResource(bg);
                }
                updateFlipButton(activity, flipRight, false);
                flipRight.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        boolean on = !isFlipRight(view.getContext());
                        setFlipRight(view.getContext(), on);
                        updateFlipButton(view.getContext(), (Button) view, false);
                    }
                });
                LinearLayout.LayoutParams frp = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                frp.leftMargin = dp(activity, 3);
                flipRight.setLayoutParams(frp);
                flipRow.addView(flipRight);

                LinearLayout.LayoutParams rotParams2 = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                rotParams2.leftMargin = dp(activity, 6);
                rotate.setLayoutParams(rotParams2);
                flipRow.addView(rotate);

                int flipIndex = linkParent.indexOfChild(linkRow) + 1;
                linkParent.addView(flipRow, flipIndex);
                sFlipRow = flipRow;

                LinearLayout adbRow = new LinearLayout(activity);
                adbRow.setOrientation(LinearLayout.HORIZONTAL);
                LinearLayout.LayoutParams adbRowParams = new LinearLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT, dp(activity, BUTTON_H));
                adbRow.setLayoutParams(adbRowParams);
                adbRow.setBaselineAligned(false);

                Button adbToggle = new Button(activity);
                adbToggle.setTextSize(19.0f);
                adbToggle.setTextColor(Color.WHITE);
                if (bg != 0) {
                    adbToggle.setBackgroundResource(bg);
                }
                final Button adbButtonRef = adbToggle;
                updateAdbButton(activity, adbToggle);
                adbToggle.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        boolean on = !isAdbPolling(view.getContext());
                        setAdbPolling(view.getContext(), on);
                        updateAdbButton(view.getContext(), adbButtonRef);
                        applyPollingGate((Activity) view.getContext());
                        if (!on) {
                            setLinkWanted(view.getContext(), false);
                            stopLink(view.getContext());
                            try {
                                RearMirror.setEnabled(view.getContext(), false);
                            } catch (Throwable ignored) {
                            }
                        } else {
                            ensureService(view.getContext());
                        }
                        Toast.makeText(view.getContext(),
                                on ? "ADB \u8f6e\u8be2\u5df2\u5f00\u542f" : "ADB \u8f6e\u8be2\u5df2\u5173\u95ed",
                                Toast.LENGTH_SHORT).show();
                    }
                });
                LinearLayout.LayoutParams adbParams = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                adbParams.rightMargin = dp(activity, 5);
                adbToggle.setLayoutParams(adbParams);
                adbRow.addView(adbToggle);

                Button debugBtn2 = new Button(activity);
                debugBtn2.setTextSize(19.0f);
                debugBtn2.setTextColor(Color.WHITE);
                if (bg != 0) {
                    debugBtn2.setBackgroundResource(bg);
                }
                final Button debugRef2 = debugBtn2;
                updateDebugButton(activity, debugBtn2);
                debugBtn2.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        boolean on = !isDebugMode(view.getContext());
                        setDebugMode(view.getContext(), on);
                        updateDebugButton(view.getContext(), debugRef2);
                        Toast.makeText(view.getContext(),
                                on ? "\u8c03\u8bd5\u6a21\u5f0f\u5df2\u5f00\u542f\uff08P\u6863\u4e5f\u663e\u793a\uff09"
                                   : "\u8c03\u8bd5\u6a21\u5f0f\u5df2\u5173\u95ed",
                                Toast.LENGTH_SHORT).show();
                    }
                });
                LinearLayout.LayoutParams dbgParams = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                dbgParams.leftMargin = dp(activity, 5);
                dbgParams.rightMargin = dp(activity, 5);
                debugBtn2.setLayoutParams(dbgParams);
                adbRow.addView(debugBtn2);


                Button exit = new Button(activity);
                exit.setText("\u9000\u51fa\u8f6f\u4ef6");
                exit.setTextSize(19.0f);
                exit.setTextColor(Color.WHITE);
                if (bg != 0) {
                    exit.setBackgroundResource(bg);
                }
                LinearLayout.LayoutParams exitParams = new LinearLayout.LayoutParams(
                        0, dp(activity, BUTTON_H), 1.0f);
                exitParams.leftMargin = dp(activity, 5);
                exit.setLayoutParams(exitParams);
                exit.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        stopLink(view.getContext());
                        ((Activity) view.getContext()).finish();
                    }
                });
                adbRow.addView(exit);

                linkParent.addView(adbRow, Math.max(0, linkIndex));
                sAdbRow = adbRow;



                applyPollingGate(activity);
            }

            // 日志功能已移除：隐藏“状态日志”标题行与日志内容区
            int clearId = activity.getResources().getIdentifier(
                    "btn_clear_log", "id", activity.getPackageName());
            if (clearId != 0) {
                View clear = activity.findViewById(clearId);
                if (clear != null) {
                    android.view.ViewParent parent = clear.getParent();
                    if (parent instanceof View) {
                        ((View) parent).setVisibility(View.GONE);
                    } else {
                        clear.setVisibility(View.GONE);
                    }
                }
            }
            int logId = activity.getResources().getIdentifier(
                    "tv_log", "id", activity.getPackageName());
            if (logId != 0) {
                View logView = activity.findViewById(logId);
                if (logView != null) {
                    logView.setVisibility(View.GONE);
                }
            }
            // 分组标题
            insertHeader(activity, sDebugRow, "ADB \u6388\u6743\u4e0e\u8c03\u8bd5");
            insertHeader(activity, sLinkRow, "\u6253\u706f\u8054\u52a8\u8bbe\u7f6e");
            if (sMirrorRow != null && sGrid != null
                    && sMirrorRow.getParent() instanceof LinearLayout
                    && sMirrorRow.getParent() == sGrid.getParent()) {
                LinearLayout holder = (LinearLayout) sMirrorRow.getParent();
                int gridAt = holder.indexOfChild(sGrid);
                holder.removeView(sMirrorRow);
                holder.addView(sMirrorRow, Math.max(0, gridAt));
            }
            insertHeader(activity, sMirrorRow, "\u6d41\u5a92\u4f53\u540e\u89c6\u955c\u8bbe\u7f6e");
            insertHeader(activity, sGrid, "\u6d6e\u7a97\u4f4d\u7f6e\u8bbe\u7f6e");
            insertHeader(activity, sUsageHint, "\u4f7f\u7528\u8bf4\u660e");

            int stateId = activity.getResources().getIdentifier("tv_state", "id", activity.getPackageName());
            View stateView = stateId == 0 ? null : activity.findViewById(stateId);
            int permOverlay = activity.getResources().getIdentifier("btn_overlay", "id", activity.getPackageName());
            int permCamera = activity.getResources().getIdentifier("btn_camera", "id", activity.getPackageName());
            View ov = permOverlay == 0 ? null : activity.findViewById(permOverlay);
            View cam = permCamera == 0 ? null : activity.findViewById(permCamera);
            if (ov != null) {
                ov.setVisibility(View.GONE);
            }
            if (cam != null) {
                cam.setVisibility(View.GONE);
            }
            if (stateView instanceof TextView) {
                TextView state = (TextView) stateView;
                state.setTextSize(19.0f);
                int panel = activity.getResources().getIdentifier("bg_panel", "drawable", activity.getPackageName());
                if (panel != 0) {
                    state.setBackgroundResource(panel);
                }
                state.setPadding(dp(activity, 14), dp(activity, 12), dp(activity, 14), dp(activity, 12));
            }
            buildStatusPanel(activity, container, stateView);

            // 统一所有按钮高度
            unifyHeights(container, dp(activity, BUTTON_H));
            // 统一所有块的行距（按钮、输入框行）
            unifySpacing(container, dp(activity, 10));
            // 如果后视镜开关是打开的，进入应用时自动恢复
            RearMirror.restoreIfEnabled(activity);
        } catch (Throwable ignored) {
        }
    }

    /** 统一行距：块与块之间 10dp，块内按钮/输入框不再自带上下间距。 */
    private static void buildStatusPanel(Activity activity, LinearLayout container, View oldState) {
        if (oldState != null) {
            oldState.setVisibility(View.GONE);
        }
        LinearLayout panel = new LinearLayout(activity);
        panel.setOrientation(LinearLayout.HORIZONTAL);
        int panelBg = activity.getResources().getIdentifier("bg_panel", "drawable", activity.getPackageName());
        if (panelBg != 0) {
            panel.setBackgroundResource(panelBg);
        }
        int pad = dp(activity, 12);
        panel.setPadding(pad, pad, pad, pad);
        LinearLayout.LayoutParams panelParams = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        panelParams.topMargin = dp(activity, 6);
        panel.setLayoutParams(panelParams);

        sStatusLeft = new TextView(activity);
        sStatusLeft.setTextSize(17.0f);
        sStatusLeft.setTextColor(0xFFE8C46A);
        sStatusLeft.setTypeface(Typeface.DEFAULT_BOLD);
        sStatusLeft.setLineSpacing(0f, 1.3f);
        panel.addView(sStatusLeft, new LinearLayout.LayoutParams(0,
                ViewGroup.LayoutParams.WRAP_CONTENT, 1.0f));

        View divider = new View(activity);
        divider.setBackgroundColor(0x55FFFFFF);
        LinearLayout.LayoutParams dv = new LinearLayout.LayoutParams(dp(activity, 1),
                ViewGroup.LayoutParams.MATCH_PARENT);
        dv.leftMargin = dp(activity, 10);
        dv.rightMargin = dp(activity, 10);
        panel.addView(divider, dv);

        sStatusRight = new TextView(activity);
        sStatusRight.setTextSize(17.0f);
        sStatusRight.setTextColor(0xFFE8C46A);
        sStatusRight.setTypeface(Typeface.DEFAULT_BOLD);
        sStatusRight.setLineSpacing(0f, 1.3f);
        panel.addView(sStatusRight, new LinearLayout.LayoutParams(0,
                ViewGroup.LayoutParams.WRAP_CONTENT, 1.0f));

        TextView header = new TextView(activity);
        header.setText("\u8fd0\u884c\u72b6\u6001");
        header.setTextSize(18.0f);
        header.setTextColor(0xFFE8C46A);
        header.setPadding(dp(activity, 4), dp(activity, 8), 0, 0);
        int index = Math.min(1, container.getChildCount());
        container.addView(header, index);
        container.addView(panel, index + 1);
        refreshStatus(activity);
    }

    public static void refreshStatus(Context context) {
        if (sStatusLeft == null || sStatusRight == null || context == null) {
            return;
        }
        boolean polling = isAdbPolling(context);
        boolean overlayOk = false;
        try {
            overlayOk = android.provider.Settings.canDrawOverlays(context);
        } catch (Throwable ignored) {
        }
        boolean cameraOk = context.checkCallingOrSelfPermission(
                android.Manifest.permission.CAMERA) == android.content.pm.PackageManager.PERMISSION_GRANTED;
        sStatusLeft.setText((overlayOk ? "\u60ac\u6d6e\u7a97\u6743\u9650\uff1a\u5df2\u6388\u4e88" : "\u60ac\u6d6e\u7a97\u6743\u9650\uff1a\u672a\u6388\u4e88")
                + "\n" + (cameraOk ? "\u76f8\u673a\u6743\u9650\uff1a\u5df2\u6388\u4e88" : "\u76f8\u673a\u6743\u9650\uff1a\u672a\u6388\u4e88"));
        String auth = !polling ? "ADB \u6388\u6743\uff1a\u672a\u542f\u7528"
                : (SignalGate.isPollOk() ? "ADB \u6388\u6743\uff1a\u5df2\u8fde\u63a5"
                                         : "ADB \u6388\u6743\uff1a\u672a\u8fde\u63a5");
        sStatusRight.setText(auth + "\n" + (polling ? "\u8f6f\u4ef6\u72b6\u6001\uff1a\u8fd0\u884c\u4e2d"
                                                        : "\u8f6f\u4ef6\u72b6\u6001\uff1a\u672a\u8fd0\u884c"));
    }

    private static void moveToTop(Activity activity, View target, String headerText) {
        android.view.ViewParent parent = target == null ? null : target.getParent();
        if (!(parent instanceof LinearLayout)) {
            return;
        }
        LinearLayout container = (LinearLayout) parent;
        container.removeView(target);
        TextView header = new TextView(activity);
        header.setText(headerText);
        header.setTextSize(18.0f);
        header.setTextColor(0xFFE8C46A);
        header.setPadding(dp(activity, 4), dp(activity, 8), 0, 0);
        int index = Math.min(1, container.getChildCount());
        container.addView(header, index);
        container.addView(target, index + 1);
    }

    private static void insertHeader(Activity activity, View anchorView, String text) {
        if (anchorView == null) {
            return;
        }
        android.view.ViewParent parent = anchorView.getParent();
        if (!(parent instanceof LinearLayout)) {
            return;
        }
        LinearLayout container = (LinearLayout) parent;
        int index = container.indexOfChild(anchorView);
        if (index < 0) {
            return;
        }
        TextView header = new TextView(activity);
        header.setText(text);
        header.setTextSize(18.0f);
        header.setTextColor(0xFFE8C46A);
        header.setPadding(dp(activity, 4), dp(activity, 12), 0, 0);
        container.addView(header, index);
    }

    private static void unifySpacing(LinearLayout parent, int spacing) {
        for (int i = 0; i < parent.getChildCount(); i++) {
            View child = parent.getChildAt(i);
            ViewGroup.LayoutParams lp = child.getLayoutParams();
            if (lp instanceof LinearLayout.LayoutParams) {
                LinearLayout.LayoutParams llp = (LinearLayout.LayoutParams) lp;
                llp.topMargin = i == 0 ? 0 : spacing;
                llp.bottomMargin = 0;
                child.setLayoutParams(llp);
            }
            if (child instanceof LinearLayout) {
                LinearLayout row = (LinearLayout) child;
                for (int j = 0; j < row.getChildCount(); j++) {
                    View c = row.getChildAt(j);
                    ViewGroup.LayoutParams clp = c.getLayoutParams();
                    if (clp instanceof LinearLayout.LayoutParams) {
                        LinearLayout.LayoutParams cl = (LinearLayout.LayoutParams) clp;
                        cl.topMargin = 0;
                        cl.bottomMargin = 0;
                        c.setLayoutParams(cl);
                    }
                }
            }
        }
    }

    private static void unifyHeights(View view, int height) {
        if (view instanceof Button) {
            ViewGroup.LayoutParams params = view.getLayoutParams();
            if (params != null) {
                params.height = height;
                view.setLayoutParams(params);
            }
        }
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) {
                unifyHeights(group.getChildAt(i), height);
            }
        }
    }

    /** 后视镜开关变化时（例如点浮窗上的 ✕），立即同步设置页按钮显示。 */
    /** 后侧方画面（侧视放大并偏向车尾方向）。 */
    public static boolean isRearSideView(Context context) {
        return context != null
                && context.getSharedPreferences(PREFS, 0).getBoolean("rear_side_view", false);
    }

    /** 侧视画面旋转 90°（左逆时针、右顺时针）。 */
    /** ADB 轮询总开关：关闭时不执行任何 dumpsys 轮询。 */
    public static boolean isAdbPolling(Context context) {
        return context != null
                && context.getSharedPreferences(PREFS, 0).getBoolean("adb_polling", false);
    }

    public static void setAdbPolling(Context context, boolean enabled) {
        if (context == null) {
            return;
        }
        context.getSharedPreferences(PREFS, 0).edit().putBoolean("adb_polling", enabled).apply();
    }

    /** 轮询关闭时，打灯联动/流媒体后视镜按钮置灰不可点。 */
    /** 运行状态 + ADB 授权状态合并显示。 */
    /** 侧视浮窗是否允许显示：D 档或调试模式。 */
    public static boolean canShowSide(Context context) {
        return isDebugMode(context) || SignalGate.isDriveNow();
    }

    public static String buildStateText(Context context) {
        boolean polling = isAdbPolling(context);
        boolean overlayOk = false;
        try {
            overlayOk = android.provider.Settings.canDrawOverlays(context);
        } catch (Throwable ignored) {
        }
        boolean cameraOk = context.checkCallingOrSelfPermission(
                android.Manifest.permission.CAMERA) == android.content.pm.PackageManager.PERMISSION_GRANTED;
        String auth;
        if (!polling) {
            auth = "ADB \u6388\u6743\uff1a\u672a\u542f\u7528";
        } else if (SignalGate.isPollOk()) {
            auth = "ADB \u6388\u6743\uff1a\u5df2\u8fde\u63a5";
        } else {
            auth = "ADB \u6388\u6743\uff1a\u7b49\u5f85\u6388\u6743/\u672a\u8fde\u63a5";
        }
        String line1 = (overlayOk ? "\u60ac\u6d6e\u7a97\u6743\u9650\uff1a\u5df2\u6388\u4e88" : "\u60ac\u6d6e\u7a97\u6743\u9650\uff1a\u672a\u6388\u4e88")
                + "\u3000\u3000" + (cameraOk ? "\u76f8\u673a\u6743\u9650\uff1a\u5df2\u6388\u4e88" : "\u76f8\u673a\u6743\u9650\uff1a\u672a\u6388\u4e88");
        String line2 = auth + "\u3000\u3000" + (polling ? "\u8f6f\u4ef6\u72b6\u6001\uff1a\u8fd0\u884c\u4e2d"
                                                        : "\u8f6f\u4ef6\u72b6\u6001\uff1a\u672a\u8fd0\u884c");
        return line1 + "\n" + line2;
    }

    private static void applyPollingGate(Activity activity) {
        boolean on = isAdbPolling(activity);
        int linkId = activity.getResources().getIdentifier("sw_enable", "id", activity.getPackageName());
        View link = linkId == 0 ? null : activity.findViewById(linkId);
        if (link != null) {
            link.setEnabled(on);
            link.setAlpha(on ? 1.0f : 0.45f);
        }
        if (sMirrorButton != null) {
            sMirrorButton.setEnabled(on);
            sMirrorButton.setAlpha(on ? 1.0f : 0.45f);
        }
    }

    /** 调试模式：P 档也显示后视镜/侧视浮窗。 */
    public static boolean isDebugMode(Context context) {
        return context != null
                && context.getSharedPreferences(PREFS, 0).getBoolean("debug_mode", false);
    }

    public static void setDebugMode(Context context, boolean enabled) {
        if (context != null) {
            context.getSharedPreferences(PREFS, 0).edit().putBoolean("debug_mode", enabled).apply();
        }
    }

    public static boolean isBsdSide(Context context) {
        return context == null
                || context.getSharedPreferences(PREFS, 0).getBoolean("bsd_side", true);
    }

    public static void setBsdSide(Context context, boolean enabled) {
        if (context != null) {
            context.getSharedPreferences(PREFS, 0).edit().putBoolean("bsd_side", enabled).apply();
        }
    }

    public static boolean isBsdMirror(Context context) {
        return context == null
                || context.getSharedPreferences(PREFS, 0).getBoolean("bsd_mirror", true);
    }

    public static void setBsdMirror(Context context, boolean enabled) {
        if (context != null) {
            context.getSharedPreferences(PREFS, 0).edit().putBoolean("bsd_mirror", enabled).apply();
        }
    }

    public static boolean isFlipLeft(Context context) {
        return context != null
                && context.getSharedPreferences(PREFS, 0).getBoolean("flip_left", false);
    }

    public static void setFlipLeft(Context context, boolean enabled) {
        if (context != null) {
            context.getSharedPreferences(PREFS, 0).edit().putBoolean("flip_left", enabled).apply();
        }
    }

    public static boolean isFlipRight(Context context) {
        return context != null
                && context.getSharedPreferences(PREFS, 0).getBoolean("flip_right", false);
    }

    public static void setFlipRight(Context context, boolean enabled) {
        if (context != null) {
            context.getSharedPreferences(PREFS, 0).edit().putBoolean("flip_right", enabled).apply();
        }
    }

    /** 侧视画面水平翻转（旋转 90° 时不起作用）。 */
    public static void applyFlip(Context context, Matrix matrix, int width, int height, boolean left) {
        if (matrix == null || width <= 0 || height <= 0 || isRotate90(context)) {
            return;
        }
        boolean flip = left ? isFlipLeft(context) : isFlipRight(context);
        if (flip) {
            matrix.postScale(-1f, 1f, width / 2f, height / 2f);
        }
    }

    public static boolean isRotate90(Context context) {
        return context != null
                && context.getSharedPreferences(PREFS, 0).getBoolean("rotate90", false);
    }

    public static void setRotate90(Context context, boolean enabled) {
        if (context == null) {
            return;
        }
        SharedPreferences prefs = context.getSharedPreferences(PREFS, 0);
        prefs.edit().putBoolean("rotate90", enabled).apply();
        applyOverlayOrientation(prefs, "left", enabled);
        applyOverlayOrientation(prefs, "right", enabled);
        try {
            Class<?> serviceClass = Class.forName("com.xiaopeng.qa.camera.CameraOverlayService");
            Intent intent = new Intent(context, serviceClass);
            intent.setAction("com.xiaopeng.qa.camera.REFRESH");
            context.startService(intent);
        } catch (Throwable ignored) {
        }
    }

    /** 旋转时把 TextureView 本身旋转 90°（宽高互换、居中），画面变换仍按横向画布计算。 */
    public static void applyViewRotation(TextureView view, int windowW, int windowH, boolean left) {
        if (view == null) {
            return;
        }
        ViewGroup.LayoutParams raw = view.getLayoutParams();
        if (!(raw instanceof FrameLayout.LayoutParams)) {
            return;
        }
        FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) raw;
        if (windowW <= 0 || windowH <= 0) {
            view.setRotation(0f);
            if (lp.width != ViewGroup.LayoutParams.MATCH_PARENT
                    || lp.height != ViewGroup.LayoutParams.MATCH_PARENT) {
                lp.width = ViewGroup.LayoutParams.MATCH_PARENT;
                lp.height = ViewGroup.LayoutParams.MATCH_PARENT;
                lp.gravity = Gravity.TOP | Gravity.LEFT;
                view.setLayoutParams(lp);
            }
            return;
        }
        if (lp.width != windowH || lp.height != windowW || lp.gravity != Gravity.CENTER) {
            lp.width = windowH;
            lp.height = windowW;
            lp.gravity = Gravity.CENTER;
            view.setLayoutParams(lp);
        }
        view.setRotation(left ? -90f : 90f);
    }

    /** 在已有变换基础上叠加：绕窗口中心旋转 90° 并放大到覆盖整个窗口。 */
    public static void applyRotation(Context context, Matrix matrix,
                                     int canvasW, int canvasH, boolean left) {
        if (matrix == null || canvasW <= 0 || canvasH <= 0 || !isRotate90(context)) {
            return;
        }
        float cx = canvasW / 2.0f;
        float cy = canvasH / 2.0f;
        matrix.postRotate(left ? -90.0f : 90.0f, cx, cy);
        // 窗口是画布旋转 90° 后的竖屏尺寸（宽高互换），把旋转后的画布中心对齐到窗口中心
        matrix.postTranslate(canvasH / 2.0f - cx, canvasW / 2.0f - cy);
    }

    public static void setRearSideView(Context context, boolean enabled) {
        if (context == null) {
            return;
        }
        context.getSharedPreferences(PREFS, 0).edit().putBoolean("rear_side_view", enabled).apply();
    }

    public static void refreshMirrorButton() {
        try {
            Button button = sMirrorButton;
            if (button == null) {
                return;
            }
            updateMirrorButton(button.getContext(), button);
        } catch (Throwable ignored) {
        }
    }

    private static void updateRotateButton(Context context, Button button) {
        if (button == null) {
            return;
        }
        boolean on = isRotate90(context);
        button.setText(on ? "\u753b\u9762\u65cb\u8f6c90\u00b0\uff1a\u5f00" : "\u753b\u9762\u65cb\u8f6c90\u00b0\uff1a\u5173");
        int active = context.getResources().getIdentifier(
                "bg_button_active", "drawable", context.getPackageName());
        int normal = context.getResources().getIdentifier(
                "bg_button", "drawable", context.getPackageName());
        if (on && active != 0) {
            button.setBackgroundResource(active);
        } else if (normal != 0) {
            button.setBackgroundResource(normal);
        }
        button.setTextColor(on ? 0xFFFFD98A : Color.WHITE);
    }

    private static void updateDebugButton(Context context, Button button) {
        if (button == null) {
            return;
        }
        boolean on = isDebugMode(context);
        button.setText(on ? "\u8c03\u8bd5\u6a21\u5f0f\uff1a\u5f00" : "\u8c03\u8bd5\u6a21\u5f0f\uff1a\u5173");
        int active = context.getResources().getIdentifier(
                "bg_button_active", "drawable", context.getPackageName());
        int normal = context.getResources().getIdentifier(
                "bg_button", "drawable", context.getPackageName());
        if (on && active != 0) {
            button.setBackgroundResource(active);
        } else if (normal != 0) {
            button.setBackgroundResource(normal);
        }
        button.setTextColor(on ? 0xFFFFD98A : Color.WHITE);
    }



    private static void updateBsdButton(Context context, Button button, boolean mirror) {
        if (button == null) {
            return;
        }
        boolean on = mirror ? isBsdMirror(context) : isBsdSide(context);
        button.setText(on ? "\u76f2\u533a\u63d0\u9192\uff1a\u5f00" : "\u76f2\u533a\u63d0\u9192\uff1a\u5173");
        int active = context.getResources().getIdentifier(
                "bg_button_active", "drawable", context.getPackageName());
        int normal = context.getResources().getIdentifier(
                "bg_button", "drawable", context.getPackageName());
        if (on && active != 0) {
            button.setBackgroundResource(active);
        } else if (normal != 0) {
            button.setBackgroundResource(normal);
        }
        button.setTextColor(on ? 0xFFFFD98A : Color.WHITE);
    }

    private static void updateFlipButton(Context context, Button button, boolean left) {
        if (button == null) {
            return;
        }
        boolean on = left ? isFlipLeft(context) : isFlipRight(context);
        button.setText((left ? "\u5de6\u89c6\u56fe\u6c34\u5e73\u7ffb\u8f6c\uff1a" : "\u53f3\u89c6\u56fe\u6c34\u5e73\u7ffb\u8f6c\uff1a")
                + (on ? "\u5f00" : "\u5173"));
        int active = context.getResources().getIdentifier(
                "bg_button_active", "drawable", context.getPackageName());
        int normal = context.getResources().getIdentifier(
                "bg_button", "drawable", context.getPackageName());
        if (on && active != 0) {
            button.setBackgroundResource(active);
        } else if (normal != 0) {
            button.setBackgroundResource(normal);
        }
        button.setTextColor(on ? 0xFFFFD98A : Color.WHITE);
    }

    private static void updateAdbButton(Context context, Button button) {
        if (button == null) {
            return;
        }
        boolean on = isAdbPolling(context);
        button.setText(on ? "ADB \u8f6e\u8be2\uff1a\u5f00" : "ADB \u8f6e\u8be2\uff1a\u5173");
        int active = context.getResources().getIdentifier(
                "bg_button_active", "drawable", context.getPackageName());
        int normal = context.getResources().getIdentifier(
                "bg_button", "drawable", context.getPackageName());
        if (on && active != 0) {
            button.setBackgroundResource(active);
        } else if (normal != 0) {
            button.setBackgroundResource(normal);
        }
        button.setTextColor(on ? 0xFFFFD98A : Color.WHITE);
    }

    private static void swapOverlaySize(SharedPreferences prefs, String side) {
        String wk = side + "_overlay_w";
        String hk = side + "_overlay_h";
        int w = prefs.getInt(wk, 960);
        int h = prefs.getInt(hk, 540);
        if (w <= 0 || h <= 0) {
            return;
        }
        prefs.edit().putInt(wk, h).putInt(hk, w).apply();
    }

    private static void applyOverlayOrientation(SharedPreferences prefs, String side, boolean portrait) {
        String wk = side + "_overlay_w";
        String hk = side + "_overlay_h";
        int w = prefs.getInt(wk, 960);
        int h = prefs.getInt(hk, 540);
        if (w <= 0 || h <= 0) {
            return;
        }
        int landscapeW = Math.max(w, h);
        int landscapeH = Math.min(w, h);
        if (portrait) {
            prefs.edit().putInt(wk, landscapeH).putInt(hk, landscapeW).apply();
        } else {
            prefs.edit().putInt(wk, landscapeW).putInt(hk, landscapeH).apply();
        }
    }

    private static void stopLink(Context context) {
        try {
            Class<?> serviceClass = Class.forName("com.xiaopeng.qa.camera.CameraOverlayService");
            Intent intent = new Intent(context, serviceClass);
            context.stopService(intent);
        } catch (Throwable ignored) {
        }
    }

    private static void updateRearSideButton(Context context, Button button) {
        if (button == null) {
            return;
        }
        boolean on = isRearSideView(context);
        button.setText(on ? "\u540e\u4fa7\u65b9\u753b\u9762\uff1a\u5f00" : "\u540e\u4fa7\u65b9\u753b\u9762\uff1a\u5173");
        int active = context.getResources().getIdentifier(
                "bg_button_active", "drawable", context.getPackageName());
        int normal = context.getResources().getIdentifier(
                "bg_button", "drawable", context.getPackageName());
        if (on && active != 0) {
            button.setBackgroundResource(active);
        } else if (normal != 0) {
            button.setBackgroundResource(normal);
        }
        button.setTextColor(on ? 0xFFFFD98A : Color.WHITE);
    }

    private static void updateLockButton(Context context, Button button) {
        if (button == null) {
            return;
        }
        boolean locked = RearMirror.isLocked(context);
        button.setText(locked ? "锁定后视镜位置/大小：开" : "锁定后视镜位置/大小：关");
        int active = context.getResources().getIdentifier(
                "bg_button_active", "drawable", context.getPackageName());
        int normal = context.getResources().getIdentifier(
                "bg_button", "drawable", context.getPackageName());
        if (locked && active != 0) {
            button.setBackgroundResource(active);
        } else if (normal != 0) {
            button.setBackgroundResource(normal);
        }
        button.setTextColor(locked ? 0xFFFFD98A : Color.WHITE);
    }

    /** 外部（例如浮窗关闭）后同步开关按钮状态。 */
    private static void updateMirrorButton(Context context, Button button) {
        if (button == null) {
            return;
        }
        boolean on = RearMirror.isEnabled(context);
        button.setText(on ? "流媒体后视镜：开" : "流媒体后视镜：关");
        int active = context.getResources().getIdentifier(
                "bg_button_active", "drawable", context.getPackageName());
        int normal = context.getResources().getIdentifier(
                "bg_button", "drawable", context.getPackageName());
        if (on && active != 0) {
            button.setBackgroundResource(active);
        } else if (normal != 0) {
            button.setBackgroundResource(normal);
        }
        // 开启时与「打灯联动」一致：金色底 + 金色文字
        button.setTextColor(on ? 0xFFFFD98A : Color.WHITE);
    }

    private static void log(String message) {
        try {
            Class<?> cls = Class.forName("com.xiaopeng.qa.camera.CameraOverlayService");
            cls.getMethod("serviceLog", String.class).invoke(null, message);
        } catch (Throwable ignored) {
        }
    }

    private static View.OnClickListener presetListener(final int preset) {
        return new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    applyPreset(view.getContext(), preset);
                } catch (Throwable t) {
                    Toast.makeText(view.getContext(), "设置失败: " + t, Toast.LENGTH_SHORT).show();
                }
            }
        };
    }

    private static LinearLayout newRow(Context context) {
        LinearLayout row = new LinearLayout(context);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setLayoutParams(new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        return row;
    }

    private static Button makeButton(Context context, String text, int bg, View.OnClickListener listener) {
        Button button = new Button(context);
        button.setText(text);
        button.setTextSize(22.0f);
        button.setTextColor(Color.WHITE);
        if (bg != 0) {
            button.setBackgroundResource(bg);
        }
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                0, dp(context, 56), 1.0f);
        params.setMargins(dp(context, 3), dp(context, 5), dp(context, 3), dp(context, 5));
        button.setLayoutParams(params);
        button.setOnClickListener(listener);
        return button;
    }

    /** 保留还原功能，并把左右两侧位置都重置到左上角。 */
    public static void reset(Context context) {
        try {
            SharedPreferences.Editor edit = context.getSharedPreferences(PREFS, 0).edit();
            String[] keys = {
                    "left_overlay_w", "left_overlay_h", "left_cam_scale", "left_overlay_scale",
                    "left_crop_l", "left_crop_t", "left_crop_r", "left_crop_b",
                    "left_pan_x", "left_pan_y", "left_avm_mode",
                    "right_overlay_w", "right_overlay_h", "right_cam_scale", "right_overlay_scale",
                    "right_crop_l", "right_crop_t", "right_crop_r", "right_crop_b",
                    "right_pan_x", "right_pan_y", "right_avm_mode"
            };
            for (String key : keys) {
                edit.remove(key);
            }
            writePositions(edit, context, PRESET_TOP_LEFT);
            edit.apply();
            RearMirror.resetGeometry(context);
            Toast.makeText(context, "已还原浮窗设置（左右均回到左上角）", Toast.LENGTH_SHORT).show();
            triggerReapply(context);
        } catch (Throwable t) {
            Toast.makeText(context, "还原失败: " + t, Toast.LENGTH_SHORT).show();
        }
    }

    public static void applyPreset(Context context, int preset) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS, 0);
        SharedPreferences.Editor edit = prefs.edit();
        writePositions(edit, context, preset);
        edit.apply();
        String label = preset >= 0 && preset < LABELS.length ? LABELS[preset] : "浮窗位置";
        Toast.makeText(context, "已设置：" + label, Toast.LENGTH_SHORT).show();
        triggerReapply(context);
    }

    private static void writePositions(SharedPreferences.Editor edit, Context context, int preset) {
        DisplayMetrics metrics = new DisplayMetrics();
        android.view.WindowManager wm =
                (android.view.WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
        wm.getDefaultDisplay().getRealMetrics(metrics);
        int screenW = metrics.widthPixels;
        int screenH = metrics.heightPixels;

        int[] left = sizeFor(context, "left_", screenW);
        int[] right = sizeFor(context, "right_", screenW);
        int[] posLeft;
        int[] posRight;
        switch (preset) {
            case PRESET_BOTTOM_LEFT:
                posLeft = new int[]{MARGIN_X, screenH - left[1] - MARGIN_Y};
                posRight = new int[]{MARGIN_X, screenH - right[1] - MARGIN_Y};
                break;
            case PRESET_TOP_RIGHT:
                posLeft = new int[]{screenW - left[0] - MARGIN_X, MARGIN_Y};
                posRight = new int[]{screenW - right[0] - MARGIN_X, MARGIN_Y};
                break;
            case PRESET_BOTTOM_RIGHT:
                posLeft = new int[]{screenW - left[0] - MARGIN_X, screenH - left[1] - MARGIN_Y};
                posRight = new int[]{screenW - right[0] - MARGIN_X, screenH - right[1] - MARGIN_Y};
                break;
            case PRESET_SIDES:
                posLeft = new int[]{MARGIN_X, MARGIN_Y};
                posRight = new int[]{screenW - right[0] - MARGIN_X, MARGIN_Y};
                break;
            case PRESET_TOP_LEFT:
            default:
                posLeft = new int[]{MARGIN_X, MARGIN_Y};
                posRight = new int[]{MARGIN_X, MARGIN_Y};
                break;
        }
        edit.putInt("left_overlay_pos_x", posLeft[0]);
        edit.putInt("left_overlay_pos_y", posLeft[1]);
        edit.putBoolean("left_overlay_pos_recorded", true);
        edit.putInt("right_overlay_pos_x", posRight[0]);
        edit.putInt("right_overlay_pos_y", posRight[1]);
        edit.putBoolean("right_overlay_pos_recorded", true);
    }

    private static int[] sizeFor(Context context, String prefix, int screenW) {
        SharedPreferences prefs = context.getSharedPreferences(PREFS, 0);
        int defaultW = (int) (screenW * 0.4f);
        int defaultH = (int) ((defaultW * 9.0f) / 16.0f);
        int w = prefs.getInt(prefix + "overlay_w", defaultW);
        int h = prefs.getInt(prefix + "overlay_h", defaultH);
        if (w <= 0) {
            w = defaultW;
        }
        if (h <= 0) {
            h = defaultH;
        }
        return new int[]{w, h};
    }

    private static void triggerReapply(Context context) {
        try {
            Class<?> service = Class.forName("com.xiaopeng.qa.camera.CameraOverlayService");
            Object active = service.getMethod("isLinkActive").invoke(null);
            if (!Boolean.TRUE.equals(active)) {
                return;
            }
            service.getMethod("alignRightToLeft", Context.class).invoke(null, context);
        } catch (Throwable ignored) {
        }
    }

    private static LinearLayout findContainer(View view) {
        if (view instanceof LinearLayout) {
            return (LinearLayout) view;
        }
        if (view instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) view;
            for (int i = 0; i < group.getChildCount(); i++) {
                LinearLayout found = findContainer(group.getChildAt(i));
                if (found != null) {
                    return found;
                }
            }
        }
        return null;
    }

    private static int dp(Context context, int value) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, value,
                context.getResources().getDisplayMetrics());
    }
}
