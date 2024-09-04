package com.cleveradssolutions.plugin.flutter

import android.app.Activity
import com.cleversolutions.ads.ConsentFlow
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/consent_flow"

class ConsentFlowMethodHandler(
    private val activityProvider: () -> Activity?
) : MethodHandler(CHANNEL_NAME) {

    private var consentFlow: ConsentFlow? = null
    private var consentFlowDismissListener: ConsentFlow.OnDismissListener? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        super.onAttachedToEngine(flutterPluginBinding)
        consentFlowDismissListener = ConsentFlow.OnDismissListener { status ->
            invokeMethod(
                "OnDismissListener",
                mapOf("status" to status)
            )
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "withPrivacyPolicy" -> withPrivacyPolicy(call, result)
            "disableConsentFlow" -> disableConsentFlow(result)
            "showConsentFlow" -> showConsentFlow(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun withPrivacyPolicy(call: MethodCall, result: Result) {
        tryGetArgSetValue<String>("url", call, result) {
            getConsentFlow().withPrivacyPolicy(it)
        }
    }

    private fun disableConsentFlow(result: Result) {
        getConsentFlow().isEnabled = false
        result.success(null)
    }

    private fun showConsentFlow(call: MethodCall, result: Result) {
        tryGetArgSetValue<Boolean>("force", call, result) { force ->
            getConsentFlow().let {
                if (force) it.show() else it.showIfRequired()
            }
        }
    }

    fun getConsentFlow(): ConsentFlow {
        return consentFlow ?: ConsentFlow()
            .withUIContext(activityProvider())
            .withDismissListener(consentFlowDismissListener)
            .also { consentFlow = it }
    }

}