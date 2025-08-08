package com.cleveradssolutions.plugin.flutter

import android.util.Log
import androidx.annotation.AnyThread
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.HashMap

abstract class CASChannel(
    binding: FlutterPluginBinding,
    private val name: String
) : MethodChannel.MethodCallHandler {

    private val channel = MethodChannel(binding.binaryMessenger, name)

    init {
        @Suppress("LeakingThis")
        channel.setMethodCallHandler(this)
    }

    @AnyThread
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.e(CAS_LOG_TAG, "Unknown method '${call.method}' in '$name'")
        result.notImplemented()
    }

    fun invokeMethod(
        methodName: String,
        args: HashMap<String, Any?>? = null,
        callback: MethodChannel.Result? = null
    ) {
        channel.invokeMethod(methodName, args, callback)
    }

    fun invokeMethod(
        methodName: String,
        args: String,
        callback: MethodChannel.Result? = null
    ) {
        channel.invokeMethod(methodName, args, callback)
    }
}