package com.xiaopeng.qa.camera;

import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.TextView;

import java.lang.reflect.Field;

/** 侧视浮窗的盲区警示条（BSD 有车时在浮窗底部显示红色提示）。 */
public final class SideWarning {

    private static Field sOverlayField;
    private static Field sDirectionField;
    private static View sRoot;
    private static TextView sBar;

    private SideWarning() {
    }

    public static void update(Object service) {
        if (service == null) {
            return;
        }
        try {
            if (sOverlayField == null) {
                sOverlayField = service.getClass().getDeclaredField("overlayView");
                sOverlayField.setAccessible(true);
                sDirectionField = service.getClass().getDeclaredField("direction");
                sDirectionField.setAccessible(true);
            }
            View root = (View) sOverlayField.get(service);
            if (root == null) {
                sRoot = null;
                sBar = null;
                return;
            }
            if (root != sRoot) {
                build((Context) service, root);
            }
            if (sBar == null) {
                return;
            }
            String direction = (String) sDirectionField.get(service);
            boolean enabled = OverlayPresets.isBsdSide((Context) service);
            boolean warn = enabled && ("LEFT".equals(direction) ? SignalGate.isBsdLeft()
                    : "RIGHT".equals(direction) ? SignalGate.isBsdRight() : false);
            if (warn) {
                sBar.setVisibility(View.VISIBLE);
            } else {
                sBar.setVisibility(View.GONE);
            }
        } catch (Throwable ignored) {
        }
    }


    private static void build(Context context, View root) {
        try {
            sRoot = root;
            TextView bar = new TextView(context);
            bar.setText("\u26a0 \u6ce8\u610f\u76f2\u533a");
            bar.setTextSize(21.0f);
            bar.setTypeface(Typeface.DEFAULT_BOLD);
            bar.setTextColor(Color.WHITE);
            bar.setGravity(Gravity.CENTER);
            GradientDrawable bg = new GradientDrawable();
            bg.setShape(GradientDrawable.RECTANGLE);
            bg.setColor(0xE6D32F2F);
            bg.setCornerRadius(context.getResources().getDisplayMetrics().density * 8.0f);
            bar.setBackground(bg);
            int padH = (int) (context.getResources().getDisplayMetrics().density * 12.0f);
            int padV = (int) (context.getResources().getDisplayMetrics().density * 4.0f);
            bar.setPadding(padH, padV, padH, padV);
            bar.setVisibility(View.GONE);
            if (root instanceof FrameLayout) {
                FrameLayout.LayoutParams lp = new FrameLayout.LayoutParams(
                        ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
                lp.gravity = Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
                lp.bottomMargin = (int) (context.getResources().getDisplayMetrics().density * 10.0f);
                ((FrameLayout) root).addView(bar, lp);
            } else {
                ((ViewGroup) root).addView(bar);
                bar.setTranslationY(-(context.getResources().getDisplayMetrics().density * 60.0f));
            }
            android.animation.ObjectAnimator anim =
                    android.animation.ObjectAnimator.ofFloat(bar, "alpha", 1.0f, 0.18f);
            anim.setDuration(380L);
            anim.setRepeatMode(android.animation.ValueAnimator.REVERSE);
            anim.setRepeatCount(android.animation.ValueAnimator.INFINITE);
            anim.start();
            sBar = bar;
        } catch (Throwable ignored) {
            sBar = null;
            sRoot = null;
        }
    }
}
