package com.cleveradssolutions.plugin.flutter

import android.app.Activity
import android.app.Application
import android.content.ActivityNotFoundException
import android.content.Context
import com.cleveradssolutions.mediation.ContextService
import com.cleveradssolutions.plugin.flutter.util.errorFieldNull
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class CASFlutterContext(private val application: Context) : ContextService {
    var lastActivity: Activity? = null

    fun getActivityOrError(call: MethodCall, result: MethodChannel.Result): Activity? {
        if (lastActivity == null)
            result.errorFieldNull(call, "lastActivity")
        return lastActivity
    }

    override fun getActivityOrNull(): Activity? = lastActivity
    override fun getActivity(): Activity = lastActivity
        ?: throw ActivityNotFoundException()

    override fun getApplication(): Application = application as? Application
        ?: lastActivity?.application
        ?: throw ActivityNotFoundException()

    override fun getContextOrNull(): Context = application
    override fun getContext(): Context = application
}