package com.cleveradssolutions.plugin.flutter.bridge

import android.content.Context
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.errorArgNull
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturnResult
import com.cleversolutions.ads.AdSize
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/ad_size"

class AdSizeMethodHandler : MethodHandler(CHANNEL_NAME) {

    private var context: Context? = null

    override fun onAttachedToFlutter(flutterPluginBinding: FlutterPluginBinding) {
        super.onAttachedToFlutter(flutterPluginBinding)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromFlutter() {
        super.onDetachedFromFlutter()
        context = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getInlineBanner" -> getInlineBanner(call, result)
            "getAdaptiveBanner" -> getAdaptiveBanner(call, result)
            "getAdaptiveBannerInScreen" -> getAdaptiveBannerInScreen(call, result)
            "getSmartBanner" -> getSmartBanner(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun getInlineBanner(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturnResult<Int, Int>("width", "maxHeight", result) { width, maxHeight ->
            AdSize.getInlineBanner(width, maxHeight).toMap()
        }
    }

    private fun getAdaptiveBanner(call: MethodCall, result: MethodChannel.Result) {
        val context = getContextAndCheckNull(call, result) ?: return

        call.getArgAndReturnResult<Int, Int>("maxWidthDp", "orientation", result) { maxWidthDp, orientation ->
            AdSize.getAdaptiveBanner(context, maxWidthDp, orientation).toMap()
        }
    }

    private fun getAdaptiveBannerInScreen(call: MethodCall, result: MethodChannel.Result) {
        val context = getContextAndCheckNull(call, result) ?: return

        result.success(
            AdSize.getAdaptiveBannerInScreen(context).toMap()
        )
    }

    private fun getSmartBanner(call: MethodCall, result: MethodChannel.Result) {
        val context = getContextAndCheckNull(call, result) ?: return

        result.success(
            AdSize.getSmartBanner(context).toMap()
        )
    }

    private fun getContextAndCheckNull(call: MethodCall, result: MethodChannel.Result): Context? {
        val context = context
        if (context == null) result.errorArgNull(call, "context")
        return context
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