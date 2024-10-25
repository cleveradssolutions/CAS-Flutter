package com.cleveradssolutions.plugin.flutter.bridge

import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.CASViewWrapper
import com.cleveradssolutions.plugin.flutter.CASViewWrapperListener
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.error
import com.cleveradssolutions.plugin.flutter.util.errorFieldNull
import com.cleveradssolutions.plugin.flutter.util.errorInvalidArg
import com.cleveradssolutions.plugin.flutter.util.getArgAndCheckNull
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleveradssolutions.sdk.base.CASHandler
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdLoadCallback
import com.cleversolutions.ads.AdPaidCallback
import com.cleversolutions.ads.AdStatusHandler
import com.cleversolutions.ads.AdType
import com.cleversolutions.ads.LoadAdCallback
import com.cleversolutions.ads.MediationManager
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/mediation_manager"

class MediationManagerMethodHandler(
    binding: FlutterPluginBinding,
    private val contextService: CASFlutterContext,
) : MethodHandler(binding, CHANNEL_NAME), AdLoadCallback {

    var manager: MediationManager? = null
        private set

    private val interstitialListener = InterstitialListener()
    private val rewardedListener = RewardedListener()
    private val appReturnListener = AppReturnListener()

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "loadAd" -> loadAd(call, result)
            "isReadyAd" -> isReadyAd(call, result)
            "showAd" -> showAd(call, result)
            "enableAppReturn" -> enableAppReturn(call, result)
            "skipNextAppReturnAds" -> skipNextAppReturnAds(call, result)
            "setEnabled" -> setEnabled(call, result)
            "isEnabled" -> isEnabled(call, result)

            "showBanner" -> showBanner(call, result)
            "hideBanner" -> hideBanner(call, result)
            "setBannerPosition" -> setBannerPosition(call, result)
        }
    }

    override fun onAdLoaded(type: AdType) {
        CASHandler.main {
            if (type == AdType.Interstitial) interstitialListener.onAdLoaded()
            else if (type == AdType.Rewarded) rewardedListener.onAdLoaded()
        }
    }

    override fun onAdFailedToLoad(type: AdType, error: String?) {
        if (error == null) return
        CASHandler.main {
            if (type == AdType.Interstitial) interstitialListener.onAdFailedToLoad(AdError(error))
            else if (type == AdType.Rewarded) rewardedListener.onAdFailedToLoad(AdError(error))
        }
    }

    fun setManager(manager: MediationManager) {
        this.manager = manager
        manager.onAdLoadEvent.add(this)
    }

    private fun setEnabled(call: MethodCall, result: MethodChannel.Result) {
        val manager = getManagerAndCheckNull(call, result) ?: return

        val adTypeIndex = call.getArgAndCheckNull<Int>("adType", result) ?: return
        if (adTypeIndex < 0 || adTypeIndex > 2) return result.errorInvalidArg(call, "adType")
        val adType = AdType.values()[adTypeIndex]
        val enabled = call.getArgAndCheckNull<Boolean>("enable", result) ?: return

        manager.setEnabled(adType, enabled)

        result.success()
    }

    private fun isEnabled(call: MethodCall, result: MethodChannel.Result) {
        val manager = getManagerAndCheckNull(call, result) ?: return

        val adTypeIndex = call.getArgAndCheckNull<Int>("adType", result) ?: return
        if (adTypeIndex < 0 || adTypeIndex > 2) return result.errorInvalidArg(call, "adType")
        val adType = AdType.values()[adTypeIndex]

        val enabled = manager.isEnabled(adType)

        result.success(enabled)
    }

    private fun loadAd(call: MethodCall, result: MethodChannel.Result) {
        val manager = getManagerAndCheckNull(call, result) ?: return

        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        when (adType) {
            AdType.Interstitial.ordinal -> manager.loadInterstitial()
            AdType.Rewarded.ordinal -> manager.loadRewardedAd()
            else -> return result.error(call, "AdType is not supported")
        }

        result.success()
    }

    private fun isReadyAd(call: MethodCall, result: MethodChannel.Result) {
        val manager = getManagerAndCheckNull(call, result) ?: return

        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        when (adType) {
            AdType.Interstitial.ordinal -> result.success(manager.isInterstitialReady)
            AdType.Rewarded.ordinal -> result.success(manager.isRewardedAdReady)
            else -> result.error(call, "AdType is not supported")
        }
    }

    private fun showAd(call: MethodCall, result: MethodChannel.Result) {
        val manager = getManagerAndCheckNull(call, result) ?: return

        val activity = contextService.getActivityOrError(call, result) ?: return
        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        when (adType) {
            AdType.Interstitial.ordinal -> manager.showInterstitial(activity, interstitialListener)
            AdType.Rewarded.ordinal -> manager.showRewardedAd(activity, rewardedListener)
            else -> return result.error(call, "AdType is not supported")
        }

        result.success()
    }

    private fun enableAppReturn(call: MethodCall, result: MethodChannel.Result) {
        val manager = getManagerAndCheckNull(call, result) ?: return

        val enable = call.getArgAndCheckNull<Boolean>("enable", result) ?: return

        if (enable) {
            manager.enableAppReturnAds(appReturnListener)
        } else {
            manager.disableAppReturnAds()
        }

        result.success()
    }

    private fun skipNextAppReturnAds(call: MethodCall, result: MethodChannel.Result) {
        val manager = getManagerAndCheckNull(call, result) ?: return

        manager.skipNextAppReturnAds()

        result.success()
    }


    private val banners = mutableMapOf<Int, CASViewWrapper?>()

    private fun showBanner(call: MethodCall, result: MethodChannel.Result) {
        val sizeId = call.getArgAndCheckNull<Int>("sizeId", result) ?: return

        val banner = banners[sizeId]
        if (banner != null) {
            banner.show()
        } else {
            val view = CASViewWrapper(contextService)
            CASHandler.main {
                view.createView(manager, BannerListener(sizeId), sizeId)
            }
            banners[sizeId] = view
        }

        result.success()
    }

    private fun hideBanner(call: MethodCall, result: MethodChannel.Result) {
        val sizeId = call.getArgAndCheckNull<Int>("sizeId", result) ?: return
        val banner = banners[sizeId]
            ?: return result.errorFieldNull(call, "banners[${getBannerName(sizeId)}]")

        banner.hide()

        result.success()
    }

    private fun setBannerPosition(call: MethodCall, result: MethodChannel.Result) {
        val sizeId = call.getArgAndCheckNull<Int>("sizeId", result) ?: return
        val banner = banners[sizeId]
            ?: return result.errorFieldNull(call, "banners[${getBannerName(sizeId)}]")
        val positionId = call.getArgAndCheckNull<Int>("positionId", result) ?: return
        val x = call.getArgAndCheckNull<Int>("x", result) ?: return
        val y = call.getArgAndCheckNull<Int>("y", result) ?: return

        banner.setPosition(positionId, x, y)

        result.success()
    }

    private fun getManagerAndCheckNull(
        call: MethodCall,
        result: MethodChannel.Result
    ): MediationManager? {
        if (manager == null) result.errorFieldNull(call, "manager")
        return manager
    }

    private fun getBannerName(sizeId: Int): String {
        return when (sizeId) {
            2 -> "adaptive"
            3 -> "smart"
            4 -> "leader"
            5 -> "mrec"
            else -> "standard"
        }
    }

    private inner class BannerListener(sizeId: Int) : CASViewWrapperListener {

        private val name = getBannerName(sizeId)

        override fun onLoaded() {
            invokeMethod("OnBannerAdLoaded", mapOf("banner" to name))
        }

        override fun onFailed(error: Int) {
            invokeMethod(
                "OnBannerAdFailedToLoad",
                mapOf(
                    "banner" to name,
                    "message" to AdError(error).message
                )
            )
        }

        override fun onShown() {
            invokeMethod("OnBannerAdShown", mapOf("banner" to name))
        }

        override fun onImpression(impression: AdStatusHandler?) {
            invokeMethod(
                "OnBannerAdImpression",
                mapOf("banner" to name) + (impression?.toMap() ?: emptyMap())
            )
        }

        override fun onClicked() {
            invokeMethod("OnBannerAdClicked", mapOf("banner" to name))
        }

        override fun onRect(x: Int, y: Int, width: Int, height: Int) {
            invokeMethod(
                "OnBannerAdRect",
                mapOf(
                    "banner" to name,
                    "x" to x,
                    "y" to y,
                    "width" to width,
                    "height" to height
                )
            )
        }
    }

    private inner class InterstitialListener : AdPaidCallback, LoadAdCallback {
        override fun onAdLoaded() {
            invokeMethod("OnInterstitialAdLoaded")
        }

        override fun onAdFailedToLoad(error: AdError) {
            invokeMethod(
                "OnInterstitialAdFailedToLoad",
                mapOf("message" to error.message)
            )
        }

        override fun onShown(ad: AdStatusHandler) {
            invokeMethod("OnInterstitialAdShown")
        }

        override fun onAdRevenuePaid(ad: AdStatusHandler) {
            invokeMethod("OnInterstitialAdImpression", ad.toMap())
        }

        override fun onShowFailed(message: String) {
            invokeMethod("OnInterstitialAdFailedToShow", mapOf("message" to message))
        }

        override fun onClicked() {
            invokeMethod("OnInterstitialAdClicked")
        }

        override fun onClosed() {
            invokeMethod("OnInterstitialAdClosed")
        }
    }

    private inner class RewardedListener : AdPaidCallback, LoadAdCallback {
        override fun onAdLoaded() {
            invokeMethod("OnRewardedAdLoaded")
        }

        override fun onAdFailedToLoad(error: AdError) {
            invokeMethod(
                "OnRewardedAdFailedToLoad",
                mapOf("message" to error.message)
            )
        }

        override fun onShown(ad: AdStatusHandler) {
            invokeMethod("OnRewardedAdShown")
        }

        override fun onAdRevenuePaid(ad: AdStatusHandler) {
            invokeMethod("OnRewardedAdImpression", ad.toMap())
        }

        override fun onShowFailed(message: String) {
            invokeMethod("OnRewardedAdFailedToShow", mapOf("message" to message))
        }

        override fun onClicked() {
            invokeMethod("OnRewardedAdClicked")
        }

        override fun onComplete() {
            invokeMethod("OnRewardedAdCompleted")
        }

        override fun onClosed() {
            invokeMethod("OnRewardedAdClosed")
        }
    }

    private inner class AppReturnListener : AdPaidCallback, LoadAdCallback {
        override fun onAdLoaded() {}

        override fun onAdFailedToLoad(error: AdError) {}

        override fun onShown(ad: AdStatusHandler) {
            invokeMethod("OnAppReturnAdShown")
        }

        override fun onAdRevenuePaid(ad: AdStatusHandler) {
            invokeMethod("OnAppReturnAdImpression", ad.toMap())
        }

        override fun onShowFailed(message: String) {
            invokeMethod("OnAppReturnAdFailedToShow", mapOf("message" to message))
        }

        override fun onClicked() {
            invokeMethod("OnAppReturnAdClicked")
        }

        override fun onClosed() {
            invokeMethod("OnAppReturnAdClosed")
        }
    }

}