package com.cleveradssolutions.plugin.flutter

import android.app.Activity
import android.util.Log
import com.cleveradssolutions.plugin.flutter.bannerview.BannerViewFactory
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class CASFlutter : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null

    private var casBridge: CASBridge? = null
    private var casBridgeBuilder: CASBridgeBuilder? = null

    private var interstitialCallbackWrapper: CASCallback? = null
    private var rewardedCallbackWrapper: CASCallback? = null
    private var appReturnCallbackWrapper: CASCallback? = null
    private var initializationCallbackWrapper: CASInitCallback? = null
    private var consentFlowDismissListener: CASConsentFlowDismissListener? = null

    private var bannerStandardCallbackWrapper: CASCallback? = null
    private var bannerAdaptiveCallbackWrapper: CASCallback? = null
    private var bannerSmartCallbackWrapper: CASCallback? = null
    private var bannerLeaderCallbackWrapper: CASCallback? = null
    private var bannerMRECCallbackWrapper: CASCallback? = null

    private val banners = mutableMapOf<Int, CASViewWrapper?>()

    private val errorTag = "CASFlutterBridgeError"

    private var casConsentFlow: CASConsentFlow? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory(
                "<cas-banner-view>",
                BannerViewFactory(this::getCASBridge, flutterPluginBinding.binaryMessenger)
            )

        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "com.cleveradssolutions.cas.ads.flutter"
        )
        channel.setMethodCallHandler(this)

        initCallbacks()
    }

    override fun onDetachedFromEngine(p0: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        detachCallbacks()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "validateIntegration" -> validateIntegration(result)
                "withTestAdMode" -> withTestAdMode(call, result)
                "withUserId" -> setUserId(call, result)
                "withPrivacyUrl" -> withPrivacyUrl(call, result)
                "disableConsentFlow" -> disableConsentFlow(result)
                "showConsentFlow" -> showConsentFlow(result)
                "addExtras" -> addExtras(call, result)
                "initialize" -> build(call, result)
                "loadAd" -> loadAd(call, result)
                "isReadyAd" -> isReadyAd(call, result)
                "showAd" -> showAd(call, result)
                "setInterstitialInterval" -> setInterstitialInterval(call, result)
                "getInterstitialInterval" -> getInterstitialInterval(result)
                "setBannerRefreshDelay" -> setBannerRefreshDelay(call, result)
                "getBannerRefreshDelay" -> getBannerRefreshDelay(result)
                "restartInterstitialInterval" -> restartInterstitialInterval(result)
                "allowInterstitialAdsWhenVideoCostAreLower" -> allowInterstitialAdsWhenVideoCostAreLower(call, result)
                "enableAppReturn" -> enableAppReturn(call, result)
                "skipNextAppReturnAds" -> skipNextAppReturnAds(result)
                "setEnabled" -> setEnabled(call, result)
                "isEnabled" -> isEnabled(call, result)
                "getSDKVersion" -> getSDKVersion(result)
                "setAge" -> setAge(call, result)
                "setGender" -> setGender(call, result)
                "setUserConsentStatus" -> setUserConsentStatus(call, result)
                "getUserConsentStatus" -> getUserConsentStatus(result)
                "setCCPAStatus" -> setCCPAStatus(call, result)
                "getCPPAStatus" -> getCPPAStatus(result)
                "setTaggedAudience" -> setTaggedAudience(call, result)
                "getTaggedAudience" -> getTaggedAudience(result)
                "setNativeDebug" -> setNativeDebug(call, result)
                "setMutedAdSounds" -> setMutedAdSounds(call, result)
                "setLoadingMode" -> setLoadingMode(call, result)
                "clearTestDeviceIds" -> clearTestDeviceIds(result)
                "addTestDeviceId" -> addTestDeviceId(call, result)
                "setTestDeviceIds" -> setTestDeviceIds(call, result)
                "createBannerView" -> createBannerView(call, result)
                "loadBanner" -> loadBanner(call, result)
                "isBannerReady" -> isBannerReady(call, result)
                "showBanner" -> showBanner(call, result)
                "hideBanner" -> hideBanner(call, result)
                "setBannerPosition" -> setBannerPosition(call, result)
                "setBannerAdRefreshRate" -> setBannerAdRefreshRate(call, result)
                "disableBannerRefresh" -> disableBannerRefresh(call, result)
                "disposeBanner" -> disposeBanner(call, result)
                else -> return result.notImplemented()
            }
        } catch (exception: Exception) {
            result.error(errorTag, exception.message, null)
        }
    }

    /** region SDK METHODS   =======================================================================*/

    private fun validateIntegration(result: Result) {
        activity?.let {
            CASBridgeSettings.validateIntegration(it)
            return result.success(null)
        } ?: return result.error(errorTag, "Activity is null", null)
    }

    private fun setEnabled(call: MethodCall, result: Result) {
        val casBridge = getCASBridge()
            ?: return result.error(errorTag, "failed to get manager", null)

        val adType = call.argument<Int>("adType")
            ?: return result.error(errorTag, "adType is null", null)

        val enabled = call.argument<Boolean>("enable")
            ?: return result.error(errorTag, "enable is null", null)

        if (adType < 0 || adType > 2)
            return result.error(errorTag, "adType is not correct", null)

        casBridge.enableAd(adType, enabled)

        return result.success(null)
    }

    private fun isEnabled(call: MethodCall, result: Result) {
        val casBridge = getCASBridge()
            ?: return result.error(errorTag, "failed to get manager", null)

        val adType = call.argument<Int>("adType")
            ?: return result.error(errorTag, "adType is null", null)

        if (adType < 0 || adType > 2)
            return result.error(errorTag, "adType is not correct", null)

        return result.success(casBridge.isEnabled(adType))
    }

    //endregion

    /** region Settings methods  ===================================================================*/

    private fun getSDKVersion(result: Result) {
        return result.success(CASBridgeSettings.getSDKVersion())
    }

    private fun setAge(call: MethodCall, result: Result) {
        val age = call.argument<Int>("age")
            ?: return result.error(errorTag, "age is null", null)

        CASBridgeSettings.setUserAge(age)

        return result.success(null)
    }

    private fun setGender(call: MethodCall, result: Result) {
        val gender = call.argument<Int>("gender")
            ?: return result.error(errorTag, "gender is null", null)

        CASBridgeSettings.setUserGender(gender)

        return result.success(null)
    }

    private fun setUserConsentStatus(call: MethodCall, result: Result) {
        val userConsent = call.argument<Int>("userConsent")
            ?: return result.error(errorTag, "userConsent is null", null)

        CASBridgeSettings.setUserConsent(userConsent)

        return result.success(null)
    }

    private fun getUserConsentStatus(result: Result) {
        return result.success(CASBridgeSettings.getUserConsent())
    }

    private fun setCCPAStatus(call: MethodCall, result: Result) {
        val ccpa = call.argument<Int>("ccpa")
            ?: return result.error(errorTag, "ccpa is null", null)

        CASBridgeSettings.setCcpaStatus(ccpa)

        return result.success(null)
    }

    private fun getCPPAStatus(result: Result) {
        return result.success(CASBridgeSettings.getCcpaStatus())
    }

    private fun setTaggedAudience(call: MethodCall, result: Result) {
        val taggedAudience = call.argument<Int>("taggedAudience")
            ?: return result.error(errorTag, "taggedAudience is null", null)

        CASBridgeSettings.setTaggedAudience(taggedAudience)

        return result.success(null)
    }

    private fun getTaggedAudience(result: Result) {
        return result.success(CASBridgeSettings.getTaggedAudience())
    }

    private fun setNativeDebug(call: MethodCall, result: Result) {
        val enabled = call.argument<Boolean>("enable")
            ?: return result.error(errorTag, "enable is null", null)

        CASBridgeSettings.setNativeDebug(enabled)

        return result.success(null)
    }

    private fun setMutedAdSounds(call: MethodCall, result: Result) {
        val muted = call.argument<Boolean>("muted")
            ?: return result.error(errorTag, "muted is null", null)

        CASBridgeSettings.setMutedAdSounds(muted)

        return result.success(null)
    }

    private fun setLoadingMode(call: MethodCall, result: Result) {
        val loadingMode = call.argument<Int>("loadingMode")
            ?: return result.error(errorTag, "loadingMode is null", null)

        CASBridgeSettings.setLoadingMode(loadingMode)

        return result.success(null)
    }

    private fun clearTestDeviceIds(result: Result) {
        CASBridgeSettings.clearTestDeviceIds()
        return result.success(null)
    }

    private fun addTestDeviceId(call: MethodCall, result: Result) {
        val deviceId = call.argument<String>("deviceId")
            ?: return result.error(errorTag, "deviceId is null", null)

        CASBridgeSettings.addTestDeviceId(deviceId)

        return result.success(null)
    }

    private fun setTestDeviceIds(call: MethodCall, result: Result) {
        val deviceId = call.argument("devices") as List<String>?
            ?: return result.error(errorTag, "deviceId is null", null)

        CASBridgeSettings.setTestDeviceIds(deviceId)

        return result.success(null)
    }

    //endregion

    /** region Builder methods  ====================================================================*/

    private fun withTestAdMode(call: MethodCall, result: Result) {
        val enabled = call.argument<Boolean>("enabled")
            ?: return result.error(errorTag, "enabled is null", null)

        getCASBridgeBuilder()?.withTestMode(enabled)
            ?: return result.error(errorTag, "failed to get CASBridgeBuilder", null)

        return result.success(null)
    }

    private fun setUserId(call: MethodCall, result: Result) {
        val userId = call.argument<String>("userId")
            ?: return result.error(errorTag, "userId is null", null)

        getCASBridgeBuilder()
            ?.setUserId(userId) ?: return result.error(
            errorTag,
            "failed to get CASBridgeBuilder",
            null
        )

        return result.success(null)
    }

    private fun withPrivacyUrl(call: MethodCall, result: Result) {
        val privacyUrl = call.argument<String>("privacyUrl")
            ?: return result.error(errorTag, "enabled is null", null)
        getCASConsentFlow()?.withPrivacyPolicy(privacyUrl)
        return result.success(null)
    }

    private fun disableConsentFlow(result: Result) {
        getCASConsentFlow()?.disable()
        result.success(null)
    }

    private fun showConsentFlow(result: Result) {
        getCASConsentFlow()?.show()
        result.success(null)
    }

    private fun addExtras(call: MethodCall, result: Result) {
        val key = call.argument<String>("key")
            ?: return result.error(errorTag, "key is null", null)

        val value = call.argument<String>("value")
            ?: return result.error(errorTag, "value is null", null)

        getCASBridgeBuilder()
            ?.addExtras(key, value)
            ?: return result.error(errorTag, "failed to get CASBridgeBuilder", null)

        return result.success(null)
    }

    private fun build(call: MethodCall, result: Result) {
        val id = call.argument<String>("id")
            ?: return result.error(errorTag, "CAS ID is null", null)

        val formats = call.argument<Int>("formats")
            ?: return result.error(errorTag, "formats are null", null)

        val version = call.argument<String>("version")
            ?: return result.error(errorTag, "version is null", null)

        casBridge = getCASBridgeBuilder()?.build(id, version, formats, getCASConsentFlow())
            ?: return result.error(errorTag, "failed to get CASBridgeBuilder", null)

        return result.success(null)
    }

    //endregion

    /** region Ads API methods  ====================================================================*/

    private fun loadAd(call: MethodCall, result: Result) {
        val casBridge = getCASBridge()
            ?: return result.error(errorTag, "failed to get manager", null)

        val adType = call.argument<Int>("adType")
            ?: return result.error(errorTag, "adType is null", null)

        if (adType == 1) {
            casBridge.loadInterstitial()
            return result.success(null)
        }

        if (adType == 2) {
            casBridge.loadRewarded()
            return result.success(null)
        }

        return result.error(errorTag, "AdType is not supported", null)
    }

    private fun isReadyAd(call: MethodCall, result: Result) {
        val casBridge = getCASBridge()
            ?: return result.error(errorTag, "failed to get manager", null)

        val adType = call.argument<Int>("adType")
            ?: return result.error(errorTag, "adType is null", null)

        if (adType == 1) {
            return result.success(casBridge.isInterstitialAdReady)
        }

        if (adType == 2) {
            return result.success(casBridge.isRewardedAdReady)
        }

        return result.error(errorTag, "AdType is not supported", null)
    }

    private fun showAd(call: MethodCall, result: Result) {
        val casBridge = getCASBridge()
            ?: return result.error(errorTag, "failed to get manager", null)

        val adType = call.argument<Int>("adType")
            ?: return result.error(errorTag, "adType is null", null)

        if (adType == 1) {
            casBridge.showInterstitial()
            return result.success(null)
        } else if (adType == 2) {
            casBridge.showRewarded()
            return result.success(null)
        } else {
            return result.error(errorTag, "AdType is not supported", null)
        }
    }

    private fun setInterstitialInterval(call: MethodCall, result: Result) {
        val interval = call.argument<Int>("interval")
            ?: return result.error(errorTag, "interval is null", null)

        CASBridgeSettings.setInterstitialInterval(interval)

        return result.success(null)
    }

    private fun getInterstitialInterval(result: Result) {
        return result.success(CASBridgeSettings.getInterstitialInterval())
    }

    private fun setBannerRefreshDelay(call: MethodCall, result: Result) {
        val delay = call.argument<Int>("delay")
            ?: return result.error(errorTag, "delay is null", null)

        CASBridgeSettings.setRefreshBannerDelay(delay)

        return result.success(null)
    }

    private fun getBannerRefreshDelay(result: Result) {
        return result.success(CASBridgeSettings.getBannerRefreshDelay())
    }

    private fun restartInterstitialInterval(result: Result) {
        CASBridgeSettings.restartInterstitialInterval()
        return result.success(null)
    }

    private fun allowInterstitialAdsWhenVideoCostAreLower(call: MethodCall, result: Result) {
        val enable = call.argument<Boolean>("enable")
            ?: return result.error(errorTag, "interval is null", null)

        CASBridgeSettings.allowInterInsteadOfRewarded(enable)

        return result.success(null)
    }

    private fun enableAppReturn(call: MethodCall, result: Result) {
        val casBridge = getCASBridge()
            ?: return result.error(errorTag, "failed to get manager", null)

        val enable = call.argument<Boolean>("enable")
            ?: return result.error(errorTag, "enable is null", null)

        if (enable)
            casBridge.enableReturnAds(appReturnCallbackWrapper)
        else
            casBridge.disableReturnAds()

        return result.success(null)
    }

    private fun skipNextAppReturnAds(result: Result) {
        val casBridge = getCASBridge()
            ?: return result.error(errorTag, "failed to get manager", null)

        casBridge.skipNextReturnAds()

        return result.success(null)
    }

    //endregion

    /** region Banner API methods  ====================================================================*/

    private fun createBannerView(call: MethodCall, result: Result) {
        val casBridgeTemp =
            getCASBridge() ?: return result.error(errorTag, "failed to get CASBridgeBuilder", null)

        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(errorTag, "Size Id is null", null)

        if (banners.containsKey(sizeId)) {
            return return result.success(null);
        } else {
            val casBannerView = when (sizeId) {
                1 -> casBridgeTemp.createAdView(bannerStandardCallbackWrapper, sizeId)
                2 -> casBridgeTemp.createAdView(bannerAdaptiveCallbackWrapper, sizeId)
                3 -> casBridgeTemp.createAdView(bannerSmartCallbackWrapper, sizeId)
                4 -> casBridgeTemp.createAdView(bannerLeaderCallbackWrapper, sizeId)
                5 -> casBridgeTemp.createAdView(bannerMRECCallbackWrapper, sizeId)
                else -> casBridgeTemp.createAdView(bannerStandardCallbackWrapper, 1)
            }
            banners.put(sizeId, casBannerView)
            return result.success(null);
        }
    }

    private fun loadBanner(call: MethodCall, result: Result) {
        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(errorTag, "Size Id is null", null)

        banners[sizeId]?.load()
        return result.success(null)
    }

    private fun isBannerReady(call: MethodCall, result: Result) {
        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(errorTag, "Size Id is null", null)

        return result.success(banners[sizeId]?.isReady)
    }

    private fun showBanner(call: MethodCall, result: Result) {
        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(errorTag, "Size Id is null", null)

        banners[sizeId]?.show()

        return result.success(null)
    }

    private fun hideBanner(call: MethodCall, result: Result) {
        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(errorTag, "Size Id is null", null)

        banners[sizeId]?.hide()

        return result.success(null)
    }

    private fun changeBannerPosition(call: MethodCall, result: Result) {
        val positionId = call.argument<Int>("positionId")
            ?: return result.error(errorTag, "positionId is null", null)

        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(errorTag, "Size Id is null", null)

        banners[sizeId]?.setPosition(positionId, 0, 0);

        return result.success(null)
    }

    private fun setBannerPosition(call: MethodCall, result: Result) {
        val positionId = call.argument<Int>("positionId")
            ?: return result.error(errorTag, "positionId is null", null)

        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(errorTag, "Size Id is null", null)

        val x = call.argument<Int>("x")
            ?: return result.error(errorTag, "Size Id is null", null)

        val y = call.argument<Int>("y")
            ?: return result.error(errorTag, "Size Id is null", null)

        banners[sizeId]?.setPosition(positionId, x, y);

        return result.success(null)
    }

    private fun setBannerAdRefreshRate(call: MethodCall, result: Result) {
        val refresh = call.argument<Int>("refresh")
            ?: return result.error(errorTag, "refresh is null", null)

        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(errorTag, "Size Id is null", null)

        banners[sizeId]?.refreshInterval = refresh

        return result.success(null)
    }

    private fun disableBannerRefresh(call: MethodCall, result: Result) {
        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(errorTag, "Size Id is null", null)

        banners[sizeId]?.refreshInterval = 0

        return result.success(null)
    }

    private fun disposeBanner(call: MethodCall, result: Result) {
        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(errorTag, "Size Id is null", null)

        banners[sizeId]?.destroy()
        banners.remove(sizeId)

        return result.success(null)
    }

    //endregion

    private fun getCASBridgeBuilder(): CASBridgeBuilder? {
        if (casBridgeBuilder == null) {
            activity.let { activity ->
                casBridgeBuilder = CASBridgeBuilder(activity)
                casBridgeBuilder?.setCallbacks(
                    initializationCallbackWrapper,
                    interstitialCallbackWrapper,
                    rewardedCallbackWrapper
                )
            }
        }

        return casBridgeBuilder
    }

    private fun getCASConsentFlow(): CASConsentFlow? {
        if (casConsentFlow == null) {
            val consent = CASConsentFlow()
            consent.withActivity(activity)
            consent.withDismissListener(consentFlowDismissListener)
            casConsentFlow = consent
        }

        return casConsentFlow
    }

    private fun getCASBridge(): CASBridge? {
        if (casBridgeBuilder == null)
            Log.e(errorTag, "Call CAS Manager Builder first")
        if (casBridge == null)
            Log.e(errorTag, "Call ManagerBuilder.build first")

        return casBridge
    }

    // endregion

    /** region ActivityAware =======================================================================*/
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        getCASConsentFlow()?.withActivity(activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
    // endregion

    /** region Events ==============================================================================*/

    private fun initCallbacks() {
        // initialization
        initializationCallbackWrapper =
            CASInitCallback { error, countryCode, isConsentRequired, isTestMode ->
                invokeChannelMethod(
                    "onCASInitialized", mapOf(
                        "error" to error,
                        "countryCode" to countryCode,
                        "isConsentRequired" to isConsentRequired,
                        "testMode" to isTestMode
                    )
                )
            }
        //Consent
        consentFlowDismissListener =
            CASConsentFlowDismissListener { status ->
                invokeChannelMethod(
                    "OnDismissListener",
                    mapOf("status" to status)
                )
            }
        // interstitial
        interstitialCallbackWrapper = object : CASCallback {
            override fun onLoaded() {
                invokeChannelMethod("OnInterstitialAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeChannelMethod(
                    "OnInterstitialAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeChannelMethod("OnInterstitialAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeChannelMethod("OnInterstitialAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeChannelMethod("OnInterstitialAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeChannelMethod("OnInterstitialAdClicked")
            }

            override fun onComplete() {
                invokeChannelMethod("OnInterstitialAdComplete")
            }

            override fun onClosed() {
                invokeChannelMethod("OnInterstitialAdClosed")
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {}
        }
        // rewarded
        rewardedCallbackWrapper = object : CASCallback {
            override fun onLoaded() {
                invokeChannelMethod("OnRewardedAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeChannelMethod(
                    "OnRewardedAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeChannelMethod("OnRewardedAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeChannelMethod("OnRewardedAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeChannelMethod("OnRewardedAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeChannelMethod("OnRewardedAdClicked")
            }

            override fun onComplete() {
                invokeChannelMethod("OnRewardedAdCompleted")
            }

            override fun onClosed() {
                invokeChannelMethod("OnRewardedAdClosed")
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {}
        }
        // app return
        appReturnCallbackWrapper = object : CASCallback {
            override fun onLoaded() {
            }

            override fun onFailed(error: Int) {
            }

            override fun onShown() {
                invokeChannelMethod("OnAppReturnAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeChannelMethod("OnAppReturnAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeChannelMethod("OnAppReturnAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeChannelMethod("OnAppReturnAdClicked")
            }

            override fun onComplete() {}

            override fun onClosed() {
                invokeChannelMethod("OnAppReturnAdClosed")
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {}
        }

        // banner Standart
        bannerStandardCallbackWrapper = object : CASCallback {
            override fun onLoaded() {
                invokeChannelMethod("1OnBannerAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeChannelMethod(
                    "1OnBannerAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeChannelMethod("1OnBannerAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeChannelMethod("1OnBannerAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeChannelMethod("1OnBannerAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeChannelMethod("1OnBannerAdClicked")
            }

            override fun onComplete() {
            }

            override fun onClosed() {
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {
                invokeChannelMethod(
                    "1OnBannerAdRect", hashMapOf(
                        "x" to x,
                        "y" to y,
                        "width" to width,
                        "height" to height
                    )
                )
            }
        }

        bannerAdaptiveCallbackWrapper = object : CASCallback {
            override fun onLoaded() {
                invokeChannelMethod("2OnBannerAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeChannelMethod(
                    "2OnBannerAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeChannelMethod("2OnBannerAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeChannelMethod("2OnBannerAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeChannelMethod("2OnBannerAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeChannelMethod("2OnBannerAdClicked")
            }

            override fun onComplete() {
            }

            override fun onClosed() {
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {
                invokeChannelMethod(
                    "2OnBannerAdRect", hashMapOf(
                        "x" to x,
                        "y" to y,
                        "width" to width,
                        "height" to height
                    )
                )
            }
        }

        bannerSmartCallbackWrapper = object : CASCallback {
            override fun onLoaded() {
                invokeChannelMethod("3OnBannerAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeChannelMethod(
                    "3OnBannerAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeChannelMethod("3OnBannerAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeChannelMethod("3OnBannerAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeChannelMethod("3OnBannerAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeChannelMethod("3OnBannerAdClicked")
            }

            override fun onComplete() {
            }

            override fun onClosed() {
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {
                invokeChannelMethod(
                    "3OnBannerAdRect", hashMapOf(
                        "x" to x,
                        "y" to y,
                        "width" to width,
                        "height" to height
                    )
                )
            }
        }

        bannerLeaderCallbackWrapper = object : CASCallback {
            override fun onLoaded() {
                invokeChannelMethod("4OnBannerAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeChannelMethod(
                    "4OnBannerAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeChannelMethod("4OnBannerAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeChannelMethod("4OnBannerAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeChannelMethod("4OnBannerAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeChannelMethod("4OnBannerAdClicked")
            }

            override fun onComplete() {
            }

            override fun onClosed() {
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {
                invokeChannelMethod(
                    "4OnBannerAdRect", hashMapOf(
                        "x" to x,
                        "y" to y,
                        "width" to width,
                        "height" to height
                    )
                )
            }
        }

        bannerMRECCallbackWrapper = object : CASCallback {
            override fun onLoaded() {
                invokeChannelMethod("5OnBannerAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeChannelMethod(
                    "5OnBannerAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeChannelMethod("5OnBannerAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeChannelMethod("5OnBannerAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeChannelMethod("5OnBannerAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeChannelMethod("5OnBannerAdClicked")
            }

            override fun onComplete() {
            }

            override fun onClosed() {
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {
                invokeChannelMethod(
                    "5OnBannerAdRect", hashMapOf(
                        "x" to x,
                        "y" to y,
                        "width" to width,
                        "height" to height
                    )
                )
            }
        }
    }

    private fun detachCallbacks() {
        interstitialCallbackWrapper = null
        rewardedCallbackWrapper = null
        bannerMRECCallbackWrapper = null
        bannerLeaderCallbackWrapper = null
        bannerAdaptiveCallbackWrapper = null
        bannerStandardCallbackWrapper = null
        bannerSmartCallbackWrapper = null
    }

    /**
     * Thin wrapper for runOnUiThread and invokeMethod.
     * No success result handling expected for now.
     */
    fun invokeChannelMethod(methodName: String, args: Map<String, Any?>? = null) {
        activity?.runOnUiThread {
            channel.invokeMethod(methodName, args, object : Result {
                override fun success(result: Any?) {}
                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.e(
                        errorTag, "Error: invokeMethod $methodName failed "
                                + "errorCode: $errorCode, message: $errorMessage, details: $errorDetails"
                    )
                }

                override fun notImplemented() {
                    throw Error("Critical Error: invokeMethod $methodName notImplemented ")
                }
            })
        }
    }
    // endregion

}
