package com.cleveradssolutions.plugin.flutter.bannerview

import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleveradssolutions.plugin.flutter.CASCallback
import com.cleveradssolutions.plugin.flutter.CASViewWrapper
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.errorArgNull
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdStatusHandler
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val LOG_TAG = "BannerMethodHandler"
private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/banner."

class BannerMethodHandler(
    flutterId: String,
    private val bannerView: CASBannerView,
    private val bridgeProvider: () -> CASBridge?,
    private val disposeBanner: () -> Unit
) : MethodHandler(CHANNEL_NAME + flutterId) {

    private val banners = mutableMapOf<Int, CASViewWrapper?>()

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isAdReady" -> result.success(bannerView.isAdReady)
            "loadNextAd" -> bannerView.loadNextAd()

            "createBannerView" -> createBannerView(call, result)
            "loadBanner" -> loadBanner(call, result)
            "isBannerReady" -> isBannerReady(call, result)
            "showBanner" -> showBanner(call, result)
            "hideBanner" -> hideBanner(call, result)
            "setBannerPosition" -> setBannerPosition(call, result)
            "setBannerAdRefreshRate" -> setBannerAdRefreshRate(call, result)
            "disableBannerRefresh" -> disableBannerRefresh(call, result)
            "dispose" -> dispose(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

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

    private fun loadBanner(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("sizeId", result) { banners[it]?.load() }
    }

    private fun isBannerReady(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("sizeId", result) { banners[it]?.isReady }
    }

    private fun showBanner(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("sizeId", result) { banners[it]?.show() }
    }

    private fun hideBanner(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("sizeId", result) { banners[it]?.hide() }
    }

    private fun setBannerPosition(call: MethodCall, result: MethodChannel.Result) {
        val positionId = call.argument<Int>("positionId") ?: return result.errorArgNull(call, "positionId")
        val sizeId = call.argument<Int>("sizeId") ?: return result.errorArgNull(call, "sizeId")
        val x = call.argument<Int>("x") ?: return result.errorArgNull(call, "x")
        val y = call.argument<Int>("y") ?: return result.errorArgNull(call, "y")

        banners[sizeId]?.setPosition(positionId, x, y);

        result.success()
    }

    private fun setBannerAdRefreshRate(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int, Int>("refresh", "sizeId", result) { refresh, sizeId ->
            banners[sizeId]?.refreshInterval = refresh
        }
    }

    private fun disableBannerRefresh(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("sizeId", result) {
            banners[it]?.refreshInterval = 0
        }
    }

    private fun dispose(call: MethodCall, result: MethodChannel.Result) {
        disposeBanner()

        call.getArgAndReturn<Int>("sizeId", result) {
            banners[it]?.destroy()
            banners.remove(it)
        }
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

}