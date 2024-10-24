package com.cleveradssolutions.plugin.flutter.bridge

import com.cleveradssolutions.plugin.flutter.AdCallbackWrapper
import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleveradssolutions.plugin.flutter.CASCallback
import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.CASViewWrapper
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.error
import com.cleveradssolutions.plugin.flutter.util.errorFieldNull
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
    binding: FlutterPluginBinding,
    private val contextService: CASFlutterContext,
) : MethodHandler(binding, CHANNEL_NAME) {

    var bridge: CASBridge? = null

    var interstitialCallbackWrapper: AdCallbackWrapper = createInterstitialCallback()
    var rewardedCallbackWrapper: AdCallbackWrapper = createRewardedCallback()
    private var appReturnCallbackWrapper: AdCallbackWrapper = createAppReturnCallback()

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
            "showBanner" -> showBanner(call, result)
            "hideBanner" -> hideBanner(call, result)
            "setBannerPosition" -> setBannerPosition(call, result)
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

        val activity = contextService.getActivityOrError(call, result) ?: return
        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        when (adType) {
            1 -> casBridge.showInterstitial(activity)
            2 -> casBridge.showRewarded(activity)
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
        val sizeId = call.getArgAndCheckNull<Int>("sizeId", result) ?: return

        if (!banners.containsKey(sizeId)) {
            val casBridge = getBridgeAndCheckNull(call, result) ?: return

            banners[sizeId] = casBridge.createAdView(createListener(sizeId), sizeId, contextService)
        }

        result.success()
    }

    private fun showBanner(call: MethodCall, result: MethodChannel.Result) {
        val sizeId = call.getArgAndCheckNull<Int>("sizeId", result) ?: return
        val banner = banners[sizeId]
            ?: return result.errorFieldNull(call, "banners[${getBannerName(sizeId)}]")

        banner.show()

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

    private fun getBridgeAndCheckNull(call: MethodCall, result: MethodChannel.Result): CASBridge? {
        if (bridge == null) result.errorFieldNull(call, "CASBridge")
        return bridge
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

    private fun createListener(sizeId: Int): CASCallback {
        val name = getBannerName(sizeId)
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

    private fun createInterstitialCallback(): AdCallbackWrapper {
        return object : AdCallbackWrapper() {
            override fun onAdLoaded() {
                invokeMethod("OnInterstitialAdLoaded")
            }

            override fun onAdFailed(error: Int) {
                invokeMethod(
                    "OnInterstitialAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
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
    }

    private fun createRewardedCallback(): AdCallbackWrapper {
        return object : AdCallbackWrapper() {
            override fun onAdLoaded() {
                invokeMethod("OnRewardedAdLoaded")
            }

            override fun onAdFailed(error: Int) {
                invokeMethod(
                    "OnRewardedAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
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
    }

    private fun createAppReturnCallback(): AdCallbackWrapper {
        return object : AdCallbackWrapper() {
            override fun onAdLoaded() {
            }

            override fun onAdFailed(error: Int) {
            }

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

}