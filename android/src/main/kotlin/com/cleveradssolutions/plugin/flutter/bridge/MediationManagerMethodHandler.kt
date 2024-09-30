package com.cleveradssolutions.plugin.flutter.bridge

import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleveradssolutions.plugin.flutter.CASCallback
import com.cleveradssolutions.plugin.flutter.bridge.base.MethodHandler
import com.cleveradssolutions.plugin.flutter.util.error
import com.cleveradssolutions.plugin.flutter.util.errorArgNull
import com.cleveradssolutions.plugin.flutter.util.errorInvalidArg
import com.cleveradssolutions.plugin.flutter.util.getArgAndCheckNull
import com.cleveradssolutions.plugin.flutter.util.success
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdStatusHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

private const val LOG_TAG = "MediationManagerHandler"
private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/mediation_manager"

class MediationManagerMethodHandler(
    private val bridgeProvider: () -> CASBridge?
) : MethodHandler(CHANNEL_NAME) {

    private var appReturnCallbackWrapper: CASCallback? = null

    override fun onAttachedToFlutter(flutterPluginBinding: FlutterPluginBinding) {
        super.onAttachedToFlutter(flutterPluginBinding)
        appReturnCallbackWrapper = createAppReturnCallback()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "loadAd" -> loadAd(call, result)
            "isReadyAd" -> isReadyAd(call, result)
            "showAd" -> showAd(call, result)
            "enableAppReturn" -> enableAppReturn(call, result)
            "skipNextAppReturnAds" -> skipNextAppReturnAds(call, result)
            "setEnabled" -> setEnabled(call, result)
            "isEnabled" -> isEnabled(call, result)
        }
    }

    private fun setEnabled(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        val enabled = call.getArgAndCheckNull<Boolean>("enable", result) ?: return
        if (adType < 0 || adType > 2) return result.errorInvalidArg(call, "adType")

        casBridge.enableAd(adType, enabled)

        result.success()
    }

    private fun isEnabled(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        if (adType < 0 || adType > 2) {
            return result.errorInvalidArg(call, "adType")
        }

        result.success(casBridge.isEnabled(adType))
    }

    private fun loadAd(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        when (adType) {
            1 -> casBridge.loadInterstitial()
            2 -> casBridge.loadRewarded()
            else -> return result.error(call, "AdType is not supported")
        }

        result.success()
    }

    private fun isReadyAd(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        when (adType) {
            1 -> result.success(casBridge.isInterstitialAdReady)
            2 -> result.success(casBridge.isRewardedAdReady)
            else -> result.error(call, "AdType is not supported")
        }
    }

    private fun showAd(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        val adType = call.getArgAndCheckNull<Int>("adType", result) ?: return
        when (adType) {
            1 -> casBridge.showInterstitial()
            2 -> casBridge.showRewarded()
            else -> return result.error(call, "AdType is not supported")
        }

        result.success()
    }

    private fun enableAppReturn(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        val enable = call.getArgAndCheckNull<Boolean>("enable", result) ?: return

        if (enable) {
            casBridge.enableReturnAds(appReturnCallbackWrapper)
        } else {
            casBridge.disableReturnAds()
        }

        result.success()
    }

    private fun skipNextAppReturnAds(call: MethodCall, result: MethodChannel.Result) {
        val casBridge = getBridgeAndCheckNull(call, result) ?: return

        casBridge.skipNextReturnAds()

        result.success()
    }

    private fun createAppReturnCallback(): CASCallback {
        return object : CASCallback {
            override fun onLoaded() {
            }

            override fun onFailed(error: Int) {
            }

            override fun onShown() {
                invokeMethod("OnAppReturnAdShown")
            }

            override fun onImpression(impression: AdStatusHandler?) {
                invokeMethod("OnAppReturnAdImpression", impression?.toMap())
            }

            override fun onShowFailed(message: String?) {
                invokeMethod("OnAppReturnAdFailedToShow", mapOf("message" to message))
            }

            override fun onClicked() {
                invokeMethod("OnAppReturnAdClicked")
            }

            override fun onComplete() {}

            override fun onClosed() {
                invokeMethod("OnAppReturnAdClosed")
            }

            override fun onRect(x: Int, y: Int, width: Int, height: Int) {}
        }
    }

    private fun getBridgeAndCheckNull(call: MethodCall, result: MethodChannel.Result): CASBridge? {
        val bridge = bridgeProvider()
        if (bridge == null) result.errorArgNull(call, "CASBridge")
        return bridge
    }

}