package com.cleveradssolutions.plugin.flutter.bannerview

import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/banner"

class BannerMethodHandler(binding: FlutterPluginBinding) :
    MappedMethodHandler<BannerView>(binding, CHANNEL_NAME) {

    override fun onMethodCall(
        instance: BannerView,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "isAdReady" -> isAdReady(instance.view, result)
            "loadNextAd" -> loadNextAd(instance.view, result)
            "setBannerAdRefreshRate" -> setBannerAdRefreshRate(instance.view, call, result)
            "disableBannerRefresh" -> disableBannerRefresh(instance.view, result)
            "dispose" -> dispose(instance, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun isAdReady(bannerView: CASBannerView, result: MethodChannel.Result) {
        result.success(bannerView.isAdReady)
    }

    private fun loadNextAd(bannerView: CASBannerView, result: MethodChannel.Result) {
        bannerView.loadNextAd()
        result.success()
    }

    private fun setBannerAdRefreshRate(
        bannerView: CASBannerView,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<Int>("refresh", result) {
            bannerView.refreshInterval = it
        }
    }

    private fun disableBannerRefresh(bannerView: CASBannerView, result: MethodChannel.Result) {
        bannerView.disableAdRefresh()
        result.success()
    }

    private fun dispose(bannerView: BannerView, result: MethodChannel.Result) {
        bannerView.view.destroy()
        remove(bannerView.id)
        result.success()
    }

}