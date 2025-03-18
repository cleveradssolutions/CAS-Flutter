package com.cleveradssolutions.plugin.flutter.sdk.screen

import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.sdk.AdContentInfoHandler
import com.cleveradssolutions.plugin.flutter.sdk.OnAdImpressionListenerHandler
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleveradssolutions.sdk.screen.CASAppOpen
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/app_open"

class AppOpenMethodHandler(
    binding: FlutterPlugin.FlutterPluginBinding,
    private val contextService: CASFlutterContext,
    private val adContentInfoHandler: AdContentInfoHandler
) : MappedMethodHandler<CASAppOpen>(binding, CHANNEL_NAME) {

    override fun initInstance(id: String): CASAppOpen {
        val context = contextService.getContext()
        val appOpen = CASAppOpen(context, id)
        appOpen.contentCallback = ScreenAdContentCallbackHandler(this, id, adContentInfoHandler)
        appOpen.onImpressionListener = OnAdImpressionListenerHandler(this, id)
        return appOpen
    }

    override fun onMethodCall(
        id: String,
        instance: CASAppOpen,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "isAutoloadEnabled" -> isAutoloadEnabled(instance, result)
            "setAutoloadEnabled" -> setAutoloadEnabled(instance, call, result)
            "isAutoshowEnabled" -> isAutoshowEnabled(instance, result)
            "setAutoshowEnabled" -> setAutoshowEnabled(instance, call, result)
            "isLoaded" -> isLoaded(instance, result)
            "load" -> load(instance, result)
            "show" -> show(instance, result)
            "destroy" -> destroy(id, instance, result)
            else -> super.onMethodCall(id, instance, call, result)
        }
    }

    private fun isAutoloadEnabled(appOpen: CASAppOpen, result: MethodChannel.Result) {
        result.success(appOpen.isAutoloadEnabled)
    }

    private fun setAutoloadEnabled(
        appOpen: CASAppOpen,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<Boolean>("isEnabled", result) {
            appOpen.isAutoloadEnabled = it
        }

        result.success()
    }

    private fun isAutoshowEnabled(appOpen: CASAppOpen, result: MethodChannel.Result) {
        result.success(appOpen.isAutoshowEnabled)
    }

    private fun setAutoshowEnabled(
        appOpen: CASAppOpen,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<Boolean>("isEnabled", result) {
            appOpen.isAutoshowEnabled = it
        }

        result.success()
    }

    private fun isLoaded(appOpen: CASAppOpen, result: MethodChannel.Result) {
        result.success(appOpen.isLoaded)
    }

    private fun load(appOpen: CASAppOpen, result: MethodChannel.Result) {
        appOpen.load(contextService.getContext())

        result.success()
    }

    private fun show(appOpen: CASAppOpen, result: MethodChannel.Result) {
        val activity = contextService.getActivity()

        appOpen.show(activity)

        result.success()
    }

    private fun destroy(id: String, appOpen: CASAppOpen, result: MethodChannel.Result) {
        appOpen.destroy()
        adContentInfoHandler.remove(id)

        result.success()
    }

}