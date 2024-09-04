package com.cleveradssolutions.plugin.flutter

import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdStatusHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

private const val LOG_TAG = "MediationManagerHandler"
private const val CHANNEL_NAME = "com.cleveradssolutions.plugin.flutter/mediation_manager"

class MediationManagerMethodHandler(
    private val bridgeProvider: () -> CASBridge?
) : MethodHandler(CHANNEL_NAME) {

    private var appReturnCallbackWrapper: CASCallback? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        super.onAttachedToEngine(flutterPluginBinding)
        appReturnCallbackWrapper = object : CASCallback {
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

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "loadAd" -> loadAd(call, result)
            "isReadyAd" -> isReadyAd(call, result)
            "showAd" -> showAd(call, result)
            "enableAppReturn" -> enableAppReturn(call, result)
            "skipNextAppReturnAds" -> skipNextAppReturnAds(result)
            "setEnabled" -> setEnabled(call, result)
            "isEnabled" -> isEnabled(call, result)
        }
    }

    /** region SDK METHODS   =======================================================================*/
    private fun setEnabled(call: MethodCall, result: Result) {
        val casBridge = bridgeProvider()
            ?: return result.error(LOG_TAG, "failed to get manager", null)

        val adType = call.argument<Int>("adType")
            ?: return result.error(LOG_TAG, "adType is null", null)

        val enabled = call.argument<Boolean>("enable")
            ?: return result.error(LOG_TAG, "enable is null", null)

        if (adType < 0 || adType > 2)
            return result.error(LOG_TAG, "adType is not correct", null)

        casBridge.enableAd(adType, enabled)

        return result.success(null)
    }

    private fun isEnabled(call: MethodCall, result: Result) {
        val casBridge = bridgeProvider()
            ?: return result.error(LOG_TAG, "failed to get manager", null)

        val adType = call.argument<Int>("adType")
            ?: return result.error(LOG_TAG, "adType is null", null)

        if (adType < 0 || adType > 2)
            return result.error(LOG_TAG, "adType is not correct", null)

        return result.success(casBridge.isEnabled(adType))
    }

    //endregion

    /** region Ads API methods  ====================================================================*/

    private fun loadAd(call: MethodCall, result: Result) {
        val casBridge = bridgeProvider()
            ?: return result.error(LOG_TAG, "failed to get manager", null)

        val adType = call.argument<Int>("adType")
            ?: return result.error(LOG_TAG, "adType is null", null)

        if (adType == 1) {
            casBridge.loadInterstitial()
            return result.success(null)
        }

        if (adType == 2) {
            casBridge.loadRewarded()
            return result.success(null)
        }

        return result.error(LOG_TAG, "AdType is not supported", null)
    }

    private fun isReadyAd(call: MethodCall, result: Result) {
        val casBridge = bridgeProvider()
            ?: return result.error(LOG_TAG, "failed to get manager", null)

        val adType = call.argument<Int>("adType")
            ?: return result.error(LOG_TAG, "adType is null", null)

        if (adType == 1) {
            return result.success(casBridge.isInterstitialAdReady)
        }

        if (adType == 2) {
            return result.success(casBridge.isRewardedAdReady)
        }

        return result.error(LOG_TAG, "AdType is not supported", null)
    }

    private fun showAd(call: MethodCall, result: Result) {
        val casBridge = bridgeProvider()
            ?: return result.error(LOG_TAG, "failed to get manager", null)

        val adType = call.argument<Int>("adType")
            ?: return result.error(LOG_TAG, "adType is null", null)

        when (adType) {
            1 -> {
                casBridge.showInterstitial()
                result.success(null)
            }

            2 -> {
                casBridge.showRewarded()
                result.success(null)
            }

            else -> result.error(LOG_TAG, "AdType is not supported", null)
        }
    }

    private fun enableAppReturn(call: MethodCall, result: Result) {
        val casBridge = bridgeProvider()
            ?: return result.error(LOG_TAG, "failed to get manager", null)

        val enable = call.argument<Boolean>("enable")
            ?: return result.error(LOG_TAG, "enable is null", null)

        if (enable)
            casBridge.enableReturnAds(appReturnCallbackWrapper)
        else
            casBridge.disableReturnAds()

        return result.success(null)
    }

    private fun skipNextAppReturnAds(result: Result) {
        val casBridge = bridgeProvider()
            ?: return result.error(LOG_TAG, "failed to get manager", null)

        casBridge.skipNextReturnAds()

        return result.success(null)
    }

}