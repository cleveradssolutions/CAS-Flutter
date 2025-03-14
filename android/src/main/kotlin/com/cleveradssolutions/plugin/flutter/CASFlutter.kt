package com.cleveradssolutions.plugin.flutter

import com.cleveradssolutions.plugin.flutter.bannerview.BannerViewFactory
import com.cleveradssolutions.plugin.flutter.bridge.AdSizeMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.AdsSettingsMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.CASMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.ConsentFlowMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.TargetingOptionsMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.manager.ManagerBuilderMethodHandler
import com.cleveradssolutions.plugin.flutter.bridge.manager.MediationManagerMethodHandler
import com.cleveradssolutions.plugin.flutter.sdk.AdContentInfoHandler
import com.cleveradssolutions.plugin.flutter.sdk.screen.AppOpenMethodHandler
import com.cleveradssolutions.plugin.flutter.sdk.screen.InterstitialMethodHandler
import com.cleveradssolutions.plugin.flutter.sdk.screen.RewardedMethodHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class CASFlutter : FlutterPlugin, ActivityAware {
    private var contextService: CASFlutterContext? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        val context = CASFlutterContext(binding.applicationContext)
        contextService = context

        val adContentInfoHandler = AdContentInfoHandler(binding)
        val consentFlowMethodHandler = ConsentFlowMethodHandler(binding, context)
        val mediationManagerMethodHandler = MediationManagerMethodHandler(binding, context)

        AdSizeMethodHandler(binding, context)
        AdsSettingsMethodHandler(binding)
        AppOpenMethodHandler(binding, context, adContentInfoHandler)
        CASMethodHandler(binding, context)
        InterstitialMethodHandler(binding, context, adContentInfoHandler)
        ManagerBuilderMethodHandler(
            binding,
            context,
            consentFlowMethodHandler,
            mediationManagerMethodHandler
        )
        RewardedMethodHandler(binding, context, adContentInfoHandler)
        TargetingOptionsMethodHandler(binding)

        val bannerViewFactory = BannerViewFactory(binding, mediationManagerMethodHandler)
        binding
            .platformViewRegistry
            .registerViewFactory("<cas-banner-view>", bannerViewFactory)
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
