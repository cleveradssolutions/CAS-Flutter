package com.cleveradssolutions.plugin.flutter.bannerview

import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdImpression
import com.cleversolutions.ads.AdViewListener
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/banner."

class BannerMethodHandler(
    binding: FlutterPluginBinding,
    flutterId: String,
    private val bannerView: CASBannerView
) : MethodHandler(binding, CHANNEL_NAME + flutterId), AdViewListener {

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

    override fun onAdViewLoaded(view: CASBannerView) {
        invokeMethod("onAdViewLoaded")
    }

    override fun onAdViewFailed(view: CASBannerView, error: AdError) {
        invokeMethod("onAdViewFailed", error.message)
    }

    override fun onAdViewPresented(view: CASBannerView, info: AdImpression) {
        invokeMethod("onAdViewPresented", info.toMap())
    }

    override fun onAdViewClicked(view: CASBannerView) {
        invokeMethod("onAdViewClicked")
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
        bannerView.destroy()
        result.success()
    }

}