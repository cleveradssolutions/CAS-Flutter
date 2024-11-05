package com.cleveradssolutions.plugin.flutter.bridge

import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturnResult
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleversolutions.ads.android.CAS
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/ads_settings"

class AdsSettingsMethodHandler(
    binding: FlutterPluginBinding
) : MethodHandler(binding, CHANNEL_NAME) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
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
            "getTrialAdFreeInterval" -> getTrialAdFreeInterval(result)
            "setTrialAdFreeInterval" -> setTrialAdFreeInterval(call, result)
            "getBannerRefreshDelay" -> getBannerRefreshDelay(result)
            "setBannerRefreshDelay" -> setBannerRefreshDelay(call, result)
            "getInterstitialInterval" -> getInterstitialInterval(result)
            "setInterstitialInterval" -> setInterstitialInterval(call, result)
            "restartInterstitialInterval" -> restartInterstitialInterval(result)
            "isAllowInterstitialAdsWhenVideoCostAreLower" -> isAllowInterstitialAdsWhenVideoCostAreLower(
                result
            )

            "allowInterstitialAdsWhenVideoCostAreLower" -> allowInterstitialAdsWhenVideoCostAreLower(
                call,
                result
            )

            "getLoadingMode" -> getLoadingMode(result)
            "setLoadingMode" -> setLoadingMode(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun getTaggedAudience(result: MethodChannel.Result) {
        result.success(CAS.settings.taggedAudience)
    }

    private fun setTaggedAudience(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("taggedAudience", result) {
            CAS.settings.taggedAudience = it
        }
    }

    private fun getUserConsent(result: MethodChannel.Result) {
        result.success(CAS.settings.userConsent)
    }

    private fun setUserConsent(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("userConsent", result) {
            CAS.settings.userConsent = it
        }
    }

    private fun getVendorConsent(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturnResult<Int>("vendorId", result) {
            CAS.settings.getVendorConsent(it)
        }
    }

    private fun getAdditionalConsent(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturnResult<Int>("providerId", result) {
            CAS.settings.getAdditionalConsent(it)
        }
    }

    private fun getCPPAStatus(result: MethodChannel.Result) {
        result.success(CAS.settings.ccpaStatus)
    }

    private fun setCCPAStatus(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("ccpa", result) {
            CAS.settings.ccpaStatus = it
        }
    }

    private fun getMutedAdSounds(result: MethodChannel.Result) {
        result.success(CAS.settings.mutedAdSounds)
    }

    private fun setMutedAdSounds(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Boolean>("muted", result) {
            CAS.settings.mutedAdSounds = it
        }
    }

    private fun getDebugMode(result: MethodChannel.Result) {
        result.success(CAS.settings.debugMode)
    }

    private fun setDebugMode(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Boolean>("enable", result) {
            CAS.settings.debugMode = it
        }
    }

    private fun addTestDeviceId(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<String>("deviceId", result) {
            CAS.settings.testDeviceIDs += it
        }
    }

    private fun setTestDeviceId(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<String>("deviceId", result) {
            CAS.settings.testDeviceIDs = setOf(it)
        }
    }

    private fun setTestDeviceIds(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Set<String>>("deviceIds", result) {
            CAS.settings.testDeviceIDs = it
        }
    }

    private fun getTrialAdFreeInterval(result: MethodChannel.Result) {
        result.success(CAS.settings.trialAdFreeInterval)
    }

    private fun setTrialAdFreeInterval(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("interval", result) {
            CAS.settings.bannerRefreshInterval = it
        }
    }

    private fun getBannerRefreshDelay(result: MethodChannel.Result) {
        result.success(CAS.settings.bannerRefreshInterval)
    }

    private fun setBannerRefreshDelay(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("delay", result) {
            CAS.settings.bannerRefreshInterval = it
        }
    }

    private fun getInterstitialInterval(result: MethodChannel.Result) {
        result.success(CAS.settings.interstitialInterval)
    }

    private fun setInterstitialInterval(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("delay", result) {
            CAS.settings.interstitialInterval = it
        }
    }

    private fun restartInterstitialInterval(result: MethodChannel.Result) {
        CAS.settings.restartInterstitialInterval()
        result.success()
    }

    private fun isAllowInterstitialAdsWhenVideoCostAreLower(result: MethodChannel.Result) {
        result.success(CAS.settings.allowInterstitialAdsWhenVideoCostAreLower)
    }

    private fun allowInterstitialAdsWhenVideoCostAreLower(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<Boolean>("enable", result) {
            CAS.settings.allowInterstitialAdsWhenVideoCostAreLower = it
        }
    }

    private fun getLoadingMode(result: MethodChannel.Result) {
        result.success(CAS.settings.loadingMode)
    }

    private fun setLoadingMode(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("loadingMode", result) {
            CAS.settings.loadingMode = it
        }
    }

}