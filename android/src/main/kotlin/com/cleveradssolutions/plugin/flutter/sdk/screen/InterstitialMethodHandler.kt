package com.cleveradssolutions.plugin.flutter.sdk.screen

import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.bridge.base.AdMethodHandler
import com.cleveradssolutions.plugin.flutter.sdk.AdContentInfoHandler
import com.cleveradssolutions.plugin.flutter.sdk.OnAdImpressionListenerHandler
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleveradssolutions.sdk.screen.CASInterstitial
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/interstitial"

class InterstitialMethodHandler(
    binding: FlutterPlugin.FlutterPluginBinding,
    private val contextService: CASFlutterContext,
    contentInfoHandler: AdContentInfoHandler
) : AdMethodHandler<CASInterstitial>(binding, CHANNEL_NAME, contentInfoHandler) {

    override fun initInstance(id: String): Ad<CASInterstitial> {
        val context = contextService.getContext()
        val interstitial = CASInterstitial(context, id)
        val contentInfoId = "interstitial_$id"
        interstitial.contentCallback = ScreenAdContentCallbackHandler(this, id, contentInfoId)
        interstitial.onImpressionListener = OnAdImpressionListenerHandler(this, id, contentInfoId)
        return Ad(interstitial, id, contentInfoId)
    }

    override fun onMethodCall(
        instance: Ad<CASInterstitial>,
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
            "getMinInterval" -> getMinInterval(instance.ad, result)
            "setMinInterval" -> setMinInterval(instance.ad, call, result)
            "restartInterval" -> restartInterval(instance.ad, result)
            else -> super.onMethodCall(instance, call, result)
        }
    }

    private fun isAutoloadEnabled(interstitial: CASInterstitial, result: MethodChannel.Result) {
        result.success(interstitial.isAutoloadEnabled)
    }

    private fun setAutoloadEnabled(
        interstitial: CASInterstitial,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<Boolean>("isEnabled", result) {
            interstitial.isAutoloadEnabled = it
        }

        result.success()
    }

    private fun isAutoshowEnabled(interstitial: CASInterstitial, result: MethodChannel.Result) {
        result.success(interstitial.isAutoshowEnabled)
    }

    private fun setAutoshowEnabled(
        interstitial: CASInterstitial,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<Boolean>("isEnabled", result) {
            interstitial.isAutoshowEnabled = it
        }

        result.success()
    }

    private fun isLoaded(interstitial: CASInterstitial, result: MethodChannel.Result) {
        result.success(interstitial.isLoaded)
    }

    private fun getContentInfo(contentInfoId: String, result: MethodChannel.Result) {
        result.success(contentInfoId)
    }

    private fun load(interstitial: CASInterstitial, result: MethodChannel.Result) {
        interstitial.load(contextService.getContext())

        result.success()
    }

    private fun show(interstitial: CASInterstitial, result: MethodChannel.Result) {
        val activity = contextService.getActivity()

        interstitial.show(activity)

        result.success()
    }

    private fun destroy(ad: Ad<CASInterstitial>, result: MethodChannel.Result) {
        destroy(ad)
        ad.ad.destroy()

        result.success()
    }

    private fun getMinInterval(interstitial: CASInterstitial, result: MethodChannel.Result) {
        result.success(interstitial.minInterval)
    }

    private fun setMinInterval(
        interstitial: CASInterstitial,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<Int>("interval", result) {
            interstitial.minInterval = it
        }

        result.success()
    }

    private fun restartInterval(interstitial: CASInterstitial, result: MethodChannel.Result) {
        interstitial.restartInterval()

        result.success()
    }

}