//
//  AdsSettingsMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

private let channelName = "com.cleveradssolutions.plugin.flutter/ads_settings"

class AdsSettingsMethodHandler: MethodHandler {
    init() {
        super.init(channelName: channelName)
    }

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "getTaggedAudience": getTaggedAudience(result)
        case "setTaggedAudience": setTaggedAudience(call, result)
        case "getUserConsent": getUserConsent(result)
        case "setUserConsent": setUserConsent(call, result)
        case "getVendorConsent": getVendorConsent(call, result)
        case "getAdditionalConsent": getAdditionalConsent(call, result)
        case "getCPPAStatus": getCPPAStatus(result)
        case "setCCPAStatus": setCCPAStatus(call, result)
        case "getMutedAdSounds": getMutedAdSounds(result)
        case "setMutedAdSounds": setMutedAdSounds(call, result)
        case "getDebugMode": getDebugMode(result)
        case "setDebugMode": setDebugMode(call, result)
        case "addTestDeviceId": setTestDeviceId(call, result)
        case "setTestDeviceId": setTestDeviceId(call, result)
        case "setTestDeviceIds": setTestDeviceIds(call, result)
        case "clearTestDeviceIds": clearTestDeviceIds(result)
        case "getTrialAdFreeInterval": getTrialAdFreeInterval(result)
        case "setTrialAdFreeInterval": setTrialAdFreeInterval(call, result)
        case "getBannerRefreshDelay": getBannerRefreshDelay(result)
        case "setBannerRefreshDelay": setBannerRefreshDelay(call, result)
        case "getInterstitialInterval": getInterstitialInterval(result)
        case "setInterstitialInterval": setInterstitialInterval(call, result)
        case "restartInterstitialInterval": restartInterstitialInterval(result)
        case "isAllowInterstitialAdsWhenVideoCostAreLower": isAllowInterstitialAdsWhenVideoCostAreLower(result)
        case "allowInterstitialAdsWhenVideoCostAreLower": allowInterstitialAdsWhenVideoCostAreLower(call, result)
        case "getLoadingMode": getLoadingMode(result)
        case "setLoadingMode": setLoadingMode(call, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func getTaggedAudience(_ result: @escaping FlutterResult) {
        result(CAS.settings.taggedAudience.rawValue)
    }

    private func setTaggedAudience(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("taggedAudience", result) { index in
            if let value = CASAudience(rawValue: index) {
                CAS.settings.taggedAudience = value
            }
        }
    }

    private func getUserConsent(_ result: @escaping FlutterResult) {
        result(CAS.settings.userConsent.rawValue)
    }

    private func setUserConsent(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("userConsent", result) { index in
            if let value = CASConsentStatus(rawValue: index) {
                CAS.settings.userConsent = value
            }
        }
    }

    private func getVendorConsent(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturnResult("vendorId", result) { vendorId in
            CAS.settings.getVendorConsent(vendorId: vendorId).rawValue
        }
    }

    private func getAdditionalConsent(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturnResult("providerId", result) { providerId in
            CAS.settings.getAdditionalConsent(providerId: providerId).rawValue
        }
    }

    private func getCPPAStatus(_ result: @escaping FlutterResult) {
        result(CAS.settings.userCCPAStatus.rawValue)
    }

    private func setCCPAStatus(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("ccpa", result) { index in
            if let value = CASCCPAStatus(rawValue: index) {
                CAS.settings.userCCPAStatus = value
            }
        }
    }

    private func getMutedAdSounds(_ result: @escaping FlutterResult) {
        result(CAS.settings.mutedAdSounds)
    }

    private func setMutedAdSounds(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("muted", result) { value in
            CAS.settings.mutedAdSounds = value
        }
    }

    private func getDebugMode(_ result: @escaping FlutterResult) {
        result(CAS.settings.debugMode)
    }

    private func setDebugMode(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("enable", result) { value in
            CAS.settings.debugMode = value
        }
    }

    private func setTestDeviceId(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("deviceId", result) { deviceId in
            CAS.settings.setTestDevice(ids: [deviceId])
        }
    }

    private func setTestDeviceIds(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("deviceIds", result) { deviceIds in
            CAS.settings.setTestDevice(ids: deviceIds)
        }
    }

    private func clearTestDeviceIds(_ result: @escaping FlutterResult) {
        CAS.settings.setTestDevice(ids: [])
        result(nil)
    }

    private func getTrialAdFreeInterval(_ result: @escaping FlutterResult) {
        result(CAS.settings.trialAdFreeInterval)
    }

    private func setTrialAdFreeInterval(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("interval", result) { interval in
            CAS.settings.trialAdFreeInterval = interval
        }
    }

    private func getBannerRefreshDelay(_ result: @escaping FlutterResult) {
        result(CAS.settings.bannerRefreshInterval)
    }

    private func setBannerRefreshDelay(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("delay", result) { delay in
            CAS.settings.bannerRefreshInterval = delay
        }
    }

    private func getInterstitialInterval(_ result: @escaping FlutterResult) {
        result(CAS.settings.interstitialInterval)
    }

    private func setInterstitialInterval(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("delay", result) { delay in
            CAS.settings.interstitialInterval = delay
        }
    }

    private func restartInterstitialInterval(_ result: @escaping FlutterResult) {
        CAS.settings.restartInterstitialInterval()
        result(nil)
    }

    private func isAllowInterstitialAdsWhenVideoCostAreLower(_ result: @escaping FlutterResult) {
        result(CAS.settings.isInterstitialAdsWhenVideoCostAreLowerAllowed())
    }

    private func allowInterstitialAdsWhenVideoCostAreLower(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("enable", result) { enable in
            CAS.settings.setInterstitialAdsWhenVideoCostAreLower(allow: enable)
        }
    }

    private func getLoadingMode(_ result: @escaping FlutterResult) {
        result(CAS.settings.getLoadingMode())
    }

    private func setLoadingMode(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("loadingMode", result) { loadingMode in
            CAS.settings.setLoading(mode: loadingMode)
        }
    }
}
