package com.cleveradssolutions.plugin.flutter

import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdStatusHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

private const val LOG_TAG = "BannerMethodHandler"
private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/banner"

class BannerMethodHandler(
    private val bridgeProvider: () -> CASBridge?
) : MethodHandler(CHANNEL_NAME) {

    private val banners = mutableMapOf<Int, CASViewWrapper?>()

    private var bannerStandardCallbackWrapper: CASCallback? = null
    private var bannerAdaptiveCallbackWrapper: CASCallback? = null
    private var bannerSmartCallbackWrapper: CASCallback? = null
    private var bannerLeaderCallbackWrapper: CASCallback? = null
    private var bannerMRECCallbackWrapper: CASCallback? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        super.onAttachedToEngine(flutterPluginBinding)
        // banner Standart
        bannerStandardCallbackWrapper = object : CASCallback {
            override fun onLoaded() {
                invokeMethod("1OnBannerAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeMethod(
                    "1OnBannerAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeMethod("1OnBannerAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeMethod("1OnBannerAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeMethod("1OnBannerAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeMethod("1OnBannerAdClicked")
            }

            override fun onComplete() {
            }

            override fun onClosed() {
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {
                invokeMethod(
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
                invokeMethod("2OnBannerAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeMethod(
                    "2OnBannerAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeMethod("2OnBannerAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeMethod("2OnBannerAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeMethod("2OnBannerAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeMethod("2OnBannerAdClicked")
            }

            override fun onComplete() {
            }

            override fun onClosed() {
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {
                invokeMethod(
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
                invokeMethod("3OnBannerAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeMethod(
                    "3OnBannerAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeMethod("3OnBannerAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeMethod("3OnBannerAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeMethod("3OnBannerAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeMethod("3OnBannerAdClicked")
            }

            override fun onComplete() {
            }

            override fun onClosed() {
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {
                invokeMethod(
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
                invokeMethod("4OnBannerAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeMethod(
                    "4OnBannerAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeMethod("4OnBannerAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeMethod("4OnBannerAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeMethod("4OnBannerAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeMethod("4OnBannerAdClicked")
            }

            override fun onComplete() {
            }

            override fun onClosed() {
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {
                invokeMethod(
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
                invokeMethod("5OnBannerAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeMethod(
                    "5OnBannerAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeMethod("5OnBannerAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeMethod("5OnBannerAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeMethod("5OnBannerAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeMethod("5OnBannerAdClicked")
            }

            override fun onComplete() {
            }

            override fun onClosed() {
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {
                invokeMethod(
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

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "createBannerView" -> createBannerView(call, result)
            "loadBanner" -> loadBanner(call, result)
            "isBannerReady" -> isBannerReady(call, result)
            "showBanner" -> showBanner(call, result)
            "hideBanner" -> hideBanner(call, result)
            "setBannerPosition" -> setBannerPosition(call, result)
            "setBannerAdRefreshRate" -> setBannerAdRefreshRate(call, result)
            "disableBannerRefresh" -> disableBannerRefresh(call, result)
            "disposeBanner" -> disposeBanner(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun createBannerView(call: MethodCall, result: Result) {
        val casBridge = bridgeProvider()
            ?: return result.error(LOG_TAG, "failed to get CASBridgeBuilder", null)

        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(LOG_TAG, "Size Id is null", null)

        if (banners.containsKey(sizeId)) {
            return result.success(null)
        } else {
            val casBannerView = when (sizeId) {
                1 -> casBridge.createAdView(bannerStandardCallbackWrapper, sizeId)
                2 -> casBridge.createAdView(bannerAdaptiveCallbackWrapper, sizeId)
                3 -> casBridge.createAdView(bannerSmartCallbackWrapper, sizeId)
                4 -> casBridge.createAdView(bannerLeaderCallbackWrapper, sizeId)
                5 -> casBridge.createAdView(bannerMRECCallbackWrapper, sizeId)
                else -> casBridge.createAdView(bannerStandardCallbackWrapper, 1)
            }
            banners[sizeId] = casBannerView
            return result.success(null)
        }
    }

    private fun loadBanner(call: MethodCall, result: Result) {
        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(LOG_TAG, "Size Id is null", null)

        banners[sizeId]?.load()
        return result.success(null)
    }

    private fun isBannerReady(call: MethodCall, result: Result) {
        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(LOG_TAG, "Size Id is null", null)

        return result.success(banners[sizeId]?.isReady)
    }

    private fun showBanner(call: MethodCall, result: Result) {
        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(LOG_TAG, "Size Id is null", null)

        banners[sizeId]?.show()

        return result.success(null)
    }

    private fun hideBanner(call: MethodCall, result: Result) {
        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(LOG_TAG, "Size Id is null", null)

        banners[sizeId]?.hide()

        return result.success(null)
    }

    private fun changeBannerPosition(call: MethodCall, result: Result) {
        val positionId = call.argument<Int>("positionId")
            ?: return result.error(LOG_TAG, "positionId is null", null)

        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(LOG_TAG, "Size Id is null", null)

        banners[sizeId]?.setPosition(positionId, 0, 0);

        return result.success(null)
    }

    private fun setBannerPosition(call: MethodCall, result: Result) {
        val positionId = call.argument<Int>("positionId")
            ?: return result.error(LOG_TAG, "positionId is null", null)

        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(LOG_TAG, "Size Id is null", null)

        val x = call.argument<Int>("x")
            ?: return result.error(LOG_TAG, "Size Id is null", null)

        val y = call.argument<Int>("y")
            ?: return result.error(LOG_TAG, "Size Id is null", null)

        banners[sizeId]?.setPosition(positionId, x, y);

        return result.success(null)
    }

    private fun setBannerAdRefreshRate(call: MethodCall, result: Result) {
        val refresh = call.argument<Int>("refresh")
            ?: return result.error(LOG_TAG, "refresh is null", null)

        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(LOG_TAG, "Size Id is null", null)

        banners[sizeId]?.refreshInterval = refresh

        return result.success(null)
    }

    private fun disableBannerRefresh(call: MethodCall, result: Result) {
        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(LOG_TAG, "Size Id is null", null)

        banners[sizeId]?.refreshInterval = 0

        return result.success(null)
    }

    private fun disposeBanner(call: MethodCall, result: Result) {
        val sizeId = call.argument<Int>("sizeId")
            ?: return result.error(LOG_TAG, "Size Id is null", null)

        banners[sizeId]?.destroy()
        banners.remove(sizeId)

        return result.success(null)
    }

}