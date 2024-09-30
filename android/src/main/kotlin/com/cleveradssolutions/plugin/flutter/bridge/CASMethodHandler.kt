package com.cleveradssolutions.plugin.flutter.bridge

import android.app.Activity
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.errorArgNull
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleversolutions.ads.android.CAS
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val LOG_TAG = "CASMethodHandler"
private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/cas"

class CASMethodHandler(
    private val activityProvider: () -> Activity?
) : MethodHandler(CHANNEL_NAME) {

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
        val activity = activityProvider() ?: return result.errorArgNull(call, "activity")
        CAS.validateIntegration(activity)
        result.success()
    }

}