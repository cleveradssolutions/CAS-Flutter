package com.cleveradssolutions.plugin.flutter.bridge.manager

import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.bridge.ConsentFlowMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.errorFieldNull
import com.cleveradssolutions.plugin.flutter.util.getArgAndCheckNull
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleversolutions.ads.android.CAS
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/manager_builder"

class ManagerBuilderMethodHandler(
    binding: FlutterPluginBinding,
    private val consentFlowFactory: ConsentFlowMethodHandler.Factory,
    private val mediationManagerMethodHandler: MediationManagerMethodHandler,
    private val contextService: CASFlutterContext
) : MethodHandler(binding, CHANNEL_NAME) {

    @Volatile
    private var builderField: CAS.ManagerBuilder? = null
    private val builder: CAS.ManagerBuilder
        get() {
            builderField?.let { return it }
            val instance = CAS.buildManager()
            builderField = instance
            return instance
        }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "withTestAdMode" -> withTestAdMode(call, result)
            "withAdTypes" -> withAdTypes(call, result)
            "withUserId" -> setUserId(call, result)
            "withConsentFlow" -> withConsentFlow(call, result)
            "withMediationExtras" -> withMediationExtras(call, result)
            "withFramework" -> withFramework(call, result)
            "build" -> build(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun withTestAdMode(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Boolean>("isEnabled", result) {
            builder.withTestAdMode(it)
        }
    }

    private fun withAdTypes(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Int>("adTypes", result) {
            builder.withEnabledAdTypes(it)
        }
    }

    private fun setUserId(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<String>("userId", result) {
            builder.withUserID(it)
        }
    }

    private fun withConsentFlow(call: MethodCall, result: MethodChannel.Result) {
        val id = call.getArgAndCheckNull<String>("id", result) ?: return
        val consentFlowMethodHandler = consentFlowFactory[id]
            ?: return result.errorFieldNull(call, "consentFlow")

        builder.withConsentFlow(consentFlowMethodHandler.consentFlow)

        result.success()
    }

    private fun withMediationExtras(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<String, String>("key", "value", result) { key, value ->
            builder.withMediationExtras(key, value)
        }
    }

    private fun withFramework(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<String>("pluginVersion", result) {
            builder.withFramework("Flutter", it)
        }
    }

    private fun build(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<String>("id", result) {
            val manager = builder
                .withCasId(it)
                .withCompletionListener { config ->
                    invokeMethod(
                        "onCASInitialized",
                        mapOf(
                            "error" to config.error,
                            "countryCode" to config.countryCode,
                            "isConsentRequired" to config.isConsentRequired,
                            "testMode" to config.manager.isDemoAdMode
                        )
                    )
                }
                .initialize(contextService)

            mediationManagerMethodHandler.setManager(manager)

            builderField = null
        }
    }
}