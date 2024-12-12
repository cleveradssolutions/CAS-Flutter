package com.cleveradssolutions.plugin.flutter.appopen

import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleversolutions.ads.CASAppOpen
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/app_open"

class AppOpenMethodHandler(
    binding: FlutterPluginBinding,
    private val contextService: CASFlutterContext
) : MappedMethodHandler<CASAppOpen>(binding, CHANNEL_NAME) {

    override fun initInstance(id: String): CASAppOpen {
        val appOpen = CASAppOpen.create(id)
        appOpen.contentCallback = ContentCallback(this, id)
        return appOpen
    }

    override fun onMethodCall(
        instance: CASAppOpen,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "load" -> load(instance, result)
            "isLoaded" -> isLoaded(instance, result)
            "show" -> show(instance, call, result)
            else -> super.onMethodCall(instance, call, result)
        }
    }

    private fun load(appOpen: CASAppOpen, result: MethodChannel.Result) {
        appOpen.loadAd(contextService.getContext(), LoadCallback(this, appOpen.managerId))

        result.success()
    }

    private fun isLoaded(appOpen: CASAppOpen, result: MethodChannel.Result) {
        result.success(appOpen.isAdAvailable())
    }

    private fun show(appOpen: CASAppOpen, call: MethodCall, result: MethodChannel.Result) {
        val activity = contextService.getActivityOrError(call, result) ?: return

        appOpen.show(activity)

        result.success()
    }

}