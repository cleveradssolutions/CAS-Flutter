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
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class CASFlutter : FlutterPlugin, ActivityAware {

    private var methodHandlers: Set<MethodHandler> = emptySet()

    private var activity: Activity? = null

    private var casBridge: CASBridge? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        val activityProvider = { activity }
        val casBridgeProvider = { casBridge }
        val consentFlowMethodHandler = ConsentFlowMethodHandler(activityProvider)
        val mediationManagerMethodHandler = MediationManagerMethodHandler(casBridgeProvider)

        methodHandlers = setOf(
            AdSizeMethodHandler(),
            AdsSettingsMethodHandler(),
            CASMethodHandler(activityProvider),
            consentFlowMethodHandler,
            ManagerBuilderMethodHandler(
                consentFlowMethodHandler,
                mediationManagerMethodHandler,
                activityProvider
            ) { casBridge = it },
            mediationManagerMethodHandler,
            TargetingOptionsMethodHandler()
        )

        methodHandlers.forEach { it.onAttachedToFlutter(flutterPluginBinding) }

        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory(
                "<cas-banner-view>",
                BannerViewFactory(flutterPluginBinding, casBridgeProvider)
            )
    }

    override fun onDetachedFromEngine(flutterPluginBinding: FlutterPluginBinding) {
        methodHandlers.forEach { it.onDetachedFromFlutter() }
        methodHandlers = emptySet()
    }

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
