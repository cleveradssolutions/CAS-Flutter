package com.cleveradssolutions.plugin.flutter.bridge.manager

import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.bridge.ConsentFlowMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
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
    private val consentFlowMethodHandler: ConsentFlowMethodHandler,
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
            "withUserId" -> setUserId(call, result)
            "withMediationExtras" -> withMediationExtras(call, result)
            "build" -> build(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun withTestAdMode(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<Boolean>("isEnabled", result) {
            builder.withTestAdMode(it)
        }
    }

    private fun setUserId(call: MethodCall, result: MethodChannel.Result) {
        call.getArgAndReturn<String>("userId", result) {
            builder.withUserID(it)
        }
    }

    private fun withMediationExtras(call: MethodCall, result: MethodChannel.Result) {

        call.getArgAndReturn<String, String>("key", "value", result) { key, value ->
            builder.withMediationExtras(key, value)
        }
    }

    private fun build(call: MethodCall, result: MethodChannel.Result) {
        val id = call.getArgAndCheckNull<String>("id", result) ?: return
        val formats = call.getArgAndCheckNull<Int>("formats", result) ?: return
        val version = call.getArgAndCheckNull<String>("version", result) ?: return

        val manager = builder.withEnabledAdTypes(formats)
            .withCasId(id)
            .withFramework("Flutter", version)
            .withConsentFlow(consentFlowMethodHandler.getConsentFlow())
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

        result.success()
    }
}