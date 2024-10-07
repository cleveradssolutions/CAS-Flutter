package com.cleveradssolutions.plugin.flutter.bannerview

import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleveradssolutions.plugin.flutter.CASCallback
import com.cleveradssolutions.plugin.flutter.CASViewWrapper
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.errorArgNull
import com.cleveradssolutions.plugin.flutter.util.getArgAndCheckNull
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdStatusHandler
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/banner."

class BannerMethodHandler(
    flutterId: String,
    private val platformView: BannerView,
    private val bannerView: CASBannerView,
    private val bridgeProvider: () -> CASBridge?
) : MethodHandler(CHANNEL_NAME + flutterId) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isAdReady" -> isAdReady(result)
            "loadNextAd" -> loadNextAd(result)
            "showBanner" -> showBanner(result)
            "hideBanner" -> hideBanner(result)
            "setBannerPosition" -> setBannerPosition(call, result)
            "setBannerAdRefreshRate" -> setBannerAdRefreshRate(call, result)
            "disableBannerRefresh" -> disableBannerRefresh(result)
            "dispose" -> dispose(result)
            "createBannerView" -> createBannerView(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun isAdReady(result: MethodChannel.Result) {
        result.success(bannerView.isAdReady)
    }

    private fun loadNextAd(result: MethodChannel.Result) {
        bannerView.loadNextAd()
        result.success()
    }

    private fun setBannerAdRefreshRate(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("refresh", result) {
            bannerView.refreshInterval = it
        }
    }

    private fun disableBannerRefresh(result: MethodChannel.Result) {
        bannerView.disableAdRefresh()
        result.success()
    }

    private fun showBanner(result: MethodChannel.Result) {
        platformView.show()
        result.success()
    }

    private fun hideBanner(result: MethodChannel.Result) {
        platformView.hide()
        result.success()
    }

    private fun setBannerPosition(call: MethodCall, result: MethodChannel.Result) {
        val positionId = call.getArgAndCheckNull<Int>("positionId", result) ?: return
        val x = call.getArgAndCheckNull<Int>("x", result) ?: return
        val y = call.getArgAndCheckNull<Int>("y", result) ?: return

        platformView.setPosition(positionId, x, y)

        result.success()
    }

    private fun dispose(result: MethodChannel.Result) {
        platformView.dispose()
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

}