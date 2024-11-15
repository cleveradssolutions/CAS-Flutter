package com.cleveradssolutions.plugin.flutter.bridge

import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.bridge.base.FlutterObjectFactory
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleversolutions.ads.ConsentFlow
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/consent_flow"

class ConsentFlowMethodHandler private constructor(
    binding: FlutterPluginBinding,
    private val contextService: CASFlutterContext,
    id: String
) : MethodHandler(binding, "$CHANNEL_NAME.$id") {

    class Factory(
        private val binding: FlutterPluginBinding,
        private val contextService: CASFlutterContext
    ) : FlutterObjectFactory<ConsentFlowMethodHandler>(binding, CHANNEL_NAME) {
        override fun initInstance(id: String): ConsentFlowMethodHandler =
            ConsentFlowMethodHandler(binding, contextService, id)
    }

    private var consentFlowField: ConsentFlow? = null
    val consentFlow: ConsentFlow
        get() = consentFlowField ?: ConsentFlow()
            .withUIContext(contextService.getActivityOrNull())
            .withDismissListener(createDismissListener())
            .also { consentFlowField = it }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "withPrivacyPolicy" -> withPrivacyPolicy(call, result)
            "disable" -> disable(result)
            "show" -> show(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun withPrivacyPolicy(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<String>("url", result) {
            consentFlow.withPrivacyPolicy(it)
        }
    }

    private fun disable(result: MethodChannel.Result) {
        consentFlow.isEnabled = false
        result.success()
    }

    private fun show(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Boolean>("force", result) { force ->
            consentFlow.run { if (force) show() else showIfRequired() }
        }
    }

    private fun createDismissListener(): ConsentFlow.OnDismissListener {
        return ConsentFlow.OnDismissListener { status ->
            invokeMethod("OnDismissListener", status)
        }
    }

}