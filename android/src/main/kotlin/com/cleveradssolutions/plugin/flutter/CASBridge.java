package com.cleveradssolutions.plugin.flutter;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.cleveradssolutions.mediation.ContextService;
import com.cleveradssolutions.plugin.flutter.bridge.MediationManagerMethodHandler;
import com.cleveradssolutions.sdk.base.CASHandler;
import com.cleversolutions.ads.AdError;
import com.cleversolutions.ads.AdLoadCallback;
import com.cleversolutions.ads.AdType;
import com.cleversolutions.ads.MediationManager;

public final class CASBridge implements AdLoadCallback {
    private static final int AD_TYPE_BANNER = 0;
    private static final int AD_TYPE_INTER = 1;
    private static final int AD_TYPE_REWARD = 2;
    private static final int AD_TYPE_NATIVE = 3;

    private final MediationManager manager;
    private final AdCallbackWrapper interstitialAdListener;
    private final AdCallbackWrapper rewardedListener;

    public CASBridge(
            MediationManager manager,
            MediationManagerMethodHandler mediationManagerMethodHandler
    ) {
        this.interstitialAdListener = mediationManagerMethodHandler.getInterstitialCallbackWrapper();
        this.rewardedListener = mediationManagerMethodHandler.getRewardedCallbackWrapper();
        this.manager = manager;
        manager.getOnAdLoadEvent().add(this);
    }

    public MediationManager getMediationManager() {
        return manager;
    }

    public boolean isTestAdModeEnabled() {
        return manager.isDemoAdMode();
    }

    public CASViewWrapper createAdView(final CASCallback listener, final int sizeCode, @NonNull ContextService contextService) {
        final CASViewWrapper view = new CASViewWrapper(contextService);
        CASHandler.INSTANCE.main(() -> {
            view.createView(manager, listener, sizeCode);
        });
        return view;
    }

    public void enableReturnAds(AdCallbackWrapper returnAdListener) {
        manager.enableAppReturnAds(returnAdListener);
    }

    public void disableReturnAds() {
        manager.disableAppReturnAds();
    }

    public void skipNextReturnAds() {
        manager.skipNextAppReturnAds();
    }

    public void loadInterstitial() {
        manager.loadInterstitial();
    }

    public void loadRewarded() {
        manager.loadRewardedAd();
    }

    public void showInterstitial(@NonNull Activity activity) {
        manager.showInterstitial(activity, interstitialAdListener);
    }

    public void showRewarded(@NonNull Activity activity) {
        manager.showRewardedAd(activity, rewardedListener);
    }

    public boolean isInterstitialAdReady() {
        return manager.isInterstitialReady();
    }

    public boolean isRewardedAdReady() {
        return manager.isRewardedAdReady();
    }

    public boolean isEnabled(final int type) {
        AdType var10000 = getAdType(type, "isEnabled");
        return var10000 != null && manager.isEnabled(var10000);
    }

    public void enableAd(final int type, final boolean enable) {
        AdType var10000 = getAdType(type, "enableAd");
        if (var10000 != null) {
            manager.setEnabled(var10000, enable);
        }
    }

    @Override
    public void onAdLoaded(@NonNull AdType type) {
        new Handler(Looper.getMainLooper()).post(() -> {
            if (type == AdType.Interstitial)
                interstitialAdListener.onAdLoaded();
            else if (type == AdType.Rewarded)
                rewardedListener.onAdLoaded();
        });
    }

    @Override
    public void onAdFailedToLoad(@NonNull AdType type, @Nullable String error) {
        if (error == null) return;
        new Handler(Looper.getMainLooper()).post(() -> {
            if (type == AdType.Interstitial)
                interstitialAdListener.onAdFailed(new AdError(error).getCode());
            else if (type == AdType.Rewarded)
                rewardedListener.onAdFailed(new AdError(error).getCode());
        });
    }

    private AdType getAdType(final int index, String method) {
        switch (index) {
            case AD_TYPE_BANNER:
                return AdType.Banner;
            case AD_TYPE_INTER:
                return AdType.Interstitial;
            case AD_TYPE_REWARD:
                return AdType.Rewarded;
            case AD_TYPE_NATIVE:
                return AdType.Native;
            default:
                Log.e("CAS.dart", "Unity bridge " + method + " skipped. Not found AdType by index " + index + '.');
                return null;
        }
    }

}
