package com.cleveradssolutions.plugin.flutter.bridge.base

import android.util.Log
import androidx.annotation.AnyThread
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val LOG_TAG = "MethodHandler"

abstract class MethodHandler(
    binding: FlutterPluginBinding,
    private val channelName: String
) : MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(binding.binaryMessenger, channelName)

    init {
        Log.e("DevDebug", "register channel $channelName")
        @Suppress("LeakingThis")
        channel.setMethodCallHandler(this)
    }

    @AnyThread
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.e(LOG_TAG, "Unknown method '${call.method}' in '$channelName'")
        result.notImplemented()
    }

    fun invokeMethod(methodName: String, args: Any? = null) {
        channel.invokeMethod(methodName, args, null)
    }

}