package com.cleveradssolutions.plugin.flutter

import android.app.Activity
import com.cleversolutions.ads.android.CAS
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

private const val LOG_TAG = "CASMethodHandler"

class CASMethodHandler(
    private val activityProvider: () -> Activity?
) : MethodHandler {

    override fun onMethodCall(call: MethodCall, result: Result): Boolean {
        when (call.method) {
            "getSDKVersion" -> getSDKVersion(result)
            "validateIntegration" -> validateIntegration(result, activityProvider)
            else -> return false
        }
        return true
    }

    private fun getSDKVersion(result: Result) {
        result.success(CAS.getSDKVersion())
    }

    private fun validateIntegration(result: Result, activityProvider: () -> Activity?) {
        activityProvider()?.let {
            CAS.validateIntegration(it)
            result.success(null)
        } ?: result.error(LOG_TAG, "Method: 'validateIntegration', Activity is null", null)
    }

}