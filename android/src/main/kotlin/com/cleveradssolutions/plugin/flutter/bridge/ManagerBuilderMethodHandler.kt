package com.cleveradssolutions.plugin.flutter.bridge

import android.app.Activity
import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleveradssolutions.plugin.flutter.CASBridgeBuilder
import com.cleveradssolutions.plugin.flutter.CASCallback
import com.cleveradssolutions.plugin.flutter.CASInitCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.error
import com.cleveradssolutions.plugin.flutter.util.getArgAndCheckNull
import com.cleveradssolutions.plugin.flutter.util.getArgAndReturn
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdStatusHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val LOG_TAG = "com.cleveradssolutions.plugin.flutter.bridge.ManagerBuilderMethodHandler"
private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/manager_builder"

class ManagerBuilderMethodHandler(
    private val consentFlowMethodHandler: ConsentFlowMethodHandler,
    private val activityProvider: () -> Activity?,
    private val onManagerBuilt: (CASBridge) -> Unit
) : MethodHandler(CHANNEL_NAME) {

    private var initializationCallbackWrapper: CASInitCallback? = null

    private var interstitialCallbackWrapper: CASCallback? = null
    private var rewardedCallbackWrapper: CASCallback? = null

    private var casBridgeBuilder: CASBridgeBuilder? = null

    override fun onAttachedToFlutter(flutterPluginBinding: FlutterPluginBinding) {
        super.onAttachedToFlutter(flutterPluginBinding)
        initializationCallbackWrapper = createInitializationCallback()
        interstitialCallbackWrapper = createInterstitialCallback()
        rewardedCallbackWrapper = createRewardedCallback()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "withTestAdMode" -> withTestAdMode(call, result)
            "withUserId" -> setUserId(call, result)
            "withMediationExtras" -> withMediationExtras(call, result)
            "build" -> build(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun withTestAdMode(call: MethodCall, result: MethodChannel.Result) {
        val builder = getCASBridgeBuilder(call, result) ?: return

        call.getArgAndReturn<Boolean>("enabled", result) {
            builder.withTestMode(it)
        }
    }

    private fun setUserId(call: MethodCall, result: MethodChannel.Result) {
        val builder = getCASBridgeBuilder(call, result) ?: return

        call.getArgAndReturn<String>("userId", result) {
            builder.setUserId(it)
        }
    }

    private fun withMediationExtras(call: MethodCall, result: MethodChannel.Result) {
        val builder = getCASBridgeBuilder(call, result) ?: return

        call.getArgAndReturn<String, String>("key", "value", result) { key, value ->
            builder.addExtras(key, value)
        }
    }

    private fun build(call: MethodCall, result: MethodChannel.Result) {
        val builder = getCASBridgeBuilder(call, result) ?: return

        val id = call.getArgAndCheckNull<String>("id", result) ?: return
        val formats = call.getArgAndCheckNull<Int>("formats", result) ?: return
        val version = call.getArgAndCheckNull<String>("version", result) ?: return

        val casBridge = builder.build(id, version, formats, consentFlowMethodHandler.getConsentFlow())
        onManagerBuilt(casBridge)

        result.success()
    }

    private fun createInitializationCallback(): CASInitCallback {
        return CASInitCallback { error, countryCode, isConsentRequired, isTestMode ->
            invokeMethod(
                "onCASInitialized",
                mapOf(
                    "error" to error,
                    "countryCode" to countryCode,
                    "isConsentRequired" to isConsentRequired,
                    "testMode" to isTestMode
                )
            )
        }
    }

    private fun getCASBridgeBuilder(call: MethodCall, result: MethodChannel.Result): CASBridgeBuilder? {
        var builder = casBridgeBuilder
        if (builder == null) {
            val activity = activityProvider()
            if (activity != null) {
                builder = CASBridgeBuilder(activity)
                builder.setCallbacks(
                    initializationCallbackWrapper,
                    interstitialCallbackWrapper,
                    rewardedCallbackWrapper
                )
            } else {
                result.error(call, "Failed to create CASBridgeBuilder because activity is null")
            }
        }
        return builder
    }

    private fun createInterstitialCallback(): CASCallback {
        return object : CASCallback {
            override fun onLoaded() {
                invokeMethod("OnInterstitialAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeMethod(
                    "OnInterstitialAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeMethod("OnInterstitialAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeMethod("OnInterstitialAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeMethod("OnInterstitialAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeMethod("OnInterstitialAdClicked")
            }

            override fun onComplete() {
                invokeMethod("OnInterstitialAdComplete")
            }

            override fun onClosed() {
                invokeMethod("OnInterstitialAdClosed")
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {}
        }
    }

    private fun createRewardedCallback(): CASCallback {
        return object : CASCallback {
            override fun onLoaded() {
                invokeMethod("OnRewardedAdLoaded")
            }

            override fun onFailed(error: Int) {
                invokeMethod(
                    "OnRewardedAdFailedToLoad",
                    mapOf("message" to AdError(error).message)
                )
            }

            override fun onShown() {
                invokeMethod("OnRewardedAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeMethod("OnRewardedAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeMethod("OnRewardedAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeMethod("OnRewardedAdClicked")
            }

            override fun onComplete() {
                invokeMethod("OnRewardedAdCompleted")
            }

            override fun onClosed() {
                invokeMethod("OnRewardedAdClosed")
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {}
        }
    }

}