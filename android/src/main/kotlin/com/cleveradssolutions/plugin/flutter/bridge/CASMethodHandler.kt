package com.cleveradssolutions.plugin.flutter.bridge

import com.cleveradssolutions.plugin.flutter.CASChannel
import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.success
import com.cleversolutions.ads.android.CAS
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/cas"

class CASMethodHandler(
    binding: FlutterPluginBinding,
    private val contextService: CASFlutterContext
) : CASChannel(binding, CHANNEL_NAME) {

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