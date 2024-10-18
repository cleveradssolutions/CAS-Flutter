package com.cleveradssolutions.plugin.flutter.bridge

import android.content.Context
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturnResult
import com.cleversolutions.ads.AdSize
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/ad_size"

class AdSizeMethodHandler(
    binding: FlutterPluginBinding
) : MethodHandler(binding, CHANNEL_NAME) {

    private val context: Context = binding.applicationContext

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getInlineBanner" -> getInlineBanner(call, result)
            "getAdaptiveBanner" -> getAdaptiveBanner(call, result)
            "getAdaptiveBannerInScreen" -> getAdaptiveBannerInScreen(result)
            "getSmartBanner" -> getSmartBanner(result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun getInlineBanner(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturnResult<Int, Int>("width", "maxHeight", result) { width, maxHeight ->
            AdSize.getInlineBanner(width, maxHeight).toMap()
        }
    }

    private fun getAdaptiveBanner(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturnResult<Int, Int>(
            "maxWidthDp", "orientation", result
        ) { maxWidthDp, orientation ->
            AdSize.getAdaptiveBanner(context, maxWidthDp, orientation).toMap()
        }
    }

    private fun getAdaptiveBannerInScreen(result: MethodChannel.Result) {
        result.success(
            AdSize.getAdaptiveBannerInScreen(context).toMap()
        )
    }

    private fun getSmartBanner(result: MethodChannel.Result) {
        result.success(
            AdSize.getSmartBanner(context).toMap()
        )
    }

    private fun AdSize.toMap(): Map<String, Int> {
        return mapOf(
            "width" to width,
            "height" to height,
            "mode" to when {
                isAdaptive -> 2
                isInline -> 3
                else -> 0
            }
        )
    }

}