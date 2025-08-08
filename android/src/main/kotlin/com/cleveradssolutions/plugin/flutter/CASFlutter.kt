package com.cleveradssolutions.plugin.flutter

import com.cleveradssolutions.plugin.flutter.banner.BannerViewFactory
import com.cleveradssolutions.plugin.flutter.bridge.AdSizeMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.AdsSettingsMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.CASMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.ConsentFlowMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.TargetingOptionsMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.manager.ManagerBuilderMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.manager.MediationManagerMethodHandler
import com.cleveradssolutions.plugin.flutter.screen.AppOpenMethodHandler
import com.cleveradssolutions.plugin.flutter.screen.InterstitialMethodHandler
import com.cleveradssolutions.plugin.flutter.screen.RewardedMethodHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

const val CAS_LOG_TAG = "CAS.AI.Flutter"

class CASFlutter : FlutterPlugin, ActivityAware {
    private var contextService: CASFlutterContext? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        val context = CASFlutterContext(binding.applicationContext)
        contextService = context

        val contentInfoHandler = AdContentInfoMethodHandler(binding)
        val consentFlowMethodHandler = ConsentFlowMethodHandler(binding)
        val mediationManagerMethodHandler = MediationManagerMethodHandler(binding, context)

        AdSizeMethodHandler(binding, context)
        AdsSettingsMethodHandler(binding)
        AppOpenMethodHandler(binding, context, contentInfoHandler)
        CASMethodHandler(binding, context)
        InterstitialMethodHandler(binding, context, contentInfoHandler)
        ManagerBuilderMethodHandler(
            binding,
            context,
            consentFlowMethodHandler,
            mediationManagerMethodHandler
        )
        RewardedMethodHandler(binding, context, contentInfoHandler)
        TargetingOptionsMethodHandler(binding)

        val bannerViewFactory = BannerViewFactory(binding, contentInfoHandler)
        binding
            .platformViewRegistry
            .registerViewFactory("<cas-banner-view>", bannerViewFactory)
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        contextService?.activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        contextService?.activity = null
    }

}
