import CleverAdsSolutions
import Flutter

private let pluginVersion = "4.5.3"
private let defaultKey = "value"

@objc(CASMobileAdsPlugin)
public class CASMobileAdsPlugin: NSObject, FlutterPlugin {
    /// A dictionary of `CASNativeAdViewFactory` instances used to create `CASNativeView`s
    /// for Native Ads received from Dart.
    ///
    /// The dictionary keys are string unique identifier for the ad factory. The Native Ad created in Dart includes a parameter that refers to `factoryId`.
    /// Set this dictionary to register native ad view factories before loading native ads.
    @objc
    public static var nativeAdFactories: Dictionary<String, CASNativeAdViewFactory>?

    private let instanceManager: AdInstanceManager
    private var appDelegate: UIApplicationDelegate?
    private var initializationStatus: CASInitialConfig?
    private var casId: String = ""

    init(instanceManager: AdInstanceManager) {
        self.instanceManager = instanceManager
        super.init()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let readerWriter = CASMobileAdsReaderWriter()
        let codec = FlutterStandardMethodCodec(readerWriter: readerWriter)

        let channelName = "clever_ads_solutions"
        let channel = FlutterMethodChannel(name: channelName,
                                           binaryMessenger: registrar.messenger(),
                                           codec: codec)

        let adInstanceManager = AdInstanceManager(channel: channel)
        let instance = CASMobileAdsPlugin(instanceManager: adInstanceManager)

        registrar.publish(instance)
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)

        let viewFactory = CASMobileAdsViewFactory(manager: adInstanceManager)
        registrar.register(viewFactory, withId: channelName + "/ad_widget")
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]) -> Bool {
        appDelegate = application.delegate
        return true
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "_init":
            // Internal init. This is necessary to cleanup state on hot restart.
            instanceManager.disposeAllAds()
            result(nil)

        case "initialize":
            initializeSDK(call: call, result: result)
            return

        case "getSDKVersion":
            result(CAS.getSDKVersion())
        case "setAdSoundsMuted":
            CAS.settings.mutedAdSounds = call.requireArg()
            result(nil)

        case "setDebugLoggingEnabled":
            CAS.settings.debugMode = call.requireArg()
            result(nil)

        case "setTrialAdFreeInterval":
            CAS.settings.trialAdFreeInterval = call.requireArg()
            result(nil)

        case "getVendorConsent":
            result(CAS.settings.getVendorConsent(vendorId: call.requireArg()))

        case "getAdditionalConsent":
            result(CAS.settings.getAdditionalConsent(providerId: call.requireArg()))

        case "validateIntegration":
            CAS.validateIntegration()
            result(nil)

        case "showConsentFlow":
            let flow = ConsentFlow()
            if let geography: Int = call.argument("debugGeography"), geography > 0, let geo = ConsentFlow.DebugGeography(rawValue: geography) {
                flow.debugGeography = geo
                flow.forceTesting = true
            }
            flow.privacyPolicyUrl = call.argument("policyUrl")

            var resultOnce: FlutterResult? = result
            flow.withCompletionHandler { status in
                resultOnce?(status.rawValue)
                resultOnce = nil
            }

            if call.argument("force") == true {
                flow.present()
            } else {
                flow.presentIfRequired()
            }
            return

        case "createAdInstance":
            createAdInstance(call: call)
            result(nil)

        case "isAdLoaded":
            result(instanceManager.findAd(call.requireArg())?.isAdLoaded() == true)
        case "loadAd":
            instanceManager.findAd(call.requireArg())?.loadAd()
            result(nil)

        case "isAutoloadEnabled":
            result(instanceManager.findAd(call.requireArg())?.isAutoloadEnabled == true)
        case "setAutoloadEnabled":
            instanceManager.findAd(call.requireAdId())?.isAutoloadEnabled =
                call.requireArg(defaultKey)
            result(nil)

        case "isAutoshowEnabled":
            result(instanceManager.findAd(call.requireArg())?.isAutoshowEnabled == true)
        case "setAutoshowEnabled":
            instanceManager.findAd(call.requireAdId())?.isAutoshowEnabled =
                call.requireArg(defaultKey)
            result(nil)

        case "showScreenAd":
            let adId: Int = call.requireArg()
            if let ad = instanceManager.findAd(adId) as? FlutterScreenAd {
                ad.showScreenAd()
            } else {
                instanceManager.onAdFailedToShow(adId: adId, error: AdError.notReady)
            }
            result(nil)

        case "getAdInterval":
            result(instanceManager.findAd(call.requireArg())?.interval ?? 0)
        case "setAdInterval":
            instanceManager.findAd(call.requireAdId())?.interval =
                call.requireArg(defaultKey)
            result(nil)

        case "restartInterstitialAdInterval":
            CAS.settings.restartInterstitialInterval()
            result(nil)

        case "getContentInfo":
            result(instanceManager.findAd(call.requireArg())?.contentInfo)

        case "disposeAd":
            instanceManager.disposeAd(call.requireArg())
            result(nil)

        case "getTaggedAudience":
            result(CAS.settings.taggedAudience.rawValue)
        case "setTaggedAudience":
            let status: Int = call.requireArg()
            if let statusEnum = Audience(rawValue: status) {
                CAS.settings.taggedAudience = statusEnum
            }
            result(nil)

        case "getUserConsent":
            result(CAS.settings.userConsent.rawValue)
        case "setUserConsent":
            let status: Int = call.requireArg()
            if let statusEnum = ConsentStatus(rawValue: status) {
                CAS.settings.userConsent = statusEnum
            }
            result(nil)

        case "getCPPAStatus":
            result(CAS.settings.userCCPAStatus.rawValue)
        case "setCPPAStatus":
            let status: Int = call.requireArg()
            if let statusEnum = CCPAStatus(rawValue: status) {
                CAS.settings.userCCPAStatus = statusEnum
            }
            result(nil)

        case "setUserId":
            CAS.targetingOptions.userID = call.arguments()
            result(nil)

        case "setGender":
            CAS.targetingOptions.gender = call.requireArg()
            result(nil)

        case "setAge":
            CAS.targetingOptions.age = call.requireArg()
            result(nil)

        case "setLocation":
            CAS.targetingOptions.setLocation(
                latitude: call.requireArg("lat"),
                longitude: call.requireArg("lon")
            )
            result(nil)

        case "setLocationCollectionEnabled":
            CAS.targetingOptions.locationCollectionEnabled = call.requireArg()
            result(nil)

        case "setKeywords":
            let keywords: [String]? = call.arguments()
            CAS.targetingOptions.keywords = keywords
            result(nil)

        case "setContentUrl":
            CAS.targetingOptions.contentUrl = call.arguments()
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func initializeSDK(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let newCasId: String = call.requireArg("casId")
        if let initializationStatus, newCasId == casId {
            result(initializationStatus)
            return
        }

        casId = newCasId

        if let it: Int = call.argument("audience"), it > 0, let audience = CASAudience(rawValue: it) {
            CAS.settings.taggedAudience = audience
        }

        let builder = CAS.buildManager()

        if call.argument("showConsentFlow") == false {
            builder.withConsentFlow(CASConsentFlow(isEnabled: false))
        } else if let it: Int = call.argument("debugGeography"), it >= 0,
                  let geography = ConsentFlow.DebugGeography(rawValue: it) {
            builder.withConsentFlow(CASConsentFlow()
                .withDebugGeography(geography))
        }

        if call.argument("forceTestAds") == true {
            builder.withTestAdMode(true)
        }

        if let it: [String] = call.argument("testDeviceIds") {
            CAS.settings.setTestDevice(ids: Array(it))
        }

        if let it: [String: String] = call.argument("mediationExtras") {
            for item in it {
                builder.withMediationExtras(item.value, forKey: item.key)
            }
        }

        builder.withFramework("Flutter", version: pluginVersion)

        var resultOnce: FlutterResult? = result
        builder.withCompletionHandler { [weak self] initialConfig in
            self?.initializationStatus = initialConfig

            resultOnce?(initialConfig)
            resultOnce = nil
        }

        builder.create(withCasId: casId)
    }

    private func createAdInstance(call: FlutterMethodCall) {
        let manager = instanceManager
        let targetCasId: String = call.argument("casId") ?? casId
        let adId = call.requireAdId()
        let format: Int = call.requireArg("format")
        let autoload: Bool = call.argument("autoload") == true

        if targetCasId.isEmpty {
            manager.onAdFailedToLoad(adId: adId, error: AdError.notInitialized)
            return
        }

        let flutterAd: FlutterAd
        switch format {
        case AdFormat.banner.value,
             AdFormat.mediumRectangle.value,
             AdFormat.inlineBanner.value:
            let view = CASBannerView(casID: targetCasId, size: call.requireArg("size"))
            // to prevent autoload by default
            view.isAutoloadEnabled = false
            if let interval: Int = call.argument("refreshInterval") {
                view.refreshInterval = interval
            }

            flutterAd = FlutterBannerAd(adId: adId, manager: manager, bannerView: view)

        case AdFormat.interstitial.value:
            let inter = CASInterstitial(casID: targetCasId)
            inter.isAutoshowEnabled = call.argument("autoshow") == true
            if let interval: Int = call.argument("minInterval") {
                inter.minInterval = interval
            }

            flutterAd = FlutterScreenAd(adId: adId, manager: manager, screenAd: inter)

        case AdFormat.rewarded.value:
            let rewarded = CASRewarded(casID: targetCasId)
            rewarded.isExtraFillInterstitialAdEnabled =
                call.argument("extraFillByInterstitialAd") == true

            flutterAd = FlutterScreenAd(adId: adId, manager: manager, screenAd: rewarded)

        case AdFormat.appOpen.value:
            let appOpen = CASAppOpen(casID: targetCasId)
            appOpen.isAutoshowEnabled = call.argument("autoshow") == true

            flutterAd = FlutterScreenAd(adId: adId, manager: manager, screenAd: appOpen)

        case AdFormat.native.value:
            var factory: CASNativeAdViewFactory?
            if let it: String = call.argument("factoryId") {
                factory = CASMobileAdsPlugin.nativeAdFactories?[it]
            }

            flutterAd = FlutterNativeAd(adId: adId, manager: manager, call: call, casID: targetCasId, viewFactory: factory)

        default:
            NSException(name: .invalidArgumentException,
                        reason: "Failed to create ad instance for invalid format: \(format)",
                        userInfo: nil).raise()
            return
        }

        manager.trackAd(flutterAd)

        if autoload {
            flutterAd.isAutoloadEnabled = true
        } else if call.argument("shouldLoad") == true {
            flutterAd.loadAd()
        }
    }
}

extension FlutterMethodCall {
    func arguments<T>() -> T? {
        arguments as? T
    }

    func argument<T>(_ key: String) -> T? {
        guard let map = arguments as? [String: Any] else { return nil }
        return map[key] as? T
    }

    func requireArg<T>() -> T {
        if let arg = arguments as? T {
            return arg
        }
        let reason = "Missing required argument of type \(T.self) for \(method)"
        NSException(name: .invalidArgumentException, reason: reason, userInfo: nil).raise()
        fatalError(reason)
    }

    func requireArg<T>(_ key: String) -> T {
        guard let arg: T = argument(key) else {
            let reason = "Missing required argument \(key) of type \(T.self) for \(method)"
            NSException(name: .invalidArgumentException, reason: reason, userInfo: nil).raise()
            fatalError(reason)
        }
        return arg
    }

    func requireAdId() -> Int {
        requireArg("adId")
    }
}
