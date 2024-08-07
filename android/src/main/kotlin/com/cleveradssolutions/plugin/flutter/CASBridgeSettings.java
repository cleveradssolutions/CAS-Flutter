package com.cleveradssolutions.plugin.flutter;

import android.app.Activity;
import android.util.Log;

import com.cleversolutions.ads.AdNetwork;
import com.cleversolutions.ads.android.CAS;

import java.util.HashSet;
import java.util.List;

public final class CASBridgeSettings {
    public static String getSDKVersion() {
        return CAS.getSDKVersion();
    }

    public static void setUserConsent(int consent) {
        CAS.getSettings().setUserConsent(consent);
    }

    public static int getUserConsent() {
        return CAS.getSettings().getUserConsent();
    }

    public static void setCcpaStatus(int ccpa) {
        CAS.getSettings().setCcpaStatus(ccpa);
    }

    public static int getCcpaStatus() {
        return CAS.getSettings().getCcpaStatus();
    }

    public static void setTaggedAudience(int audience) {
        CAS.getSettings().setTaggedAudience(audience);
    }

    public static int getTaggedAudience() {
        return CAS.getSettings().getTaggedAudience();
    }

    public static void setDebugMode(boolean debug) {
        CAS.getSettings().setDebugMode(debug);
    }

    public static void setMutedAdSounds(boolean muted) {
        CAS.getSettings().setMutedAdSounds(muted);
    }

    public static void setLoadingMode(int value) {
        try {
            CAS.getSettings().setLoadingMode(value);
        } catch (Throwable var2) {
            Log.e("CAS.dart", "Unity bridge set Loading mode with unknown id: " + value);
        }
    }

    public static void setRefreshBannerDelay(int delay) {
        CAS.getSettings().setBannerRefreshInterval(delay);
    }

    public static int getBannerRefreshDelay() {
        return CAS.getSettings().getBannerRefreshInterval();
    }

    public static void setInterstitialInterval(int interval) {
        CAS.getSettings().setInterstitialInterval(interval);
    }

    public static int getInterstitialInterval() {
        return CAS.getSettings().getInterstitialInterval();
    }

    public static void restartInterstitialInterval() {
        CAS.getSettings().restartInterstitialInterval();
    }

    public static void setAnalyticsCollectionEnabled(boolean enabled) {
        CAS.getSettings().setAnalyticsCollectionEnabled(enabled);
    }

    public static void clearTestDeviceIds(){
        CAS.getSettings().getTestDeviceIDs().clear();
    }

    public static void addTestDeviceId(String deviceId) {
        CAS.getSettings().getTestDeviceIDs().add(deviceId);
    }

    public static void setTestDeviceIds(List<String> testDeviceIds) {
        CAS.getSettings().setTestDeviceIDs(new HashSet<>(testDeviceIds));
    }

    public static void allowInterInsteadOfRewarded(boolean allow) {
        CAS.getSettings().setAllowInterstitialAdsWhenVideoCostAreLower(allow);
    }

    public static void setUserGender(final int gender) {
        CAS.getTargetingOptions().setGender(gender);
    }

    public static void setUserAge(final int age) {
        CAS.getTargetingOptions().setAge(age);
    }

    public static void validateIntegration(Activity activity) {
        CAS.validateIntegration(activity);
    }

    public static String getActiveMediationPattern() {
        return AdNetwork.getActiveNetworkPattern();
    }

    public static boolean isActiveMediationNetwork(int network) {
        try {
            return AdNetwork.isActiveNetwork(AdNetwork.values()[network]);
        } catch (Throwable e) {
            Log.e("CAS.dart", "isActiveMediationNetwork call wrong Network with index " + network);
            return false;
        }
    }
}
