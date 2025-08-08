package com.cleveradssolutions.plugin.flutter

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CASFlutterContext(val application: Context) {
    var activity: Activity? = null

    fun getActivityOrError(call: MethodCall, result: MethodChannel.Result): Activity? {
        if (activity == null)
            result.errorFieldNull(call, "lastActivity")
        return activity
    }
}