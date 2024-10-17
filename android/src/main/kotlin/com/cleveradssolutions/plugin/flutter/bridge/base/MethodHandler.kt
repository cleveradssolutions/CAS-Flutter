package com.cleveradssolutions.plugin.flutter.bridge.base

import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.AnyThread
import androidx.annotation.CallSuper
import androidx.annotation.MainThread
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val LOG_TAG = "MethodHandler"

abstract class MethodHandler(
    private val channelName: String
) : MethodChannel.MethodCallHandler {

    private var channel: MethodChannel? = null

    @CallSuper
    @MainThread
    open fun onAttachedToFlutter(flutterPluginBinding: FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName).also {
            it.setMethodCallHandler(this)
        }
    }

    @CallSuper
    @MainThread
    open fun onDetachedFromFlutter() {
        channel?.let {
            it.setMethodCallHandler(null)
            channel = null
        }
    }

    @AnyThread
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.e(LOG_TAG, "Unknown method '${call.method}' in '$channelName'")
        result.notImplemented()
    }

    fun invokeMethod(methodName: String, args: Map<String, Any?>? = null) {
        Handler(Looper.getMainLooper()).post {
            channel?.invokeMethod(methodName, args, object : MethodChannel.Result {
                override fun success(result: Any?) {}

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.e(
                        LOG_TAG,
                        "Error: invokeMethod '$methodName' failed, errorCode: $errorCode, message: $errorMessage, details: $errorDetails"
                    )
                }

                override fun notImplemented() {
                    Log.e(LOG_TAG, "Critical Error: invokeMethod '$methodName' notImplemented")
                }
            })
        }
    }

}