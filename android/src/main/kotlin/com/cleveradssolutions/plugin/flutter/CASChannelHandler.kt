package com.cleveradssolutions.plugin.flutter

import android.app.Activity
import android.location.Location
import com.cleversolutions.ads.android.CAS
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

private const val LOG_TAG = "[Android] CASChannelHandler"

class CASChannelHandler(
    private val activityProvider: () -> Activity?,
    private val anotherChannelHandler: MethodChannel.MethodCallHandler
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                // CAS
                "getSDKVersion" -> getSDKVersion(result)
                "validateIntegration" -> validateIntegration(result, activityProvider)
                // AdsSettings
                "getTaggedAudience" -> getTaggedAudience(result)
                "setTaggedAudience" -> setTaggedAudience(call, result)
                "getUserConsent" -> getUserConsent(result)
                "setUserConsent" -> setUserConsent(call, result)
                "getCPPAStatus" -> getCPPAStatus(result)
                "setCCPAStatus" -> setCCPAStatus(call, result)
                "getMutedAdSounds" -> getMutedAdSounds(result)
                "setMutedAdSounds" -> setMutedAdSounds(call, result)
                "getDebugMode" -> getDebugMode(result)
                "setDebugMode" -> setDebugMode(call, result)
                "getTestDeviceIds" -> getTestDeviceIds(result)
                "addTestDeviceId" -> addTestDeviceId(call, result)
                "setTestDeviceIds" -> setTestDeviceIds(call, result)
                "clearTestDeviceIds" -> clearTestDeviceIds(result)
                "getTrialAdFreeInterval" -> getTrialAdFreeInterval(result)
                "setTrialAdFreeInterval" -> setTrialAdFreeInterval(call, result)
                "getBannerRefreshDelay" -> getBannerRefreshDelay(result)
                "setBannerRefreshDelay" -> setBannerRefreshDelay(call, result)
                "getInterstitialInterval" -> getInterstitialInterval(result)
                "setInterstitialInterval" -> setInterstitialInterval(call, result)
                "restartInterstitialInterval" -> restartInterstitialInterval(result)
                "isAllowInterstitialAdsWhenVideoCostAreLower" ->
                    isAllowInterstitialAdsWhenVideoCostAreLower(result)

                "allowInterstitialAdsWhenVideoCostAreLower" ->
                    allowInterstitialAdsWhenVideoCostAreLower(call, result)

                "getLoadingMode" -> getLoadingMode(result)
                "setLoadingMode" -> setLoadingMode(call, result)
                // TargetingOptions
                "getGender" -> getGender(result)
                "setGender" -> setGender(call, result)
                "getAge" -> getAge(result)
                "setAge" -> setAge(call, result)
                "getLocationLatitude" -> getLocationLatitude(result)
                "setLocationLatitude" -> setLocationLatitude(call, result)
                "getLocationLongitude" -> getLocationLongitude(result)
                "setLocationLongitude" -> setLocationLongitude(call, result)
                "isLocationCollectionEnabled" -> isLocationCollectionEnabled(result)
                "setLocationCollectionEnabled" -> setLocationCollectionEnabled(call, result)
                "getKeywords" -> getKeywords(result)
                "setKeywords" -> setKeywords(call, result)
                "getContentUrl" -> getContentUrl(result)
                "setContentUrl" -> setContentUrl(call, result)
                else -> anotherChannelHandler.onMethodCall(call, result)
            }
        } catch (exception: Exception) {
            result.error(LOG_TAG, exception.message, null)
        }
    }

    // CAS

    private fun getSDKVersion(result: Result) {
        return result.success(CAS.getSDKVersion())
    }

    private fun validateIntegration(result: Result, activityProvider: () -> Activity?) {
        return activityProvider()?.let {
            CAS.validateIntegration(it)
            result.success(null)
        } ?: result.error(LOG_TAG, "Activity is null", null)
    }

    // AdsSettings

    private fun getTaggedAudience(result: Result) {
        return result.success(CAS.settings.taggedAudience)
    }

    private fun setTaggedAudience(call: MethodCall, result: Result) {
        return trySetValue<Int>("taggedAudience", call, result) { CAS.settings.taggedAudience = it }
    }

    private fun getUserConsent(result: Result) {
        return result.success(CAS.settings.userConsent)
    }

    private fun setUserConsent(call: MethodCall, result: Result) {
        return trySetValue<Int>("userConsent", call, result) { CAS.settings.userConsent = it }
    }

    private fun getCPPAStatus(result: Result) {
        return result.success(CAS.settings.ccpaStatus)
    }

    private fun setCCPAStatus(call: MethodCall, result: Result) {
        return trySetValue<Int>("ccpa", call, result) { CAS.settings.ccpaStatus = it }
    }

    private fun getMutedAdSounds(result: Result) {
        return result.success(CAS.settings.mutedAdSounds)
    }

    private fun setMutedAdSounds(call: MethodCall, result: Result) {
        return trySetValue<Boolean>("muted", call, result) { CAS.settings.mutedAdSounds = it }
    }

    private fun getDebugMode(result: Result) {
        return result.success(CAS.settings.debugMode)
    }

    private fun setDebugMode(call: MethodCall, result: Result) {
        return trySetValue<Boolean>("enable", call, result) { CAS.settings.debugMode = it }
    }

    private fun getTestDeviceIds(result: Result) {
        return result.success(CAS.settings.testDeviceIDs)
    }

    private fun addTestDeviceId(call: MethodCall, result: Result) {
        return trySetValue<String>("deviceId", call, result) { CAS.settings.testDeviceIDs += it }
    }

    private fun setTestDeviceIds(call: MethodCall, result: Result) {
        return trySetValue<Set<String>>("deviceIds", call, result) {
            CAS.settings.testDeviceIDs = it
        }
    }

    private fun clearTestDeviceIds(result: Result) {
        CAS.settings.testDeviceIDs = emptySet()
        return result.success(null)
    }

    private fun getTrialAdFreeInterval(result: Result) {
        return result.success(CAS.settings.trialAdFreeInterval)
    }

    private fun setTrialAdFreeInterval(call: MethodCall, result: Result) {
        return trySetValue<Int>("interval", call, result) {
            CAS.settings.bannerRefreshInterval = it
        }
    }

    private fun getBannerRefreshDelay(result: Result) {
        return result.success(CAS.settings.bannerRefreshInterval)
    }

    private fun setBannerRefreshDelay(call: MethodCall, result: Result) {
        return trySetValue<Int>("delay", call, result) { CAS.settings.bannerRefreshInterval = it }
    }

    private fun getInterstitialInterval(result: Result) {
        return result.success(CAS.settings.interstitialInterval)
    }

    private fun setInterstitialInterval(call: MethodCall, result: Result) {
        return trySetValue<Int>("delay", call, result) { CAS.settings.interstitialInterval = it }
    }

    private fun restartInterstitialInterval(result: Result) {
        CAS.settings.restartInterstitialInterval()
        return result.success(null)
    }

    private fun isAllowInterstitialAdsWhenVideoCostAreLower(result: Result) {
        return result.success(CAS.settings.allowInterstitialAdsWhenVideoCostAreLower)
    }

    private fun allowInterstitialAdsWhenVideoCostAreLower(call: MethodCall, result: Result) {
        return trySetValue<Boolean>("enable", call, result) {
            CAS.settings.allowInterstitialAdsWhenVideoCostAreLower = it
        }
    }

    private fun getLoadingMode(result: Result) {
        return result.success(CAS.settings.loadingMode)
    }

    private fun setLoadingMode(call: MethodCall, result: Result) {
        return trySetValue<Int>("loadingMode", call, result) { CAS.settings.loadingMode = it }
    }

    // TargetingOptions

    private fun getGender(result: Result) {
        return result.success(CAS.targetingOptions.gender)
    }

    private fun setGender(call: MethodCall, result: Result) {
        return trySetValue<Int>("gender", call, result) { CAS.targetingOptions.gender = it }
    }

    private fun getAge(result: Result) {
        return result.success(CAS.targetingOptions.age)
    }

    private fun setAge(call: MethodCall, result: Result) {
        return trySetValue<Int>("age", call, result) { CAS.targetingOptions.age = it }
    }

    private fun getLocationLatitude(result: Result) {
        return result.success(CAS.targetingOptions.location?.latitude)
    }

    private fun setLocationLatitude(call: MethodCall, result: Result) {
        return trySetValue<Double>("latitude", call, result) {
            val location = CAS.targetingOptions.location ?: Location("").also {
                CAS.targetingOptions.location = it
            }
            location.latitude = it
        }
    }

    private fun getLocationLongitude(result: Result) {
        return result.success(CAS.targetingOptions.location?.longitude)
    }

    private fun setLocationLongitude(call: MethodCall, result: Result) {
        return trySetValue<Double>("longitude", call, result) {
            val location = CAS.targetingOptions.location ?: Location("").also {
                CAS.targetingOptions.location = it
            }
            location.longitude = it
        }
    }

    private fun isLocationCollectionEnabled(result: Result) {
        return result.success(CAS.targetingOptions.locationCollectionEnabled)
    }

    private fun setLocationCollectionEnabled(call: MethodCall, result: Result) {
        return trySetValue<Boolean>("isEnabled", call, result) {
            CAS.targetingOptions.locationCollectionEnabled = it
        }
    }

    private fun getKeywords(result: Result) {
        return result.success(CAS.targetingOptions.keywords)
    }

    private fun setKeywords(call: MethodCall, result: Result) {
        return trySetValue<Set<String>?>("keywords", call, result) {
            CAS.targetingOptions.keywords = it
        }
    }

    private fun getContentUrl(result: Result) {
        return result.success(CAS.targetingOptions.contentUrl)
    }

    private fun setContentUrl(call: MethodCall, result: Result) {
        return trySetValue<String?>("contentUrl", call, result) {
            CAS.targetingOptions.contentUrl = it
        }
    }

}

private inline fun <T> trySetValue(
    name: String,
    call: MethodCall,
    result: Result,
    action: (T) -> Unit
) {
    return call.argument<T>(name)?.let {
        action(it)
        result.success(null)
    } ?: result.error(LOG_TAG, "$name is null", null)
}