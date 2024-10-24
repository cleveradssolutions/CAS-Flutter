package com.cleveradssolutions.plugin.flutter

import com.cleveradssolutions.plugin.flutter.bannerview.BannerViewFactory
import com.cleveradssolutions.plugin.flutter.bridge.AdSizeMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.AdsSettingsMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.CASMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.ConsentFlowMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.ManagerBuilderMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.MediationManagerMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.TargetingOptionsMethodHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class CASFlutter : FlutterPlugin, ActivityAware {
    private var contextService: CASFlutterContext? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        val context = CASFlutterContext(binding.applicationContext)
        contextService = context

        val consentFlowMethodHandler = ConsentFlowMethodHandler(binding, context)
        val mediationManagerMethodHandler = MediationManagerMethodHandler(binding, context)

        AdSizeMethodHandler(binding)
        AdsSettingsMethodHandler(binding)
        CASMethodHandler(binding, context)
        ManagerBuilderMethodHandler(
            binding,
            consentFlowMethodHandler,
            mediationManagerMethodHandler,
            context
        )
        TargetingOptionsMethodHandler(binding)

        binding
            .platformViewRegistry
            .registerViewFactory(
                "<cas-banner-view>",
                BannerViewFactory(binding, mediationManagerMethodHandler)
            )
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        contextService?.lastActivity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        contextService?.lastActivity = null
    }

}
