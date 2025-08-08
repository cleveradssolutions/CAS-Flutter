package com.cleveradssolutions.plugin.flutter.screen

import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.AdMethodHandler
import com.cleveradssolutions.plugin.flutter.AdContentInfoMethodHandler
import com.cleveradssolutions.plugin.flutter.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.success
import com.cleveradssolutions.sdk.screen.CASAppOpen
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/app_open"

class AppOpenMethodHandler(
    binding: FlutterPlugin.FlutterPluginBinding,
    private val contextService: CASFlutterContext,
    contentInfoHandler: AdContentInfoMethodHandler
) : AdMethodHandler<CASAppOpen>(binding, CHANNEL_NAME, contentInfoHandler) {

    override fun initInstance(id: String): Ad<CASAppOpen> {
        val context = contextService.application
        val appOpen = CASAppOpen(context, id)
        val contentInfoId = "app_open_$id"
        val callback = ScreenAdContentCallbackHandler(this, id, contentInfoId)
        appOpen.contentCallback = callback
        appOpen.onImpressionListener = callback
        return Ad(appOpen, id, contentInfoId)
    }

    override fun onMethodCall(
        instance: Ad<CASAppOpen>,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "isAutoloadEnabled" -> isAutoloadEnabled(instance.ad, result)
            "setAutoloadEnabled" -> setAutoloadEnabled(instance.ad, call, result)
            "isAutoshowEnabled" -> isAutoshowEnabled(instance.ad, result)
            "setAutoshowEnabled" -> setAutoshowEnabled(instance.ad, call, result)
            "isLoaded" -> isLoaded(instance.ad, result)
            "getContentInfo" -> getContentInfo(instance.contentInfoId, result)
            "load" -> load(instance.ad, result)
            "show" -> show(instance.ad, result)
            "destroy" -> destroy(instance, result)
            else -> super.onMethodCall(instance, call, result)
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
    }

    private fun isLoaded(appOpen: CASAppOpen, result: MethodChannel.Result) {
        result.success(appOpen.isLoaded)
    }

    private fun getContentInfo(contentInfoId: String, result: MethodChannel.Result) {
        result.success(contentInfoId)
    }

    private fun load(appOpen: CASAppOpen, result: MethodChannel.Result) {
        appOpen.load(contextService.application)

        result.success()
    }

    private fun show(appOpen: CASAppOpen, result: MethodChannel.Result) {
        appOpen.show(contextService.activity)

        result.success()
    }

    private fun destroy(ad: Ad<CASAppOpen>, result: MethodChannel.Result) {
        destroy(ad)
        ad.ad.destroy()

        result.success()
    }

}