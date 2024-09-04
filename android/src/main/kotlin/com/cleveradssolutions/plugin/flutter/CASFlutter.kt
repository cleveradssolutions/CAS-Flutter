package com.cleveradssolutions.plugin.flutter

import ManagerBuilderMethodHandler
import android.app.Activity
import com.cleveradssolutions.plugin.flutter.bannerview.BannerViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class CASFlutter : FlutterPlugin, ActivityAware {

    private var methodHandlers: Set<MethodHandler> = emptySet()

    private var activity: Activity? = null

    private var casBridge: CASBridge? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val consentFlowMethodHandler = ConsentFlowMethodHandler { activity }
        methodHandlers = setOf(
            consentFlowMethodHandler,
            AdsSettingsMethodHandler(),
            BannerMethodHandler { casBridge },
            CASMethodHandler { activity },
            ManagerBuilderMethodHandler(consentFlowMethodHandler, { activity }, { casBridge = it }),
            MediationManagerMethodHandler {casBridge},
            TargetingOptionsMethodHandler()
        )
        methodHandlers.forEach { it.onAttachedToEngine(flutterPluginBinding) }

        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory(
                "<cas-banner-view>",
                BannerViewFactory(flutterPluginBinding.binaryMessenger) { casBridge }
            )
    }

    override fun onDetachedFromEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodHandlers.forEach { it.onDetachedFromEngine() }
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
