package com.cleveradssolutions.plugin.flutter.bridge

import android.app.Activity
import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleveradssolutions.plugin.flutter.CASBridgeBuilder
import com.cleveradssolutions.plugin.flutter.CASInitCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.error
import com.cleveradssolutions.plugin.flutter.util.getArgAndCheckNull
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/manager_builder"

class ManagerBuilderMethodHandler(
    private val consentFlowMethodHandler: ConsentFlowMethodHandler,
    private val mediationManagerMethodHandler: MediationManagerMethodHandler,
    private val activityProvider: () -> Activity?,
    private val onManagerBuilt: (CASBridge) -> Unit
) : MethodHandler(CHANNEL_NAME) {

    private var initializationCallbackWrapper: CASInitCallback? = null

    private var casBridgeBuilder: CASBridgeBuilder? = null

    override fun onAttachedToFlutter(flutterPluginBinding: FlutterPluginBinding) {
        super.onAttachedToFlutter(flutterPluginBinding)
        initializationCallbackWrapper = createInitializationCallback()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "withTestAdMode" -> withTestAdMode(call, result)
            "withUserId" -> setUserId(call, result)
            "withMediationExtras" -> withMediationExtras(call, result)
            "build" -> build(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun withTestAdMode(call: MethodCall, result: MethodChannel.Result) {
        val builder = getCASBridgeBuilder(call, result) ?: return

        call.getArgAndReturn<Boolean>("isEnabled", result) {
            builder.withTestMode(it)
        }
    }

    private fun setUserId(call: MethodCall, result: MethodChannel.Result) {
        val builder = getCASBridgeBuilder(call, result) ?: return

        call.getArgAndReturn<String>("userId", result) {
            builder.setUserId(it)
        }
    }

    private fun withMediationExtras(call: MethodCall, result: MethodChannel.Result) {
        val builder = getCASBridgeBuilder(call, result) ?: return

        call.getArgAndReturn<String, String>("key", "value", result) { key, value ->
            builder.addExtras(key, value)
        }
    }

    private fun build(call: MethodCall, result: MethodChannel.Result) {
        val builder = getCASBridgeBuilder(call, result) ?: return

        val id = call.getArgAndCheckNull<String>("id", result) ?: return
        val formats = call.getArgAndCheckNull<Int>("formats", result) ?: return
        val version = call.getArgAndCheckNull<String>("version", result) ?: return

        val casBridge =
            builder.build(
                id, version, formats, consentFlowMethodHandler.getConsentFlow(),
                mediationManagerMethodHandler
            )
        onManagerBuilt(casBridge)

        casBridgeBuilder = null

        result.success()
    }

    private fun createInitializationCallback(): CASInitCallback {
        return CASInitCallback { error, countryCode, isConsentRequired, isTestMode ->
            invokeMethod(
                "onCASInitialized",
                mapOf(
                    "error" to error,
                    "countryCode" to countryCode,
                    "isConsentRequired" to isConsentRequired,
                    "testMode" to isTestMode
                )
            )
        }
    }

    private fun getCASBridgeBuilder(
        call: MethodCall,
        result: MethodChannel.Result
    ): CASBridgeBuilder? {
        var builder = casBridgeBuilder
        if (builder == null) {
            val activity = activityProvider()
            if (activity != null) {
                builder = CASBridgeBuilder(activity)
                builder.setInitializationListener(initializationCallbackWrapper)
                casBridgeBuilder = builder
            } else {
                result.error(
                    call,
                    "Failed to create CASBridgeBuilder because activity is null"
                )
            }
        }
        return builder
    }

}