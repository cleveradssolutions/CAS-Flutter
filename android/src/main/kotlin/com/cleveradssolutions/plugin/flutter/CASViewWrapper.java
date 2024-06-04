package com.cleveradssolutions.plugin.flutter;

import android.app.Activity;
import android.graphics.Color;
import android.os.Build;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.DisplayCutout;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.view.WindowInsets;
import android.view.WindowManager;
import android.widget.FrameLayout;

import androidx.annotation.MainThread;
import androidx.annotation.NonNull;
import androidx.annotation.WorkerThread;

import com.cleversolutions.ads.AdError;
import com.cleversolutions.ads.AdSize;
import com.cleversolutions.ads.AdStatusHandler;
import com.cleversolutions.ads.AdViewListener;
import com.cleversolutions.ads.MediationManager;
import com.cleversolutions.ads.android.CASBannerView;
import com.cleveradssolutions.sdk.base.CASHandler;

public final class CASViewWrapper implements AdViewListener {
    private static final int AD_POSITION_TOP_CENTER = 0;
    private static final int AD_POSITION_TOP_LEFT = 1;
    private static final int AD_POSITION_TOP_RIGHT = 2;
    private static final int AD_POSITION_BOTTOM_CENTER = 3;
    private static final int AD_POSITION_BOTTOM_LEFT = 4;
    private static final int AD_POSITION_BOTTOM_RIGHT = 5;

    private static final int AD_SIZE_BANNER = 1;
    private static final int AD_SIZE_ADAPTIVE = 2;
    private static final int AD_SIZE_SMART = 3;
    private static final int AD_SIZE_LEADER = 4;
    private static final int AD_SIZE_MREC = 5;
    private static final int AD_SIZE_FULL_WIDTH = 6;
    private static final int AD_SIZE_LINE = 7;

    @NonNull
    private final Activity activity;

    private CASBannerView view;
    private CASCallback unityCallback;
    private int activeSizeId = 0;
    public boolean isNeedSafeInsets = true;

    private volatile int activePos = AD_POSITION_BOTTOM_CENTER;
    /**
     * Offset for the ad in the x-axis when a custom position is used. Value will be 0 for non-custom
     * positions.
     */
    private volatile int horizontalOffset;

    /**
     * Offset for the ad in the y-axis when a custom position is used. Value will be 0 for non-custom
     * positions.
     */
    private volatile int verticalOffset;

    private final Runnable showRunnable = () -> {
        if (view != null) {
            refreshViewPosition(view);
            view.setVisibility(View.VISIBLE);
        } else {
            Log.w("CAS.dart", "Unity bridge call Show banner but Native View is Null");
        }
    };

    private final Runnable hideRunnable = () -> {
        if (view != null) {
            view.setVisibility(View.GONE);
        }
    };

    private final Runnable loadRunnable = () -> {
        if (view != null) {
            view.loadNextAd();
        } else {
            Log.w("CAS.dart", "Unity bridge call load banner but Native View is Null");
        }
    };

    private final Runnable refreshPositionRunnable = () -> {
        if (view != null && view.getVisibility() == View.VISIBLE) {
            refreshViewPosition(view);
        }
    };

    private final Runnable refreshAdSizeAfterOrientationChanged = () -> {
        if (view == null)
            return;
        AdSize newSize = getSizeByCode(activeSizeId);
        Log.d("CAS.dart", "Unity bridge change Ad size to " + newSize + " after orientation changed");
        view.setSize(newSize);
        refreshPositionRunnable.run();
    };

    /**
     * A {@code View.OnLayoutChangeListener} used to detect orientation changes and reposition banner
     * ads as required.
     */
    private final View.OnLayoutChangeListener layoutChangeListener;

    public CASViewWrapper(@NonNull Activity activity) {
        this.activity = activity;

        layoutChangeListener = (v, left, top, right, bottom, oldLeft, oldTop, oldRight, oldBottom) -> {
            boolean viewBoundsChanged = left != oldLeft || right != oldRight || bottom != oldBottom || top != oldTop;
            if (!viewBoundsChanged || view == null) {
                return;
            }
            if (activeSizeId == AD_SIZE_FULL_WIDTH
                    || activeSizeId == AD_SIZE_ADAPTIVE
                    || activeSizeId == AD_SIZE_LINE) {
                CASHandler.INSTANCE.main(200, refreshAdSizeAfterOrientationChanged);
            } else {
                refreshPositionRunnable.run();
            }
        };
    }

    @MainThread
    public void createView(MediationManager manager, CASCallback unityListener, int sizeCode) {
        if (sizeCode == 0)
            return;

        activeSizeId = sizeCode;
        unityCallback = unityListener;
        view = new CASBannerView(activity, manager);
        view.setVisibility(View.GONE);
        view.setAdListener(this);
        // Setting the background color works around an issue where the first ad isn't visible.
        view.setBackgroundColor(Color.TRANSPARENT);
        view.setSize(getSizeByCode(sizeCode));
        Log.d("CAS.dart", "Unity bridge create Ad View with size " + view.getSize());

        activity.getWindow()
                .getDecorView()
                .getRootView()
                .addOnLayoutChangeListener(layoutChangeListener);

        refreshViewPosition(view);
        activity.addContentView(view, view.getLayoutParams());
    }

    public void show() {
        CASHandler.INSTANCE.main(showRunnable);
    }

    public void hide() {
        if (view != null) {
            CASHandler.INSTANCE.main(hideRunnable);
        }
    }

    public boolean isReady() {
        return view != null && view.isAdReady();
    }

    public void setRefreshInterval(int seconds) {
        if (view != null) {
            view.setRefreshInterval(seconds);
        }
    }

    public int getRefreshInterval() {
        if (view != null) {
            return view.getRefreshInterval();
        }
        return 30;
    }

    public void setPosition(final int code, int x, int y) {
        if (code < 0 || code > AD_POSITION_BOTTOM_RIGHT)
            activePos = AD_POSITION_BOTTOM_CENTER;
        else
            activePos = code;

        horizontalOffset = x;
        verticalOffset = y;
        CASHandler.INSTANCE.main(refreshPositionRunnable);
    }

    public void destroy() {
        if (view != null) {
            CASHandler.INSTANCE.main(() -> {
                activity.getWindow()
                        .getDecorView()
                        .getRootView()
                        .removeOnLayoutChangeListener(layoutChangeListener);
                if (view != null) {
                    try {
                        ViewParent parent = view.getParent();
                        if (parent != null)
                            ((ViewGroup) parent).removeView(view);
                    } catch (Throwable ignored) {
                    }
                    view.destroy();
                }
            });
        }
    }

    @WorkerThread
    public void load() {
        CASHandler.INSTANCE.main(loadRunnable);
    }

    @Override
    public void onAdViewLoaded(@NonNull CASBannerView view) {
        unityCallback.onLoaded();
    }

    @Override
    public void onAdViewFailed(@NonNull CASBannerView view, @NonNull AdError error) {
        unityCallback.onFailed(error.getCode());
    }

    @Override
    public void onAdViewPresented(@NonNull CASBannerView view, @NonNull AdStatusHandler info) {
        refreshViewPosition(view);
        unityCallback.onShown();
        unityCallback.onImpression(info);
    }

    @Override
    public void onAdViewClicked(@NonNull CASBannerView view) {
        unityCallback.onClicked();
    }

    @MainThread
    private void refreshViewPosition(@NonNull CASBannerView view) {
        final FrameLayout.LayoutParams adParams = new FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.WRAP_CONTENT,
                FrameLayout.LayoutParams.WRAP_CONTENT);
        final int targetPos = activePos;
        final DisplayMetrics display = activity.getResources().getDisplayMetrics();
        final float screenDensity = display.density;

        final int adWidthPx;
        final int adHeightPx;
        if (view.getMeasuredWidth() == 0) {
            AdSize adSize = view.getSize();
            adWidthPx = (int) (adSize.getWidth() * screenDensity);
            adHeightPx = (int) (adSize.getHeight() * screenDensity);
        } else {
            adWidthPx = (int) (view.getMeasuredWidth() * screenDensity);
            adHeightPx = (int) (view.getMeasuredHeight() * screenDensity);
        }

        final View decorView = activity.getWindow().getDecorView();

        if (isNeedSafeInsets && Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            WindowInsets windowInsets = decorView.getRootWindowInsets();
            DisplayCutout displayCutout = null;
            if (windowInsets != null) {
                displayCutout = windowInsets.getDisplayCutout();
            }
            if (displayCutout != null) {
                adParams.bottomMargin = displayCutout.getSafeInsetBottom();

                if (targetPos != AD_POSITION_TOP_CENTER
                        && targetPos != AD_POSITION_BOTTOM_CENTER) {
                    adParams.leftMargin = displayCutout.getSafeInsetLeft();
                    adParams.rightMargin = displayCutout.getSafeInsetRight();
                }

                if (targetPos == AD_POSITION_TOP_CENTER
                        || targetPos == AD_POSITION_TOP_LEFT
                        || targetPos == AD_POSITION_TOP_RIGHT) {
                    adParams.topMargin = displayCutout.getSafeInsetTop();
                }
            }
        }

        int offsetXPx;
        int offsetYPx;

        final int screenWidth = decorView.getWidth();
        final int screenHeight = decorView.getHeight();
        final int maxXPosition = screenWidth - adParams.rightMargin - adWidthPx;
        final int maxYPosition = screenHeight - adParams.bottomMargin - adHeightPx;
        switch (targetPos) {
            case AD_POSITION_TOP_LEFT:
            case AD_POSITION_TOP_CENTER:
            case AD_POSITION_TOP_RIGHT:
                adParams.gravity = Gravity.TOP;
                int topOffset = (int) (verticalOffset * screenDensity);
                // Clamp Y position in Min and Max
                if (maxYPosition > -1 && maxYPosition < topOffset)
                    topOffset = maxYPosition;
                if (adParams.topMargin < topOffset)
                    adParams.topMargin = topOffset;
                offsetYPx = adParams.topMargin;
                break;
            default:
                adParams.gravity = Gravity.BOTTOM;
                offsetYPx = Math.max(maxYPosition, 0);
                break;
        }

        switch (targetPos) {
            case AD_POSITION_TOP_CENTER:
            case AD_POSITION_BOTTOM_CENTER:
                adParams.gravity |= Gravity.CENTER_HORIZONTAL;
                // Center in safe area
                //rectInPixels[0] = (decorView.getWidth() - adParams.leftMargin - adParams.rightMargin) / 2
                //         + adParams.leftMargin - rectInPixels[2] / 2;
                // Center ignore safe area
                offsetXPx = screenWidth / 2 - adWidthPx / 2;
                break;
            case AD_POSITION_TOP_LEFT:
            case AD_POSITION_BOTTOM_LEFT:
                adParams.gravity |= Gravity.LEFT;
                int leftPos = (int) (horizontalOffset * screenDensity);
                if (maxXPosition > -1 && maxXPosition < leftPos)
                    leftPos = maxXPosition;
                if (adParams.leftMargin < leftPos)
                    adParams.leftMargin = leftPos;
                offsetXPx = adParams.leftMargin;
                break;
            default:
                adParams.gravity |= Gravity.RIGHT;
                offsetXPx = Math.max(maxXPosition, 0);
                break;
        }

        view.setLayoutParams(adParams);
        unityCallback.onRect(offsetXPx, offsetYPx, adWidthPx, adHeightPx);
    }

    private AdSize getSizeByCode(final int sizeId) {
        switch (sizeId) {
            case AD_SIZE_BANNER:
                return AdSize.BANNER;
            case AD_SIZE_ADAPTIVE:
                int width = Math.min(getScreenWidth(), AdSize.LEADERBOARD.getWidth());
                return AdSize.getAdaptiveBanner(activity, width);
            case AD_SIZE_SMART:
                return AdSize.getSmartBanner(activity);
            case AD_SIZE_LEADER:
                return AdSize.LEADERBOARD;
            case AD_SIZE_MREC:
                return AdSize.MEDIUM_RECTANGLE;
            case AD_SIZE_FULL_WIDTH:
                return AdSize.getAdaptiveBanner(activity, getScreenWidth());
            case AD_SIZE_LINE:
                WindowManager windowManager = activity.getWindowManager();
                Display display = windowManager.getDefaultDisplay();
                //Point realSize = new Point();
                //display.getRealSize(realSize); // Get screen with cutout size
                DisplayMetrics metrics = new DisplayMetrics();
                display.getMetrics(metrics); // Get screen without cutout size

                final int screenWidth = (int) ((float) metrics.widthPixels / metrics.density);
                final int screenHeight = (int) ((float) metrics.heightPixels / metrics.density);

//                    // Mobile Landscape:
//                    // 90dp = 23%
//                    // 50dp = 13%
//                    // 32dp = 8%

//                    // Mobile Portrait:
//                    // 90dp = 12%
//                    // 50dp = 6%
//                    // 32dp = 4%
                boolean inLandscape = screenHeight < screenWidth;
                int bannerHeight;
                if (screenHeight > 720 && screenWidth >= 728) {
                    bannerHeight = inLandscape ? 50 : 90;
                } else {
                    bannerHeight = inLandscape ? 32 : 50;
                }
                return AdSize.getInlineBanner(screenWidth, bannerHeight);
            default:
                Log.w("CAS.dart", "Unity bridge call change banner size with unknown id: " + sizeId);
                return AdSize.BANNER;
        }
    }

    private static int getGravityByPos(int pos) {
        switch (pos) {
            case AD_POSITION_TOP_CENTER:
                return Gravity.TOP | Gravity.CENTER_HORIZONTAL;
            case AD_POSITION_TOP_LEFT:
                return Gravity.TOP | Gravity.LEFT;
            case AD_POSITION_TOP_RIGHT:
                return Gravity.TOP | Gravity.RIGHT;
            case AD_POSITION_BOTTOM_CENTER:
                return Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
            case AD_POSITION_BOTTOM_LEFT:
                return Gravity.BOTTOM | Gravity.LEFT;
            case AD_POSITION_BOTTOM_RIGHT:
                return Gravity.BOTTOM | Gravity.RIGHT;
            default:
                return Gravity.CENTER;
        }
    }

    private DisplayMetrics getScreenMetrics() {
        WindowManager windowManager = activity.getWindowManager();
        Display display = windowManager.getDefaultDisplay();
        // Point size = new Point();
        // display.getRealSize(size); // Get screen with cutout size
        DisplayMetrics displayMetrics = new DisplayMetrics();
        display.getMetrics(displayMetrics); // Get screen without cutout size
        return displayMetrics;
    }

    private int getScreenWidth() {
        DisplayMetrics displayMetrics = getScreenMetrics();
        return (int) (displayMetrics.widthPixels / displayMetrics.density);
    }
}