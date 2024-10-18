package com.cleveradssolutions.plugin.flutter;

import android.app.Activity;
import android.app.Application;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.cleveradssolutions.mediation.ContextService;
import com.cleveradssolutions.plugin.flutter.bridge.MediationManagerMethodHandler;
import com.cleveradssolutions.sdk.base.CASHandler;
import com.cleversolutions.ads.AdError;
import com.cleversolutions.ads.AdLoadCallback;
import com.cleversolutions.ads.AdType;
import com.cleversolutions.ads.InitialConfiguration;
import com.cleversolutions.ads.InitializationListener;
import com.cleversolutions.ads.MediationManager;

import org.jetbrains.annotations.NotNull;

import kotlin.jvm.functions.Function0;

public final class CASBridge implements ContextService, AdLoadCallback, InitializationListener {
    private static final int AD_TYPE_BANNER = 0;
    private static final int AD_TYPE_INTER = 1;
    private static final int AD_TYPE_REWARD = 2;
    private static final int AD_TYPE_NATIVE = 3;

    final @NotNull Function0<Activity> activityProvider;
    private final MediationManager manager;
    private final AdCallbackWrapper interstitialAdListener;
    private final AdCallbackWrapper rewardedListener;

    @Nullable
    private CASInitCallback initCallback;

    public CASBridge(
            @NotNull Function0<Activity> activityProvider,
            CASBridgeBuilder builder,
            MediationManagerMethodHandler mediationManagerMethodHandler
    ) {
        this.activityProvider = activityProvider;
        this.initCallback = builder.initCallback;
        this.interstitialAdListener =
                new AdCallbackWrapper(mediationManagerMethodHandler.getInterstitialCallbackWrapper(), false);
        this.rewardedListener =
                new AdCallbackWrapper(mediationManagerMethodHandler.getRewardedCallbackWrapper(), true);
        manager = builder.builder.withCompletionListener(this)
                .initialize(this);
        manager.getOnAdLoadEvent().add(this);
    }

    public MediationManager getMediationManager() {
        return manager;
    }

    public boolean isTestAdModeEnabled() {
        return manager.isDemoAdMode();
    }

    public CASViewWrapper createAdView(final CASCallback listener, final int sizeCode) {
        final CASViewWrapper view = new CASViewWrapper(getActivity());
        CASHandler.INSTANCE.main(() -> {
            view.createView(manager, listener, sizeCode);
        });
        return view;
    }

    public void freeManager() {
        CASHandler.INSTANCE.post(() -> {
            manager.setEnabled(AdType.Banner, false);
            manager.setEnabled(AdType.Interstitial, false);
            manager.setEnabled(AdType.Rewarded, false);
            manager.disableAppReturnAds();
        });
    }

    public void enableReturnAds(CASCallback returnAdListener) {
        manager.enableAppReturnAds(new AdCallbackWrapper(returnAdListener, false));
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

    public void showInterstitial() {
        manager.showInterstitial(getActivity(), interstitialAdListener);
    }

    public void showRewarded() {
        manager.showRewardedAd(getActivity(), rewardedListener);
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
    public void onCASInitialized(@NonNull InitialConfiguration config) {
        if (initCallback != null) {
            initCallback.onCASInitialized(
                    config.getError(),
                    config.getCountryCode(),
                    config.isConsentRequired(),
                    config.getManager().isDemoAdMode());
            initCallback = null;
        }
    }

    @Override
    public Activity getActivityOrNull() {
        return activityProvider.invoke();
    }

    @Override
    public Context getContextOrNull() {
        return activityProvider.invoke();
    }

    @NonNull
    @Override
    public Activity getActivity() throws ActivityNotFoundException {
        return activityProvider.invoke();
    }

    @NonNull
    @Override
    public Context getContext() throws ActivityNotFoundException {
        return activityProvider.invoke();
    }

    @NonNull
    @Override
    public Application getApplication() throws ActivityNotFoundException {
        return activityProvider.invoke().getApplication();
    }

    @Override
    public void onAdLoaded(@NonNull AdType type) {
        if (type == AdType.Interstitial)
            interstitialAdListener.onAdLoaded();
        else if (type == AdType.Rewarded)
            rewardedListener.onAdLoaded();
    }

    @Override
    public void onAdFailedToLoad(@NonNull AdType type, @Nullable String error) {
        if (type == AdType.Interstitial)
            interstitialAdListener.onAdFailed(getErrorCodeFromString(error));
        else if (type == AdType.Rewarded)
            rewardedListener.onAdFailed(getErrorCodeFromString(error));
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

    private int getErrorCodeFromString(@Nullable String error) {
        if (error == null) {
            return AdError.CODE_INTERNAL_ERROR;
        }
        switch (error) {
            case "No internet connection detected":
                return AdError.CODE_NO_CONNECTION;
            case "No Fill":
                return AdError.CODE_NO_FILL;
            case "Invalid configuration":
                return AdError.CODE_CONFIGURATION_ERROR;
            case "Ad are not ready. You need to call Load ads or use one of the automatic cache mode.":
                return AdError.CODE_NOT_READY;
            case "Manager is disabled":
                return AdError.CODE_MANAGER_IS_DISABLED;
            case "Reached cap for user":
                return AdError.CODE_REACHED_CAP;
            case "The interval between impressions Ad has not yet passed.":
                return AdError.CODE_INTERVAL_NOT_YET_PASSED;
            case "Ad already displayed":
                return AdError.CODE_ALREADY_DISPLAYED;
            case "Application is paused":
                return AdError.CODE_APP_IS_PAUSED;
            case "Not enough space to display ads":
                return AdError.CODE_NOT_ENOUGH_SPACE;
            default:
                return AdError.CODE_INTERNAL_ERROR;
        }
    }
}
