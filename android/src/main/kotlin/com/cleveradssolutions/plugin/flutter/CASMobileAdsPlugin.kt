package com.cleveradssolutions.plugin.flutter

import android.location.Location
import android.util.Log
import androidx.annotation.Keep
import com.cleveradssolutions.sdk.AdFormat
import com.cleveradssolutions.sdk.nativead.CASNativeView
import com.cleveradssolutions.sdk.screen.CASAppOpen
import com.cleveradssolutions.sdk.screen.CASInterstitial
import com.cleveradssolutions.sdk.screen.CASRewarded
import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.ConsentFlow
import com.cleversolutions.ads.InitialConfiguration
import com.cleversolutions.ads.InitializationListener
import com.cleversolutions.ads.android.CAS
import com.cleversolutions.ads.android.CASBannerView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec

private const val PLUGIN_VERSION = "4.4.1"
private const val DEFAULT_KEY = "value"

class CASMobileAdsPlugin : FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler {
    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var _instanceManager: AdInstanceManager? = null
    private var messageCodec: CASMessageCodec? = null
    private var initializationStatus: InitialConfiguration? = null
    private var casId: String = ""

    companion object {

        /**
         * A dictionary of [CASNativeAdViewFactory] instances used to create [CASNativeView]s
         * for Native Ads received from Dart.
         *
         * The dictionary keys are string unique identifier for the ad factory.
         * The Native Ad created in Dart includes a parameter that refers to `factoryId`.
         */
        @Keep
        var nativeAdFactories: Map<String, CASNativeAdViewFactory>? = null
    }

    private val instanceManager: AdInstanceManager
        get() = _instanceManager
            ?: throw IllegalStateException("CASMobileAdsPlugin is not attached to engine")

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = binding
        val messageCodec = CASMessageCodec(binding.applicationContext)
        this.messageCodec = messageCodec

        val channelName = "clever_ads_solutions"
        val channel = MethodChannel(
            binding.binaryMessenger,
            channelName,
            StandardMethodCodec(messageCodec)
        )
        channel.setMethodCallHandler(this)

        val manager = AdInstanceManager(channel)
        _instanceManager = manager

        binding.platformViewRegistry.registerViewFactory(
            "$channelName/ad_widget",
            CASMobileAdsViewFactory(manager)
        )
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        // do nothing
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        _instanceManager?.activity = binding.activity
        messageCodec?.context = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        _instanceManager?.activity = null
        pluginBinding?.let {
            messageCodec?.context = it.applicationContext
        }
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        onDetachedFromActivityForConfigChanges()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val returnValue: Any? = when (call.method) {
            "_init" -> {
                // Internal init. This is necessary to cleanup state on hot restart.
                _instanceManager?.disposeAllAds()
                null
            }

            "initialize" -> {
                initializeSDK(call, result)
                return
            }

            "getSDKVersion" -> CAS.getSDKVersion()
            "setAdSoundsMuted" -> {
                CAS.settings.mutedAdSounds = call.requireArg()
                null
            }

            "setDebugLoggingEnabled" -> {
                CAS.settings.debugMode = call.requireArg()
                null
            }

            "setTrialAdFreeInterval" -> {
                CAS.settings.trialAdFreeInterval = call.requireArg()
                null
            }

            "getVendorConsent" -> CAS.settings.getVendorConsent(call.requireArg())

            "getAdditionalConsent" -> CAS.settings.getAdditionalConsent(call.requireArg())

            "validateIntegration" -> {
                instanceManager.activity?.let {
                    CAS.validateIntegration(it)
                }
                null
            }

            "showConsentFlow" -> {
                val flow = ConsentFlow()
                flow.uiContext = instanceManager.activity
                call.argument<Int>("debugGeography")?.let {
                    if (it > 0) {
                        flow.debugGeography = it
                        flow.forceTesting = true
                    }
                }

                flow.privacyPolicyUrl = call.argument("policyUrl")
                flow.dismissListener = FlutterResultListener(result)
                if (call.argument<Boolean>("force") == true) {
                    flow.show()
                } else {
                    flow.showIfRequired()
                }
                return
            }

            "createAdInstance" -> {
                createAdInstance(call)
                null
            }

            "isAdLoaded" -> instanceManager.findAd(call.requireArg())?.isLoaded() == true
            "loadAd" -> {
                instanceManager.findAd(call.requireArg())?.load()
                null
            }

            "isAutoloadEnabled" -> instanceManager.findAd(call.requireArg())?.isAutoloadEnabled == true
            "setAutoloadEnabled" -> {
                instanceManager.findAd(call.requireAdId())?.isAutoloadEnabled =
                    call.requireArg(DEFAULT_KEY)
                null
            }

            "isAutoshowEnabled" -> instanceManager.findAd(call.requireArg())?.isAutoshowEnabled == true
            "setAutoshowEnabled" -> {
                instanceManager.findAd(call.requireAdId())?.isAutoshowEnabled =
                    call.requireArg(DEFAULT_KEY)
                null
            }

            "showScreenAd" -> {
                val adId: Int = call.requireArg()
                val ad = instanceManager.findAd(adId)
                if (ad != null) {
                    ad.showScreen(instanceManager.activity)
                } else {
                    instanceManager.onAdFailedToShow(adId, AdError.NOT_READY)
                }
                null
            }

            "getAdInterval" -> instanceManager.findAd(call.requireArg())?.interval ?: 0
            "setAdInterval" -> {
                instanceManager.findAd(call.requireAdId())?.interval =
                    call.requireArg(DEFAULT_KEY)
                null
            }

            "restartInterstitialAdInterval" -> {
                CAS.settings.restartInterstitialInterval()
                null
            }

            "getContentInfo" -> instanceManager.findAd(call.requireArg())?.contentInfo

            "disposeAd" -> {
                instanceManager.disposeAd(call.requireArg())
                null
            }

            "getTaggedAudience" -> CAS.settings.taggedAudience
            "setTaggedAudience" -> {
                CAS.settings.taggedAudience = call.requireArg()
                null
            }

            "getUserConsent" -> CAS.settings.userConsent
            "setUserConsent" -> {
                CAS.settings.userConsent = call.requireArg()
                null
            }

            "getCPPAStatus" -> CAS.settings.ccpaStatus
            "setCPPAStatus" -> {
                CAS.settings.ccpaStatus = call.requireArg()
                null
            }

            "setUserId" -> {
                CAS.targetingOptions.userID = call.arguments()
                null
            }

            "setGender" -> {
                CAS.targetingOptions.gender = call.requireArg()
                null
            }

            "setAge" -> {
                CAS.targetingOptions.age = call.requireArg()
                null
            }

            "setLocation" -> {
                val location = Location(null)
                location.latitude = call.requireArg("lat")
                location.longitude = call.requireArg("lon")
                CAS.targetingOptions.location = location
                null
            }

            "setLocationCollectionEnabled" -> {
                CAS.targetingOptions.locationCollectionEnabled = call.requireArg()
                null
            }

            "setKeywords" -> {
                CAS.targetingOptions.keywords = call.arguments<List<String>>()?.toSet()
                null
            }

            "setContentUrl" -> {
                CAS.targetingOptions.contentUrl = call.arguments()
                null
            }

            else -> {
                result.notImplemented()
                return
            }
        }
        result.success(returnValue)
    }

    private fun initializeSDK(call: MethodCall, result: MethodChannel.Result) {
        val newCasId: String = call.requireArg("casId")
        if (initializationStatus != null && newCasId == casId) {
            result.success(initializationStatus)
            return
        }

        val binding = pluginBinding
        if (binding == null) {
            result.error(
                "MethodCallError",
                "CAS Plugin not attached to Engine",
                null
            )
            return
        }

        casId = newCasId

        call.argument<Int>("audience")?.let {
            if (it > 0) {
                CAS.settings.taggedAudience = it
            }
        }

        val builder = CAS.buildManager()
        builder.withCasId(casId)

        if (call.argument<Boolean>("showConsentFlow") == false) {
            builder.withConsentFlow(ConsentFlow(false))
        } else {
            call.argument<Int>("debugGeography")?.let {
                builder.withConsentFlow(
                    ConsentFlow()
                        .withDebugGeography(it)
                )
            }
        }

        if (call.argument<Boolean>("forceTestAds") == true) {
            builder.withTestAdMode(true)
        }

        call.argument<List<String>>("testDeviceIds")?.let {
            CAS.settings.testDeviceIDs = it.toSet()
        }

        call.argument<Map<String, String>>("mediationExtras")?.forEach {
            builder.withMediationExtras(it.key, it.value)
        }

        builder.withFramework("Flutter", PLUGIN_VERSION)
        builder.withCompletionListener(FlutterResultListener(result))
        builder.build(
            instanceManager.activity ?: binding.applicationContext
        )
    }

    private fun createAdInstance(call: MethodCall) {
        val manager = instanceManager
        val context = pluginBinding!!.applicationContext
        val targetCasId = call.argument<String>("casId") ?: casId
        val adId = call.requireAdId()
        val format = call.requireArg<Int>("format")
        val autoload = call.argument<Boolean>("autoload") == true

        if (targetCasId.isEmpty()) {
            manager.onAdFailedToLoad(adId, AdError.NOT_INITIALIZED)
            return
        }

        val flutterAd = when (format) {
            AdFormat.BANNER.value,
            AdFormat.MEDIUM_RECTANGLE.value,
            AdFormat.INLINE_BANNER.value -> {
                val view = CASBannerView(context, targetCasId)
                // before set size to prevent autoload by default
                view.isAutoloadEnabled = false
                view.size = call.requireArg("size")
                call.argument<Int>("refreshInterval")?.let {
                    view.refreshInterval = it
                }

                FlutterBannerAd(adId, manager, view)
            }

            AdFormat.INTERSTITIAL.value -> {
                val inter = CASInterstitial(context, targetCasId)
                inter.isAutoshowEnabled = call.argument<Boolean>("autoshow") == true
                call.argument<Int>("minInterval")?.let {
                    inter.minInterval = it
                }

                FlutterScreenAd(adId, manager, inter)
            }

            AdFormat.REWARDED.value -> {
                val rewarded = CASRewarded(context, targetCasId)
                rewarded.isExtraFillInterstitialAdEnabled =
                    call.argument<Boolean>("extraFillByInterstitialAd") == true

                FlutterScreenAd(adId, manager, rewarded)
            }

            AdFormat.APP_OPEN.value -> {
                val appOpen = CASAppOpen(context, targetCasId)
                appOpen.isAutoshowEnabled = call.argument<Boolean>("autoshow") == true

                FlutterScreenAd(adId, manager, appOpen)
            }

            AdFormat.NATIVE.value -> {
                val factory = call.argument<String>("factoryId")?.let {
                    nativeAdFactories?.get(it)
                }
                FlutterNativeAd(adId, manager, call, targetCasId, context, factory)
            }

            else -> throw IllegalArgumentException(
                "Failed to create ad instance for invalid format: $format"
            )
        }

        manager.trackAd(flutterAd)

        if (autoload) {
            flutterAd.isAutoloadEnabled = true
        } else if (call.argument<Boolean>("shouldLoad") == true) {
            flutterAd.load()
        }
    }

    private inner class FlutterResultListener(
        private var result: MethodChannel.Result?
    ) : InitializationListener, ConsentFlow.OnDismissListener {

        override fun onCASInitialized(config: InitialConfiguration) {
            initializationStatus = config

            // Make sure not to invoke this more than once, since Dart will throw
            // an exception if success is invoked more than once.
            result?.success(config)
            result = null
        }

        override fun onConsentFlowDismissed(status: Int) {
            result?.success(status)
            result = null
        }
    }
}

private inline fun <reified T> MethodCall.requireArg(key: String) = argument<T>(key)
    ?: throw IllegalArgumentException("Missing required argument $key of type ${T::class.simpleName} for $method")

private inline fun <reified T> MethodCall.requireArg() = arguments<T>()
    ?: throw IllegalArgumentException("Missing required argument of type ${T::class.simpleName} for $method")

@Suppress("NOTHING_TO_INLINE")
private inline fun MethodCall.requireAdId() = requireArg<Int>("adId")