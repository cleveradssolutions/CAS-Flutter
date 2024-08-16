package com.cleveradssolutions.plugin.flutter

import com.cleversolutions.ads.android.CAS
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class AdsSettingsMethodHandler : MethodHandler {

    override fun onMethodCall(call: MethodCall, result: Result): Boolean {
        when (call.method) {
            "getTaggedAudience" -> getTaggedAudience(result)
            "setTaggedAudience" -> setTaggedAudience(call, result)
            "getUserConsent" -> getUserConsent(result)
            "setUserConsent" -> setUserConsent(call, result)
            "getVendorConsent" -> getVendorConsent(call, result)
            "getAdditionalConsent" -> getAdditionalConsent(call, result)
            "getCPPAStatus" -> getCPPAStatus(result)
            "setCCPAStatus" -> setCCPAStatus(call, result)
            "getMutedAdSounds" -> getMutedAdSounds(result)
            "setMutedAdSounds" -> setMutedAdSounds(call, result)
            "getDebugMode" -> getDebugMode(result)
            "setDebugMode" -> setDebugMode(call, result)
            "addTestDeviceId" -> addTestDeviceId(call, result)
            "setTestDeviceId" -> setTestDeviceId(call, result)
            "setTestDeviceIds" -> setTestDeviceIds(call, result)
            "clearTestDeviceIds" -> clearTestDeviceIds(result)
            "getTrialAdFreeInterval" -> getTrialAdFreeInterval(result)
            "setTrialAdFreeInterval" -> setTrialAdFreeInterval(call, result)
            "getBannerRefreshDelay" -> getBannerRefreshDelay(result)
            "setBannerRefreshDelay" -> setBannerRefreshDelay(call, result)
            "getInterstitialInterval" -> getInterstitialInterval(result)
            "setInterstitialInterval" -> setInterstitialInterval(call, result)
            "restartInterstitialInterval" -> restartInterstitialInterval(result)
            "isAllowInterstitialAdsWhenVideoCostAreLower" -> isAllowInterstitialAdsWhenVideoCostAreLower(result)
            "allowInterstitialAdsWhenVideoCostAreLower" -> allowInterstitialAdsWhenVideoCostAreLower(call, result)
            "getLoadingMode" -> getLoadingMode(result)
            "setLoadingMode" -> setLoadingMode(call, result)
            else -> return false
        }
        return true
    }

    private fun getTaggedAudience(result: Result) {
        result.success(CAS.settings.taggedAudience)
    }

    private fun setTaggedAudience(call: MethodCall, result: Result) {
        tryGetArgSetValue<Int>("taggedAudience", call, result) { CAS.settings.taggedAudience = it }
    }

    private fun getUserConsent(result: Result) {
        result.success(CAS.settings.userConsent)
    }

    private fun setUserConsent(call: MethodCall, result: Result) {
        tryGetArgSetValue<Int>("userConsent", call, result) { CAS.settings.userConsent = it }
    }

    private fun getVendorConsent(call: MethodCall, result: Result) {
        tryGetArg<Int>("vendorId", call, result) {
            CAS.settings.getVendorConsent(it)
        }
    }

    private fun getAdditionalConsent(call: MethodCall, result: Result) {
        tryGetArg<Int>("providerId", call, result) {
            CAS.settings.getAdditionalConsent(it)
        }
    }

    private fun getCPPAStatus(result: Result) {
        result.success(CAS.settings.ccpaStatus)
    }

    private fun setCCPAStatus(call: MethodCall, result: Result) {
        tryGetArgSetValue<Int>("ccpa", call, result) { CAS.settings.ccpaStatus = it }
    }

    private fun getMutedAdSounds(result: Result) {
        result.success(CAS.settings.mutedAdSounds)
    }

    private fun setMutedAdSounds(call: MethodCall, result: Result) {
        tryGetArgSetValue<Boolean>("muted", call, result) { CAS.settings.mutedAdSounds = it }
    }

    private fun getDebugMode(result: Result) {
        result.success(CAS.settings.debugMode)
    }

    private fun setDebugMode(call: MethodCall, result: Result) {
        tryGetArgSetValue<Boolean>("enable", call, result) { CAS.settings.debugMode = it }
    }

    private fun addTestDeviceId(call: MethodCall, result: Result) {
        tryGetArgSetValue<String>("deviceId", call, result) { CAS.settings.testDeviceIDs += it }
    }

    private fun setTestDeviceId(call: MethodCall, result: Result) {
        tryGetArgSetValue<String>("deviceId", call, result) { CAS.settings.testDeviceIDs = setOf(it) }
    }

    private fun setTestDeviceIds(call: MethodCall, result: Result) {
        tryGetArgSetValue<Set<String>>("deviceIds", call, result) {
            CAS.settings.testDeviceIDs = it
        }
    }

    private fun clearTestDeviceIds(result: Result) {
        CAS.settings.testDeviceIDs = emptySet()
        result.success(null)
    }

    private fun getTrialAdFreeInterval(result: Result) {
        result.success(CAS.settings.trialAdFreeInterval)
    }

    private fun setTrialAdFreeInterval(call: MethodCall, result: Result) {
        tryGetArgSetValue<Int>("interval", call, result) {
            CAS.settings.bannerRefreshInterval = it
        }
    }

    private fun getBannerRefreshDelay(result: Result) {
        result.success(CAS.settings.bannerRefreshInterval)
    }

    private fun setBannerRefreshDelay(call: MethodCall, result: Result) {
        tryGetArgSetValue<Int>("delay", call, result) { CAS.settings.bannerRefreshInterval = it }
    }

    private fun getInterstitialInterval(result: Result) {
        result.success(CAS.settings.interstitialInterval)
    }

    private fun setInterstitialInterval(call: MethodCall, result: Result) {
        tryGetArgSetValue<Int>("delay", call, result) { CAS.settings.interstitialInterval = it }
    }

    private fun restartInterstitialInterval(result: Result) {
        CAS.settings.restartInterstitialInterval()
        result.success(null)
    }

    private fun isAllowInterstitialAdsWhenVideoCostAreLower(result: Result) {
        result.success(CAS.settings.allowInterstitialAdsWhenVideoCostAreLower)
    }

    private fun allowInterstitialAdsWhenVideoCostAreLower(call: MethodCall, result: Result) {
        tryGetArgSetValue<Boolean>("enable", call, result) {
            CAS.settings.allowInterstitialAdsWhenVideoCostAreLower = it
        }
    }

    private fun getLoadingMode(result: Result) {
        result.success(CAS.settings.loadingMode)
    }

    private fun setLoadingMode(call: MethodCall, result: Result) {
        tryGetArgSetValue<Int>("loadingMode", call, result) { CAS.settings.loadingMode = it }
    }

}