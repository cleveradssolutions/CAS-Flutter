package com.cleveradssolutions.plugin.flutter.bridge

import android.app.Activity
import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleveradssolutions.plugin.flutter.CASBridgeBuilder
import com.cleveradssolutions.plugin.flutter.CASInitCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.getArgAndCheckNull
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/manager_builder"

class ManagerBuilderMethodHandler(
    binding: FlutterPluginBinding,
    private val consentFlowMethodHandler: ConsentFlowMethodHandler,
    private val mediationManagerMethodHandler: MediationManagerMethodHandler,
    private val activityProvider: () -> Activity?,
    private val onManagerBuilt: (CASBridge) -> Unit
) : MethodHandler(binding, CHANNEL_NAME) {

    @Volatile
    private var casBridgeBuilder: CASBridgeBuilder? = null

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
        call.getArgAndReturn<Boolean>("isEnabled", result) {
            getCASBridgeBuilder().withTestMode(it)
        }
    }

    private fun setUserId(call: MethodCall, result: MethodChannel.Result) {

        call.getArgAndReturn<String>("userId", result) {
            getCASBridgeBuilder().setUserId(it)
        }
    }

    private fun withMediationExtras(call: MethodCall, result: MethodChannel.Result) {

        call.getArgAndReturn<String, String>("key", "value", result) { key, value ->
            getCASBridgeBuilder().addExtras(key, value)
        }
    }

    private fun build(call: MethodCall, result: MethodChannel.Result) {
        val id = call.getArgAndCheckNull<String>("id", result) ?: return
        val formats = call.getArgAndCheckNull<Int>("formats", result) ?: return
        val version = call.getArgAndCheckNull<String>("version", result) ?: return

        val casBridge = getCASBridgeBuilder().build(
            id, version, formats, consentFlowMethodHandler.getConsentFlow(),
            mediationManagerMethodHandler
        )
        onManagerBuilt(casBridge)

        casBridgeBuilder = null

        result.success()
    }

    private fun getCASBridgeBuilder(): CASBridgeBuilder {
        return casBridgeBuilder ?: synchronized(this) {
            casBridgeBuilder ?: createCASBridgeBuilder()
        }
    }

    private fun createCASBridgeBuilder(): CASBridgeBuilder {
        val listener = CASInitCallback { error, countryCode, isConsentRequired, isTestMode ->
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
        casBridgeBuilder = CASBridgeBuilder(activityProvider, listener)
        return casBridgeBuilder!!
    }

}