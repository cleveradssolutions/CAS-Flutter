package com.cleveradssolutions.plugin.flutter.bridge

import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleveradssolutions.plugin.flutter.CASCallback
import com.cleveradssolutions.plugin.flutter.CASViewWrapper
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.error
import com.cleveradssolutions.plugin.flutter.util.errorArgNull
import com.cleveradssolutions.plugin.flutter.util.errorInvalidArg
import com.cleveradssolutions.plugin.flutter.util.getArgAndCheckNull
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdStatusHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/mediation_manager"

class MediationManagerMethodHandler(
    private val bridgeProvider: () -> CASBridge?
) : MethodHandler(CHANNEL_NAME) {

    var interstitialCallbackWrapper: CASCallback? = null
    var rewardedCallbackWrapper: CASCallback? = null
    private var appReturnCallbackWrapper: CASCallback? = null

    override fun onAttachedToFlutter(flutterPluginBinding: FlutterPluginBinding) {
        super.onAttachedToFlutter(flutterPluginBinding)
        appReturnCallbackWrapper = createAppReturnCallback()
        interstitialCallbackWrapper = createInterstitialCallback()
        rewardedCallbackWrapper = createRewardedCallback()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "loadAd" -> loadAd(call, result)
            "isReadyAd" -> isReadyAd(call, result)
            "showAd" -> showAd(call, result)
            "enableAppReturn" -> enableAppReturn(call, result)
            "skipNextAppReturnAds" -> skipNextAppReturnAds(call, result)
            "setEnabled" -> setEnabled(call, result)
            "isEnabled" -> isEnabled(call, result)
            "createBannerView" -> createBannerView(call, result)
        }
    }

    private fun setEnabled(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        val enabled = call.getArgAndCheckNull<Boolean>("enable", result) ?: return
        if (adType < 0 || adType > 2) return result.errorInvalidArg(call, "adType")

        casBridge.enableAd(adType, enabled)

        result.success()
    }

    private fun isEnabled(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        if (adType < 0 || adType > 2) {
            return result.errorInvalidArg(call, "adType")
        }

        result.success(casBridge.isEnabled(adType))
    }

    private fun loadAd(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        when (adType) {
            1 -> casBridge.loadInterstitial()
            2 -> casBridge.loadRewarded()
            else -> return result.error(call, "AdType is not supported")
        }

        result.success()
    }

    private fun isReadyAd(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        when (adType) {
            1 -> result.success(casBridge.isInterstitialAdReady)
            2 -> result.success(casBridge.isRewardedAdReady)
            else -> result.error(call, "AdType is not supported")
        }
    }

    private fun showAd(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        when (adType) {
            1 -> casBridge.showInterstitial()
            2 -> casBridge.showRewarded()
            else -> return result.error(call, "AdType is not supported")
        }

        result.success()
    }

    private fun enableAppReturn(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        val enable = call.getArgAndCheckNull<Boolean>("enable", result) ?: return

        if (enable) {
            casBridge.enableReturnAds(appReturnCallbackWrapper)
        } else {
            casBridge.disableReturnAds()
        }

        result.success()
    }

    private fun skipNextAppReturnAds(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        casBridge.skipNextReturnAds()

        result.success()
    }



    private val banners = mutableMapOf<Int, CASViewWrapper?>()

    private fun createBannerView(call: MethodCall, result: MethodChannel.Result) {
        val sizeId = call.argument<Int>("sizeId") ?: return result.errorArgNull(call, "sizeId")

        if (!banners.containsKey(sizeId)) {
            val name = when (sizeId) {
                2 -> "adaptive"
                3 -> "smart"
                4 -> "leader"
                5 -> "mrec"
                else -> "standard"
            }
            val casBridge = bridgeProvider() ?: return result.errorArgNull(call, "casBridge")
            banners[sizeId] = casBridge.createAdView(createListener(name), sizeId)
        }

        result.success()
    }

    private fun createListener(name: String): CASCallback {
        return object : CASCallback {
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

            override fun onShowFailed(message: String?) {
                invokeMethod(
                    "OnBannerAdFailedToShow",
                    mapOf(
                        "banner" to name,
                        "message" to message
                    )
                )
            }

            override fun onClicked() {
                invokeMethod("OnBannerAdClicked", mapOf("banner" to name))
            }

            override fun onComplete() {
            }

            override fun onClosed() {
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
    }

    private fun createInterstitialCallback(): CASCallback {
        return object : CASCallback {
            override fun onLoaded() {
                invokeMethod("OnInterstitialAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeMethod(
                    "OnInterstitialAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeMethod("OnInterstitialAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeMethod("OnInterstitialAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeMethod("OnInterstitialAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeMethod("OnInterstitialAdClicked")
            }

            override fun onComplete() {
                invokeMethod("OnInterstitialAdComplete")
            }

            override fun onClosed() {
                invokeMethod("OnInterstitialAdClosed")
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {}
        }
    }

    private fun createRewardedCallback(): CASCallback {
        return object : CASCallback {
            override fun onLoaded() {
                invokeMethod("OnRewardedAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeMethod(
                    "OnRewardedAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeMethod("OnRewardedAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeMethod("OnRewardedAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
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

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {}
        }
    }

    private fun createAppReturnCallback(): CASCallback {
        return object : CASCallback {
            override fun onLoaded() {
            }

            override fun onFailed(error: Int) {
            }

            override fun onShown() {
                invokeMethod("OnAppReturnAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeMethod("OnAppReturnAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeMethod("OnAppReturnAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeMethod("OnAppReturnAdClicked")
            }

            override fun onComplete() {}

            override fun onClosed() {
                invokeMethod("OnAppReturnAdClosed")
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {}
        }
    }

    private fun getBridgeAndCheckNull(call: MethodCall, result: MethodChannel.Result): CASBridge? {
        val bridge = bridgeProvider()
        if (bridge == null) result.errorArgNull(call, "CASBridge")
        return bridge
    }

}