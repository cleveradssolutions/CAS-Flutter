package com.cleveradssolutions.plugin.flutter.bridge

import android.app.Activity
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleversolutions.ads.ConsentFlow
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/consent_flow"

class ConsentFlowMethodHandler(
    private val activityProvider: () -> Activity?
) : MethodHandler(CHANNEL_NAME) {

    private var consentFlow: ConsentFlow? = null
    private var consentFlowDismissListener: ConsentFlow.OnDismissListener? = null

    override fun onAttachedToFlutter(flutterPluginBinding: FlutterPluginBinding) {
        super.onAttachedToFlutter(flutterPluginBinding)
        consentFlowDismissListener = ConsentFlow.OnDismissListener { status ->
            invokeMethod(
                "OnDismissListener",
                mapOf("status" to status)
            )
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "withPrivacyPolicy" -> withPrivacyPolicy(call, result)
            "disable" -> disable(result)
            "show" -> show(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    fun getConsentFlow(): ConsentFlow {
        return consentFlow ?: ConsentFlow()
            .withUIContext(activityProvider())
            .withDismissListener(consentFlowDismissListener)
            .also { consentFlow = it }
    }

    private fun withPrivacyPolicy(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<String>("url", result) {
            getConsentFlow().withPrivacyPolicy(it)
        }
    }

    private fun disable(result: MethodChannel.Result) {
        getConsentFlow().isEnabled = false
        result.success()
    }

    private fun show(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Boolean>("force", result) { force ->
            getConsentFlow().let {
                if (force) it.show() else it.showIfRequired()
            }
        }
    }

}