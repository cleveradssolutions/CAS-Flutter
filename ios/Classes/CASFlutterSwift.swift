import Flutter
import UIKit
import CleverAdsSolutions

public class CASFlutterSwift: NSObject, FlutterPlugin {
    public static let cleverAdsSolutions: CleverAds = CleverAds(
        rootViewController: UIApplication.shared.delegate!.window!!.rootViewController!
    )
        
    private let pluginChannel: FlutterMethodChannel
    
    private var flutterInit: Bool = false
    
    init(pluginChannel: FlutterMethodChannel) {
        self.pluginChannel = pluginChannel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.cleveradssolutions.cas.ads.flutter", binaryMessenger: registrar.messenger())
        let instance = CASFlutterSwift(pluginChannel: channel)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.register(BannerViewFactory(bridge: CASFlutterSwift.cleverAdsSolutions.getCasBridge, messenger: registrar.messenger()), withId: "<cas-banner-view>")
        
        CASFlutterSwift.cleverAdsSolutions.setFlutterCallerToCallbacks(caller: instance.invokeChannelMethod)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
        case "validateIntegration": validateIntegration(result: result)
        case "withTestAdMode": withTestAdMode(call: call, result: result)
        case "withUserId": setUserId(call: call, result: result)
        case "withPrivacyUrl": withPrivacyUrl(call: call, result: result)
        case "disableConsentFlow": disableConsentFlow(result: result)
        case "showConsentFlow": showConsentFlow(result: result)
        case "initialize": buildBridge(call: call, result: result)
        case "loadAd": loadAd(call: call, result: result)
        case "isReadyAd": isReadyAd(call: call, result: result)
        case "showAd": showAd(call: call, result: result)
        case "setInterstitialInterval": setInterstitialInterval(call: call, result: result)
        case "getInterstitialInterval": getInterstitialInterval(result: result)
        case "setBannerRefreshDelay": setBannerRefreshDelay(call: call, result: result)
        case "getBannerRefreshDelay": getBannerRefreshDelay(result: result)
        case "restartInterstitialInterval": restartInterstitialInterval(result: result)
        case "allowInterstitialAdsWhenVideoCostAreLower": allowInterstitialAdsWhenVideoCostAreLower(call: call, result: result)
        case "enableAppReturn": enableAppReturn(call: call, result: result)
        case "skipNextAppReturnAds": skipNextAppReturnAds(result: result)
        case "setEnabled": setEnabled(call: call, result: result)
        case "isEnabled": isEnabled(call: call, result: result)
        case "getSDKVersion": getSDKVersion(result: result)
        case "setAge": isEnabled(call: call, result: result)
        case "setGender": isEnabled(call: call, result: result)
        case "setUserConsentStatus": setUserConsentStatus(call: call, result: result)
        case "getUserConsentStatus": getUserConsentStatus(result: result)
        case "setCCPAStatus": setCCPAStatus(call: call, result: result)
        case "getCPPAStatus": getCPPAStatus(result: result)
        case "setTaggedAudience": setTaggedAudience(call: call, result: result)
        case "getTaggedAudience": getTaggedAudience(result: result)
        case "setNativeDebug": setNativeDebug(call: call, result: result)
        case "setMutedAdSounds": setMutedAdSounds(call: call, result: result)
        case "setLoadingMode": setLoadingMode(call: call, result: result)
        case "clearTestDeviceIds": clearTestDeviceIds(result: result)
        case "addTestDeviceId": addTestDeviceId(call: call, result: result)
        case "setTestDeviceIds": setTestDeviceIds(call: call, result: result)
        case "createBannerView": createBannerView(call: call, result: result)
        case "loadBanner": loadBanner(call: call, result: result)
        case "isBannerReady": isBannerReady(call: call, result: result)
        case "showBanner": showBanner(call: call, result: result)
        case "hideBanner": hideBanner(call: call, result: result)
        case "setBannerAdRefreshRate": setBannerAdRefreshRate(call: call, result: result)
        case "setBannerPosition": setBannerPosition(call: call, result: result)
        case "disableBannerRefresh": disableBannerRefresh(call: call, result: result)
        case "disposeBanner": disposeBanner(call: call, result: result)
        case "setLastPageContent": setLastPageContent(call: call, result: result)
            
        default: result(FlutterMethodNotImplemented)
        }
    }
    
    private func invokeChannelMethod(methodName: String, args: Any? = nil) {
        if (flutterInit) {
            pluginChannel.invokeMethod(methodName, arguments: args)
        }
    }
    
    private func validateIntegration(result: @escaping FlutterResult) {
        CAS.validateIntegration()
        result(nil)
    }
    
    private func withTestAdMode(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let enabled = args["enabled"] as? Bool {
            CASFlutterSwift.cleverAdsSolutions.getCasBridgeBuilder().withTestMode(enable: enabled)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func setUserId(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let id = args["userId"] as? String {
            CASFlutterSwift.cleverAdsSolutions.getCasBridgeBuilder().setUserId(id: id)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func withPrivacyUrl(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let privacy = args["privacyUrl"] as? String {
            CASFlutterSwift.cleverAdsSolutions.getCasBridgeBuilder().enableConsentFlow(privacyUrl: privacy)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func disableConsentFlow(result: @escaping FlutterResult) {
        CASFlutterSwift.cleverAdsSolutions.getCasBridgeBuilder().disableConsentFlow()
        result(nil)
    }
    
    private func showConsentFlow(result: @escaping FlutterResult) {
        CASFlutterSwift.cleverAdsSolutions.getCasBridgeBuilder().showConsentFlow()
        result(nil)
    }
    
    private func addExtras(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let key = args["key"] as? String,
           let value = args["value"] as? String {
            CASFlutterSwift.cleverAdsSolutions.getCasBridgeBuilder().addExtras(keyString: key, valueString: value)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func buildBridge(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let casId = args["id"] as? String,
           let formats = args["formats"] as? Int,
           let version = args["version"] as? String {
            flutterInit = true
            CASFlutterSwift.cleverAdsSolutions.buildBridge(id: casId, flutterVersion: version, formats: formats)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func loadAd(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int {
            if (adType == 1) {
                CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.loadInterstitial()
                result(nil)
            }
            else if (adType == 2) {
                CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.loadRewarded()
                result(nil)
            } else {
                result(FlutterError.init(code: "", message: "AdType is not supported", details: nil))
            }
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func isReadyAd(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int {
            if (adType == 1) {
                let ready = CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.isInterstitialReady() ?? false
                result(Bool(ready))
            }
            else if (adType == 2) {
                let ready = CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.isRewardedAdReady() ?? false
                result(Bool(ready))
            } else {
                result(FlutterError.init(code: "", message: "AdType is not supported", details: nil))
            }
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func showAd(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int {
            if (adType == 1) {
                CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.showInterstitial()
                result(nil)
            }
            else if (adType == 2) {
                CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.showRewarded()
                result(nil)
            } else {
                result(FlutterError.init(code: "", message: "AdType is not supported", details: nil))
            }
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func setInterstitialInterval(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let interval = args["interval"] as? Int {
            CASSettings.setInterstitialInterval(interval: interval)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func getInterstitialInterval(result: @escaping FlutterResult) {
        result(CASSettings.getInterstitialInterval())
    }
    
    private func setBannerRefreshDelay(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let delay = args["delay"] as? Int {
            CASSettings.setRefreshBannerDelay(delay: delay)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func setBannerPosition(call: FlutterMethodCall, result: @escaping FlutterResult) {
            if let args = call.arguments as? Dictionary<String, Any>,
               let sizeId = args["sizeId"] as? Int,
               let positionId = args["positionId"] as? Int,
               let xOffset = args["x"] as? Int,
               let yOffset = args["y"] as? Int{
                CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.setBannerPosition(sizeId: sizeId, positionId: positionId, x: xOffset, y: yOffset)
                    result(nil)
            } else {
                result(FlutterError.init(code: "", message: "Bad argument", details: nil))
            }
        }
    
    private func getBannerRefreshDelay(result: @escaping FlutterResult) {
        result(Int(CASSettings.getBannerRefreshDelay()))
    }
    
    private func restartInterstitialInterval(result: @escaping FlutterResult) {
        CASSettings.restartInterstitialInterval()
        result(nil)
    }
    
    private func allowInterstitialAdsWhenVideoCostAreLower(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let enable = args["enable"] as? Bool {
            CASSettings.allowInterInsteadOfRewarded(allow: enable)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func enableAppReturn(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let enable = args["enable"] as? Bool {
            if (enable) {
                CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.enableReturnAds()
            } else {
                CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.disableReturnAds()
            }
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }

    private func skipNextAppReturnAds(result: @escaping FlutterResult) {
        CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.skipNextReturnAds()
        result(nil)
    }
    
    private func setEnabled(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int,
           let enabled = args["enable"] as? Bool {
            if (adType < 0 || adType > 2) {
                result(FlutterError.init(code: "", message: "AdType is not correct", details: nil))
            } else {
                CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.setEnabled(type: adType, enable: enabled)
                result(nil)
            }
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func isEnabled(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let adType = args["adType"] as? Int {
            if (adType < 0 || adType > 2) {
                result(FlutterError.init(code: "", message: "AdType is not correct", details: nil))
            } else {
                result(CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.isEnabled(type: adType))
            }
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func getSDKVersion(result: @escaping FlutterResult) {
        result(String(CASSettings.getSDKVersion()))
    }
    
    private func setAge(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let age = args["age"] as? Int {
            CASSettings.setUserAge(age: age)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func setGender(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let gender = args["gender"] as? Int {
            CASSettings.setUserGender(gender: gender)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func setUserConsentStatus(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let consent = args["userConsent"] as? Int {
            CASSettings.setUserConsent(cosent: consent)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func getUserConsentStatus(result: @escaping FlutterResult) {
        result(Int(CASSettings.getUserConsent()))
    }
    
    private func setCCPAStatus(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let ccpa = args["ccpa"] as? Int {
            CASSettings.setCcpaStatus(cppa: ccpa)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func getCPPAStatus(result: @escaping FlutterResult) {
        result(Int(CASSettings.getCcpaStatus()))
    }
    
    private func setTaggedAudience(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let audience = args["taggedAudience"] as? Int {
            CASSettings.setTaggedAudience(audienc: audience)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func getTaggedAudience(result: @escaping FlutterResult) {
        result(Int(CASSettings.getTaggedAudience()))
    }
    
    private func setNativeDebug(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let enable = args["enable"] as? Bool {
            CASSettings.setNativeDebug(debug: enable)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func setMutedAdSounds(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let muted = args["muted"] as? Bool {
            CASSettings.setMutedAdSounds(muted: muted)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func setLoadingMode(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let mode = args["loadingMode"] as? Int {
            CASSettings.setLoadingMode(value: mode)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func clearTestDeviceIds(result: @escaping FlutterResult) {
        CASSettings.clearTestDeviceIds()
        result(nil)
    }
    
    private func addTestDeviceId(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let id = args["deviceId"] as? String {
            CASSettings.addTestDeviceId(deviceId: id)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func setTestDeviceIds(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let devices = args["devices"] as? [String] {
            CASSettings.setTestDeviceIds(testDeviceIds: devices)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func createBannerView(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.showGlobalBannerAd(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func loadBanner(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.loadNextBanner(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func isBannerReady(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            result(Bool(CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.isBannerViewAdReady(sizeId: sizeId) ?? false))
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func showBanner(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.showGlobalBannerAd(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func hideBanner(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.hideBanner(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    
    private func setBannerAdRefreshRate(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int,
           let interval = args["refresh"] as? Int {
            CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.setBannerAdRefreshRate(refresh: interval, sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func disableBannerRefresh(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.disableBannerRefresh(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func disposeBanner(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.disposeBanner(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
    private func setLastPageContent(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let json = args["lastPageJson"] as? String {
            CASFlutterSwift.cleverAdsSolutions.getCasBridge()?.setLastPageContent(json: json)
            result(nil)
        } else {
            result(FlutterError.init(code: "", message: "Bad argument", details: nil))
        }
    }
    
}
