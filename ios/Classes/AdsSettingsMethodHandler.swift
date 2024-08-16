//
//  CASMethodHandler.swift
//  Runner
//
//  Created by Dmytro Uzhva on 13.08.2024.
//

import CleverAdsSolutions
import Flutter

class AdsSettingsMethodHandler: MethodHandler {
    func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool {
        switch call.method {
        case "getTaggedAudience": getTaggedAudience(result: result)
        case "setTaggedAudience": setTaggedAudience(call: call, result: result)
        case "getUserConsent": getUserConsent(result: result)
        case "setUserConsent": setUserConsent(call: call, result: result)
        case "getVendorConsent": getVendorConsent(call: call, result: result)
        case "getAdditionalConsent": getAdditionalConsent(call: call, result: result)
        case "getCPPAStatus": getCPPAStatus(result: result)
        case "setCCPAStatus": setCCPAStatus(call: call, result: result)
        case "getMutedAdSounds": getMutedAdSounds(result: result)
        case "setMutedAdSounds": setMutedAdSounds(call: call, result: result)
        case "getDebugMode": getDebugMode(result: result)
        case "setDebugMode": setDebugMode(call: call, result: result)
        case "addTestDeviceId": setTestDeviceId(call: call, result: result)
        case "setTestDeviceId": setTestDeviceId(call: call, result: result)
        case "setTestDeviceIds": setTestDeviceIds(call: call, result: result)
        case "clearTestDeviceIds": clearTestDeviceIds(result: result)
        case "getTrialAdFreeInterval": getTrialAdFreeInterval(result: result)
        case "setTrialAdFreeInterval": setTrialAdFreeInterval(call: call, result: result)
        case "getBannerRefreshDelay": getBannerRefreshDelay(result: result)
        case "setBannerRefreshDelay": setBannerRefreshDelay(call: call, result: result)
        case "getInterstitialInterval": getInterstitialInterval(result: result)
        case "setInterstitialInterval": setInterstitialInterval(call: call, result: result)
        case "restartInterstitialInterval": restartInterstitialInterval(result: result)
        case "isAllowInterstitialAdsWhenVideoCostAreLower": isAllowInterstitialAdsWhenVideoCostAreLower(result: result)
        case "allowInterstitialAdsWhenVideoCostAreLower": allowInterstitialAdsWhenVideoCostAreLower(call: call, result: result)
        case "getLoadingMode": getLoadingMode(result: result)
        case "setLoadingMode": setLoadingMode(call: call, result: result)
        default: return false
        }
        return true
    }

    private func getTaggedAudience(result: @escaping FlutterResult) {
        result(CAS.settings.taggedAudience.rawValue)
    }

    private func setTaggedAudience(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArgSetValue(name: "taggedAudience", call: call, result: result) { index in
            if let value = CASAudience(rawValue: index) {
                CAS.settings.taggedAudience = value
            }
        }
    }

    private func getUserConsent(result: @escaping FlutterResult) {
        result(CAS.settings.userConsent.rawValue)
    }

    private func setUserConsent(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArgSetValue(name: "userConsent", call: call, result: result) { index in
            if let value = CASConsentStatus(rawValue: index) {
                CAS.settings.userConsent = value
            }
        }
    }

    private func getVendorConsent(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArg(name: "vendorId", call: call, result: result) { vendorId in
            CAS.settings.getVendorConsent(vendorId: vendorId).rawValue
        }
    }

    private func getAdditionalConsent(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArg(name: "providerId", call: call, result: result) { providerId in
            CAS.settings.getAdditionalConsent(providerId: providerId).rawValue
        }
    }

    private func getCPPAStatus(result: @escaping FlutterResult) {
        result(CAS.settings.userCCPAStatus.rawValue)
    }

    private func setCCPAStatus(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArgSetValue(name: "ccpa", call: call, result: result) { index in
            if let value = CASCCPAStatus(rawValue: index) {
                CAS.settings.userCCPAStatus = value
            }
        }
    }

    private func getMutedAdSounds(result: @escaping FlutterResult) {
        result(CAS.settings.mutedAdSounds)
    }

    private func setMutedAdSounds(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArgSetValue(name: "muted", call: call, result: result) { value in
            CAS.settings.mutedAdSounds = value
        }
    }

    private func getDebugMode(result: @escaping FlutterResult) {
        result(CAS.settings.debugMode)
    }

    private func setDebugMode(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArgSetValue(name: "enable", call: call, result: result) { value in
            CAS.settings.debugMode = value
        }
    }

    private func setTestDeviceId(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArgSetValue(name: "deviceId", call: call, result: result) { deviceId in
            CAS.settings.setTestDevice(ids: [deviceId])
        }
    }

    private func setTestDeviceIds(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArgSetValue(name: "deviceIds", call: call, result: result) { deviceIds in
            CAS.settings.setTestDevice(ids: deviceIds)
        }
    }

    private func clearTestDeviceIds(result: @escaping FlutterResult) {
        CAS.settings.setTestDevice(ids: [])
        result(nil)
    }

    private func getTrialAdFreeInterval(result: @escaping FlutterResult) {
        result(CAS.settings.trialAdFreeInterval)
    }

    private func setTrialAdFreeInterval(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArgSetValue(name: "interval", call: call, result: result) { interval in
            CAS.settings.trialAdFreeInterval = interval
        }
    }

    private func getBannerRefreshDelay(result: @escaping FlutterResult) {
        result(CAS.settings.bannerRefreshInterval)
    }

    private func setBannerRefreshDelay(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArgSetValue(name: "delay", call: call, result: result) { delay in
            CAS.settings.bannerRefreshInterval = delay
        }
    }

    private func getInterstitialInterval(result: @escaping FlutterResult) {
        result(CAS.settings.interstitialInterval)
    }

    private func setInterstitialInterval(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArgSetValue(name: "delay", call: call, result: result) { delay in
            CAS.settings.interstitialInterval = delay
        }
    }

    private func restartInterstitialInterval(result: @escaping FlutterResult) {
        CAS.settings.restartInterstitialInterval()
        result(nil)
    }

    private func isAllowInterstitialAdsWhenVideoCostAreLower(result: @escaping FlutterResult) {
        result(CAS.settings.isInterstitialAdsWhenVideoCostAreLowerAllowed())
    }

    private func allowInterstitialAdsWhenVideoCostAreLower(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArgSetValue(name: "enable", call: call, result: result) { enable in
            CAS.settings.setInterstitialAdsWhenVideoCostAreLower(allow: enable)
        }
    }

    private func getLoadingMode(result: @escaping FlutterResult) {
        result(CAS.settings.getLoadingMode())
    }

    private func setLoadingMode(call: FlutterMethodCall, result: @escaping FlutterResult) {
        tryGetArgSetValue(name: "loadingMode", call: call, result: result) { loadingMode in
            CAS.settings.setLoading(mode: loadingMode)
        }
    }
}
