package com.cleveradssolutions.plugin.flutter.sdk.screen

import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
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
    private val adContentInfoHandler: AdContentInfoHandler
) : MappedMethodHandler<CASInterstitial>(binding, CHANNEL_NAME) {

    override fun initInstance(id: String): CASInterstitial {
        val context = contextService.getContext()
        val interstitial = CASInterstitial(context, id)
        interstitial.contentCallback = ScreenAdContentCallbackHandler(this, id)
        interstitial.onImpressionListener = OnAdImpressionListenerHandler(this, id)
        return interstitial
    }

    override fun onMethodCall(
        instance: CASInterstitial,
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
            "destroy" -> destroy(instance, result)
            "getMinInterval" -> getMinInterval(instance, result)
            "setMinInterval" -> setMinInterval(instance, call, result)
            "restartInterval" -> restartInterval(instance, result)
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

    private fun load(interstitial: CASInterstitial, result: MethodChannel.Result) {
        interstitial.load(contextService.getContext())

        result.success()
    }

    private fun show(interstitial: CASInterstitial, result: MethodChannel.Result) {
        val activity = contextService.getActivity()

        interstitial.show(activity)

        result.success()
    }

    private fun destroy(interstitial: CASInterstitial, result: MethodChannel.Result) {
        interstitial.destroy()

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