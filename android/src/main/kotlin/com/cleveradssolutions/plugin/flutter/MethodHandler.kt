package com.cleveradssolutions.plugin.flutter

import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.AnyThread
import androidx.annotation.CallSuper
import androidx.annotation.MainThread
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result

private const val LOG_TAG = "MethodHandler"

abstract class MethodHandler(
    private val channelName: String
) : MethodChannel.MethodCallHandler {

    private var channel: MethodChannel? = null

    @CallSuper
    @MainThread
    open fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelName).also {
            it.setMethodCallHandler(this)
        }
    }

    @CallSuper
    @MainThread
    open fun onDetachedFromEngine() {
        channel?.let {
            it.setMethodCallHandler(null)
            channel = null
        }
    }

    @AnyThread
    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.e(LOG_TAG, "Unknown method '${call.method}' in '$channelName'")
        result.notImplemented()
    }

    fun invokeMethod(methodName: String, args: Map<String, Any?>? = null) {
        Handler(Looper.getMainLooper()).post {
            channel?.invokeMethod(methodName, args, object : Result {
                override fun success(result: Any?) {}

                override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
                    Log.e(
                        LOG_TAG,
                        "Error: invokeMethod '$methodName' failed" +
                                ", errorCode: $errorCode" +
                                ", message: $errorMessage" +
                                ", details: $errorDetails"
                    )
                }

                override fun notImplemented() {
                    Log.e(LOG_TAG, "Critical Error: invokeMethod '$methodName' notImplemented")
                }
            })
        }
    }

}

/**
 * Try get argument from call, do action with it and return action result.
 */
inline fun <T> MethodHandler.tryGetArgReturnResult(
    name: String,
    call: MethodCall,
    result: Result,
    action: (T) -> Any?
) {
    call.argument<T>(name)?.let { result.success(action(it)) }
        ?: result.error(
            "MethodHandler",
            "Method: '${call.method}', arg: '$name' is null",
            null
        )
}

/**
 * Try get argument from call, do action with it and return null.
 */
inline fun <T> MethodHandler.tryGetArgSetValue(
    name: String,
    call: MethodCall,
    result: Result,
    action: (T) -> Unit
) {
    tryGetArgReturnResult<T>(name, call, result) {
        action(it)
        null
    }
}