package com.cleveradssolutions.plugin.flutter

import android.app.Activity
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

    private var activity: Activity? = null

    private var casBridge: CASBridge? = null

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        val activityProvider = { activity }
        val casBridgeProvider = { casBridge }
        val consentFlowMethodHandler = ConsentFlowMethodHandler(binding, activityProvider)
        val mediationManagerMethodHandler =
            MediationManagerMethodHandler(binding, casBridgeProvider)

        AdSizeMethodHandler(binding)
        AdsSettingsMethodHandler(binding)
        CASMethodHandler(binding, activityProvider)
        ManagerBuilderMethodHandler(
            binding,
            consentFlowMethodHandler,
            mediationManagerMethodHandler,
            activityProvider
        ) { casBridge = it }
        TargetingOptionsMethodHandler(binding)

        binding
            .platformViewRegistry
            .registerViewFactory(
                "<cas-banner-view>",
                BannerViewFactory(binding, casBridgeProvider)
            )
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {}

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

}
