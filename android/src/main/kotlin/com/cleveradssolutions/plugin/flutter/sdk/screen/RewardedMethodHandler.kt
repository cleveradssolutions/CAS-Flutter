package com.cleveradssolutions.plugin.flutter.sdk.screen

import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.bridge.base.MappedMethodHandler
import com.cleveradssolutions.plugin.flutter.sdk.AdContentInfoHandler
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
    private val adContentInfoHandler: AdContentInfoHandler
) : MappedMethodHandler<CASRewarded>(binding, CHANNEL_NAME) {

    private lateinit var onRewardEarnedListener: OnRewardEarnedListenerHandler

    override fun initInstance(id: String): CASRewarded {
        val context = contextService.getContext()
        val rewarded = CASRewarded(context, id)
        rewarded.contentCallback = ScreenAdContentCallbackHandler(this, id, adContentInfoHandler)
        rewarded.onImpressionListener = OnAdImpressionListenerHandler(this, id)
        onRewardEarnedListener = OnRewardEarnedListenerHandler(this, id)
        return rewarded
    }

    override fun onMethodCall(
        id: String,
        instance: CASRewarded,
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "isAutoloadEnabled" -> isAutoloadEnabled(instance, result)
            "setAutoloadEnabled" -> setAutoloadEnabled(instance, call, result)
            "isExtraFillInterstitialAdEnabled" ->
                isExtraFillInterstitialAdEnabled(instance, result)

            "setExtraFillInterstitialAdEnabled" ->
                setExtraFillInterstitialAdEnabled(instance, call, result)

            "isLoaded" -> isLoaded(instance, result)
            "load" -> load(instance, result)
            "show" -> show(instance, result)
            "destroy" -> destroy(instance, result)
            else -> super.onMethodCall(id, instance, call, result)
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

        result.success()
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

        result.success()
    }

    private fun isLoaded(rewarded: CASRewarded, result: MethodChannel.Result) {
        result.success(rewarded.isLoaded)
    }

    private fun load(rewarded: CASRewarded, result: MethodChannel.Result) {
        rewarded.load(contextService.getContext())

        result.success()
    }

    private fun show(rewarded: CASRewarded, result: MethodChannel.Result) {
        val activity = contextService.getActivity()

        rewarded.show(activity, onRewardEarnedListener)

        result.success()
    }

    private fun destroy(rewarded: CASRewarded, result: MethodChannel.Result) {
        rewarded.destroy()

        result.success()
    }

}