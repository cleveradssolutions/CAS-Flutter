package com.cleveradssolutions.plugin.flutter.bannerview

import android.content.Context
import com.cleveradssolutions.plugin.flutter.bridge.base.AdMethodHandler
import com.cleveradssolutions.plugin.flutter.sdk.AdContentInfoHandler
import com.cleveradssolutions.plugin.flutter.util.errorArgNull
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleversolutions.ads.AdSize
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/banner"

class BannerMethodHandler(
    binding: FlutterPluginBinding,
    contentInfoHandler: AdContentInfoHandler
) : AdMethodHandler<BannerView>(binding, CHANNEL_NAME, contentInfoHandler) {

    override fun onMethodCall(
        instance: Ad<BannerView>,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "getCASId" -> getCASId(instance.ad.view, result)
            "setCASId" -> setCASId(instance.ad.view, call, result)
            "setSize" -> setSize(instance.ad.view, call, result)
            "isLoaded" -> isLoaded(instance.ad.view, result)
            "getContentInfo" -> getContentInfo(instance.contentInfoId, result)
            "isAutoloadEnabled" -> isAutoloadEnabled(instance.ad.view, result)
            "setAutoloadEnabled" -> setAutoloadEnabled(instance.ad.view, call, result)
            "load" -> load(instance.ad.view, result)
            "getRefreshInterval" -> getRefreshInterval(instance.ad.view, result)
            "setRefreshInterval" -> setRefreshInterval(instance.ad.view, call, result)
            "disableAdRefresh" -> disableAdRefresh(instance.ad.view, result)
            "dispose" -> dispose(instance, result)
            else -> super.onMethodCall(instance, call, result)
        }
    }

    private fun getCASId(bannerView: CASBannerView, result: MethodChannel.Result) {
        result.success(bannerView.casId)
    }

    private fun setCASId(
        bannerView: CASBannerView,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<String>("casId", result) {
            bannerView.casId = it
        }
    }

    private fun setSize(
        bannerView: CASBannerView,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        val map = call.arguments as? Map<*, *> ?: return result.errorArgNull(call, "arguments")
        val adSize = parseSize(bannerView.context, map)
        bannerView.size = adSize

        result.success()
    }

    private fun isLoaded(bannerView: CASBannerView, result: MethodChannel.Result) {
        result.success(bannerView.isLoaded)
    }

    private fun getContentInfo(contentInfoId: String, result: MethodChannel.Result) {
        result.success(contentInfoId)
    }

    private fun isAutoloadEnabled(bannerView: CASBannerView, result: MethodChannel.Result) {
        result.success(bannerView.isAutoloadEnabled)
    }

    private fun setAutoloadEnabled(
        bannerView: CASBannerView,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<Boolean>("isEnabled", result) {
            bannerView.isAutoloadEnabled = it
        }
    }

    private fun load(bannerView: CASBannerView, result: MethodChannel.Result) {
        bannerView.load()
        result.success()
    }

    private fun getRefreshInterval(bannerView: CASBannerView, result: MethodChannel.Result) {
        result.success(bannerView.refreshInterval)
    }

    private fun setRefreshInterval(
        bannerView: CASBannerView,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<Int>("interval", result) {
            bannerView.refreshInterval = it
        }
    }

    private fun disableAdRefresh(bannerView: CASBannerView, result: MethodChannel.Result) {
        bannerView.disableAdRefresh()
        result.success()
    }

    private fun dispose(ad: Ad<BannerView>, result: MethodChannel.Result) {
        destroy(ad)
        ad.ad.view.destroy()

        result.success()
    }

    companion object {
        fun parseSize(context: Context, size: Map<*, *>): AdSize {
            if (size["isAdaptive"] == true) {
                return (size["maxWidthDpi"] as? Int).let {
                    if (it == null || it == 0) {
                        AdSize.getAdaptiveBannerInScreen(context)
                    } else {
                        AdSize.getAdaptiveBanner(context, it)
                    }
                }
            } else {
                val width = size["width"] as Int
                val height = size["height"] as Int
                val mode = size["mode"] as Int

                return when (mode) {
                    2 -> AdSize.getAdaptiveBanner(context, width)
                    3 -> AdSize.getInlineBanner(width, height)
                    else -> when (width) {
                        300 -> AdSize.MEDIUM_RECTANGLE
                        728 -> AdSize.LEADERBOARD
                        else -> AdSize.BANNER
                    }
                }
            }
        }
    }

}