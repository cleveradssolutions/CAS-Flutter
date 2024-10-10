package com.cleveradssolutions.plugin.flutter.bannerview

import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/banner."

class BannerMethodHandler(
    flutterId: String,
    private val platformView: BannerView,
    private val bannerView: CASBannerView
) : MethodHandler(CHANNEL_NAME + flutterId) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "isAdReady" -> isAdReady(result)
            "loadNextAd" -> loadNextAd(result)
            "setBannerAdRefreshRate" -> setBannerAdRefreshRate(call, result)
            "disableBannerRefresh" -> disableBannerRefresh(result)
            "dispose" -> dispose(result)
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

    private fun dispose(result: MethodChannel.Result) {
        platformView.dispose()
        result.success()
    }

}