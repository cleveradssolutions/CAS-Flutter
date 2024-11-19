package com.cleveradssolutions.plugin.flutter.appopen

import android.util.Log
import com.cleveradssolutions.plugin.flutter.CASFlutterContext
import com.cleveradssolutions.plugin.flutter.bridge.base.FlutterObjectFactory
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdCallback
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdImpression
import com.cleversolutions.ads.CASAppOpen
import com.cleversolutions.ads.LoadAdCallback
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val CHANNEL_NAME = "cleveradssolutions/app_open"

class AppOpenMethodHandler(
    binding: FlutterPluginBinding,
    private val contextService: CASFlutterContext,
    id: String
) : MethodHandler(binding, "$CHANNEL_NAME.$id") {

    class Factory(
        private val binding: FlutterPluginBinding,
        private val contextService: CASFlutterContext
    ) : FlutterObjectFactory<AppOpenMethodHandler>(binding, CHANNEL_NAME) {
        override fun initInstance(id: String): AppOpenMethodHandler =
            AppOpenMethodHandler(binding, contextService, id)
    }

    private val appOpen: CASAppOpen = CASAppOpen.create(id)

    init {
        appOpen.contentCallback = createContentCallback()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getManagerId" -> getManagerId(result)
            "loadAd" -> loadAd(result)
            "isAdAvailable" -> isAdAvailable(result)
            "show" -> show(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun getManagerId(result: MethodChannel.Result) {
        result.success(appOpen.managerId)
    }

    private fun loadAd(result: MethodChannel.Result) {
        appOpen.loadAd(contextService.getContext(), createLoadAdCallback())

        result.success()
    }

    private fun isAdAvailable(result: MethodChannel.Result) {
        result.success(appOpen.isAdAvailable())
    }

    private fun show(call: MethodCall, result: MethodChannel.Result) {
        val activity = contextService.getActivityOrError(call, result) ?: return

        appOpen.show(activity)

        result.success()
    }

    private fun createContentCallback(): AdCallback {
        return object : AdCallback {
            override fun onShown(ad: AdImpression) {
                invokeMethod("onShown", ad.toMap())
            }

            override fun onShowFailed(message: String) {
                invokeMethod("onShowFailed", message)
            }

            override fun onClosed() {
                invokeMethod("onClosed")
            }
        }
    }

    private fun createLoadAdCallback(): LoadAdCallback {
        return object : LoadAdCallback {
            override fun onAdFailedToLoad(error: AdError) {
                invokeMethod("onAdFailedToLoad", error.message)
            }

            override fun onAdLoaded() {
                invokeMethod("onAdLoaded")
            }
        }
    }

}