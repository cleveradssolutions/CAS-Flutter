import android.app.Activity
import com.cleveradssolutions.plugin.flutter.CASBridge
import com.cleveradssolutions.plugin.flutter.CASBridgeBuilder
import com.cleveradssolutions.plugin.flutter.CASCallback
import com.cleveradssolutions.plugin.flutter.CASInitCallback
import com.cleveradssolutions.plugin.flutter.ConsentFlowMethodHandler
import com.cleveradssolutions.plugin.flutter.MethodHandler
import com.cleveradssolutions.plugin.flutter.tryGetArgSetValue
import com.cleveradssolutions.plugin.flutter.util.toMap
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdStatusHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

private const val LOG_TAG = "ManagerBuilderMethodHandler"
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

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        super.onAttachedToEngine(flutterPluginBinding)
        initializationCallbackWrapper =
            CASInitCallback { error, countryCode, isConsentRequired, isTestMode ->
                invokeMethod(
                    "onCASInitialized", mapOf(
                        "error" to error,
                        "countryCode" to countryCode,
                        "isConsentRequired" to isConsentRequired,
                        "testMode" to isTestMode
                    )
                )
            }

        interstitialCallbackWrapper = object : CASCallback {
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

        rewardedCallbackWrapper = object : CASCallback {
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

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "withTestAdMode" -> withTestAdMode(call, result)
            "withUserId" -> setUserId(call, result)
            "withMediationExtras" -> withMediationExtras(call, result)
            "initialize" -> build(call, result)
            else -> super.onMethodCall(call, result)
        }
    }

    private fun withTestAdMode(call: MethodCall, result: Result) {
        tryGetArgSetValue<Boolean>("enabled", call, result) {
            getCASBridgeBuilder()?.withTestMode(it)
                ?: return result.error(LOG_TAG, "failed to get CASBridgeBuilder", null)
        }
    }

    private fun setUserId(call: MethodCall, result: Result) {
        tryGetArgSetValue<String>("userId", call, result) { userId ->
            getCASBridgeBuilder()?.setUserId(userId) ?: return result.error(
                LOG_TAG,
                "failed to get CASBridgeBuilder",
                null
            )
        }
    }

    private fun withMediationExtras(call: MethodCall, result: Result) {
        val key = call.argument<String>("key")
            ?: return result.error(LOG_TAG, "key is null", null)

        val value = call.argument<String>("value")
            ?: return result.error(LOG_TAG, "value is null", null)

        getCASBridgeBuilder()
            ?.addExtras(key, value)
            ?: return result.error(LOG_TAG, "failed to get CASBridgeBuilder", null)

        result.success(null)
    }

    private fun build(call: MethodCall, result: Result) {
        val id = call.argument<String>("id")
            ?: return result.error(LOG_TAG, "CAS ID is null", null)

        val formats = call.argument<Int>("formats")
            ?: return result.error(LOG_TAG, "formats are null", null)

        val version = call.argument<String>("version")
            ?: return result.error(LOG_TAG, "version is null", null)

        val casBridge = getCASBridgeBuilder()?.build(id, version, formats, consentFlowMethodHandler.getConsentFlow())
            ?: return result.error(LOG_TAG, "failed to get CASBridgeBuilder", null)

        onManagerBuilt(casBridge)

        result.success(null)
    }

    private fun getCASBridgeBuilder(): CASBridgeBuilder? {
        if (casBridgeBuilder == null) {
            activityProvider()?.let { activity ->
                casBridgeBuilder = CASBridgeBuilder(activity)
                casBridgeBuilder?.setCallbacks(
                    initializationCallbackWrapper,
                    interstitialCallbackWrapper,
                    rewardedCallbackWrapper
                )
            }
        }

        return casBridgeBuilder
    }

}