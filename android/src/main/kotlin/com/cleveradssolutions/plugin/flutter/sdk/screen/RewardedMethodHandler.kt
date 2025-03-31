package com.cleveradssolutions.plugin.flutter.sdk.screen

import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.bridge.base.AdMethodHandler
import com.cleveradssolutions.plugin.flutter.sdk.AdContentInfoMethodHandler
import com.cleveradssolutions.plugin.flutter.sdk.OnAdImpressionListenerHandler
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleveradssolutions.sdk.screen.CASRewarded
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/rewarded"

class RewardedMethodHandler(
    binding: FlutterPlugin.FlutterPluginBinding,
    private val contextService: CASFlutterContext,
    contentInfoHandler: AdContentInfoMethodHandler
) : AdMethodHandler<CASRewarded>(binding, CHANNEL_NAME, contentInfoHandler) {

    override fun initInstance(id: String): Ad<CASRewarded> {
        val context = contextService.getContext()
        val rewarded = CASRewarded(context, id)
        val contentInfoId = "rewarded_$id"
        rewarded.contentCallback = ScreenAdContentCallbackHandler(this, id, contentInfoId)
        rewarded.onImpressionListener = OnAdImpressionListenerHandler(this, id, contentInfoId)
        return Ad(rewarded, id, contentInfoId)
    }

    override fun onMethodCall(
        instance: Ad<CASRewarded>,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "isAutoloadEnabled" -> isAutoloadEnabled(instance.ad, result)
            "setAutoloadEnabled" -> setAutoloadEnabled(instance.ad, call, result)
            "isExtraFillInterstitialAdEnabled" ->
                isExtraFillInterstitialAdEnabled(instance.ad, result)

            "setExtraFillInterstitialAdEnabled" ->
                setExtraFillInterstitialAdEnabled(instance.ad, call, result)

            "isLoaded" -> isLoaded(instance.ad, result)
            "getContentInfo" -> getContentInfo(instance.contentInfoId, result)
            "load" -> load(instance.ad, result)
            "show" -> show(instance, result)
            "destroy" -> destroy(instance, result)
            else -> super.onMethodCall(instance, call, result)
        }
    }

    private fun isAutoloadEnabled(rewarded: CASRewarded, result: MethodChannel.Result) {
        result.success(rewarded.isAutoloadEnabled)
    }

    private fun setAutoloadEnabled(
        rewarded: CASRewarded,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<Boolean>("isEnabled", result) {
            rewarded.isAutoloadEnabled = it
        }
    }

    private fun isExtraFillInterstitialAdEnabled(
        rewarded: CASRewarded,
        result: MethodChannel.Result
    ) {
        result.success(rewarded.isExtraFillInterstitialAdEnabled)
    }

    private fun setExtraFillInterstitialAdEnabled(
        rewarded: CASRewarded,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        call.getArgAndReturn<Boolean>("isEnabled", result) {
            rewarded.isExtraFillInterstitialAdEnabled = it
        }
    }

    private fun isLoaded(rewarded: CASRewarded, result: MethodChannel.Result) {
        result.success(rewarded.isLoaded)
    }

    private fun getContentInfo(contentInfoId: String, result: MethodChannel.Result) {
        result.success(contentInfoId)
    }

    private fun load(rewarded: CASRewarded, result: MethodChannel.Result) {
        rewarded.load(contextService.getContext())

        result.success()
    }

    private fun show(ad: Ad<CASRewarded>, result: MethodChannel.Result) {
        val activity = contextService.getActivity()

        val onRewardEarnedListener = OnRewardEarnedListenerHandler(this, ad.id, ad.contentInfoId)
        ad.ad.show(activity, onRewardEarnedListener)

        result.success()
    }

    private fun destroy(ad: Ad<CASRewarded>, result: MethodChannel.Result) {
        destroy(ad)
        ad.ad.destroy()

        result.success()
    }

}