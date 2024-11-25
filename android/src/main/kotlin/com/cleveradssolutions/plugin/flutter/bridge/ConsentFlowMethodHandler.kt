package com.cleveradssolutions.plugin.flutter.bridge

import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleversolutions.ads.ConsentFlow
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/consent_flow"

class ConsentFlowMethodHandler(
    binding: FlutterPluginBinding,
    private val contextService: CASFlutterContext
) : MappedMethodHandler<ConsentFlow>(binding, CHANNEL_NAME) {

    override fun initInstance(id: String): ConsentFlow =
        ConsentFlow()
            .withUIContext(contextService.getActivityOrNull())
            .withDismissListener(createDismissListener(id))

    override fun onMethodCall(
        instance: ConsentFlow,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "withPrivacyPolicy" -> withPrivacyPolicy(instance, call, result)
            "disable" -> disable(instance, result)
            "show" -> show(instance, call, result)
            else -> super.onMethodCall(instance, call, result)
        }
    }

    private fun withPrivacyPolicy(
        consentFlow: ConsentFlow,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<String>("url", result) { url ->
            consentFlow.withPrivacyPolicy(url)
        }
    }

    private fun disable(consentFlow: ConsentFlow, result: MethodChannel.Result) {
        consentFlow.isEnabled = false
        result.success()
    }

    private fun show(consentFlow: ConsentFlow, call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Boolean>("force", result) { force ->
            consentFlow.run { if (force) show() else showIfRequired() }
        }
    }

    private fun createDismissListener(id: String): ConsentFlow.OnDismissListener {
        return ConsentFlow.OnDismissListener { status ->
            invokeMethod(id, "onDismiss", "status" to status)
        }
    }

}