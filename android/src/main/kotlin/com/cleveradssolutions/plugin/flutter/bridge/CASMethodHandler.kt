package com.cleveradssolutions.plugin.flutter.bridge

import android.app.Activity
import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.errorArgNull
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleversolutions.ads.android.CAS
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/cas"

class CASMethodHandler(
    binding: FlutterPluginBinding,
    private val contextService: CASFlutterContext
) : MethodHandler(binding, CHANNEL_NAME) {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getSDKVersion" -> getSDKVersion(result)
            "validateIntegration" -> validateIntegration(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun getSDKVersion(result: MethodChannel.Result) {
        result.success(CAS.getSDKVersion())
    }

    private fun validateIntegration(call: MethodCall, result: MethodChannel.Result) {
        val activity = contextService.getActivityOrError(call, result) ?: return
        CAS.validateIntegration(activity)
        result.success()
    }

}