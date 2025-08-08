//
//  BannerMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter
import Foundation

class BannerMethodHandler: AdMethodHandler<BannerView> {
    init(with registrar: FlutterPluginRegistrar, _ contentInfoHandler: AdContentInfoMethodHandler) {
        super.init(with: registrar, on: "banner", contentInfoHandler)
    }

    override func onMethodCall(_ instance: BannerView, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "getCASId": getCASId(instance.banner, result)
        case "setCASId": setCASId(instance.banner, call, result)
        case "setSize": setSize(instance, call, result)
        case "isLoaded": isLoaded(instance.banner, result)
        case "getContentInfo": getContentInfo(instance.contentInfoId, result)
        case "isAutoloadEnabled": isAutoloadEnabled(instance.banner, result)
        case "setAutoloadEnabled": setAutoloadEnabled(instance.banner, call, result)
        case "load": load(instance.banner, result)
        case "getRefreshInterval": getRefreshInterval(instance.banner, result)
        case "setRefreshInterval": setRefreshInterval(instance.banner, call, result)
        case "disableAdRefresh": disableAdRefresh(instance.banner, result)
        case "dispose": dispose(instance, result)
        default: super.onMethodCall(instance, call, result)
        }
    }

    private func getCASId(_ bannerView: CASBannerView, _ result: @escaping FlutterResult) {
        result(bannerView.casID)
    }

    private func setCASId(_ bannerView: CASBannerView, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("casId", result) { casId in
            bannerView.casID = casId
        }
    }

    private func setSize(_ bannerView: BannerView, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let map = call.arguments as? [String: Any?] else {
            result(call.errorArgNil("arguments"))
            return
        }
        let adSize = BannerMethodHandler.getAdSize(map, nil) // bannerView.frame)
        bannerView.banner.adSize = adSize

        result(nil)
    }

    private func isLoaded(_ bannerView: CASBannerView, _ result: @escaping FlutterResult) {
        result(bannerView.isAdLoaded)
    }

    private func getContentInfo(_ contentInfoId: String, _ result: @escaping FlutterResult) {
        result(contentInfoId)
    }

    private func isAutoloadEnabled(_ bannerView: CASBannerView, _ result: @escaping FlutterResult) {
        result(bannerView.isAutoloadEnabled)
    }

    private func setAutoloadEnabled(_ bannerView: CASBannerView, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("isEnabled", result) { isEnabled in
            bannerView.isAutoloadEnabled = isEnabled
        }
    }

    private func load(_ bannerView: CASBannerView, _ result: @escaping FlutterResult) {
        bannerView.loadAd()
        result(nil)
    }

    private func getRefreshInterval(_ bannerView: CASBannerView, _ result: @escaping FlutterResult) {
        result(bannerView.refreshInterval)
    }

    private func setRefreshInterval(_ bannerView: CASBannerView, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("interval", result) { interval in
            bannerView.refreshInterval = interval
        }
    }

    private func disableAdRefresh(_ bannerView: CASBannerView, _ result: @escaping FlutterResult) {
        bannerView.disableAdRefresh()
        result(nil)
    }

    private func dispose(_ instance: BannerView, _ result: @escaping FlutterResult) {
        destroy(instance: instance)
        instance.banner.destroy()

        result(nil)
    }

    static func getAdSize(_ size: [String: Any?], _ frame: CGRect?) -> CASSize {
        if size["isAdaptive"] as? Bool == true {
            if let maxWidth = size["maxWidthDpi"] as? Int,
               maxWidth != 0 {
                return CASSize.getAdaptiveBanner(forMaxWidth: CGFloat(maxWidth))
            } else {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
                    return CASSize.banner
                }
                return CASSize.getAdaptiveBanner(inWindow: window)
            }
        } else {
            let width = size["width"] as? CGFloat ?? 0
            let mode = size["mode"] as? CGFloat ?? 0

            switch mode {
            case 2:
                return CASSize.getAdaptiveBanner(forMaxWidth: width)
            case 3:
                let height = size["height"] as? CGFloat ?? 0
                return CASSize.getInlineBanner(width: width, maxHeight: height)
            default: switch width {
                case 300: return CASSize.mediumRectangle
                case 728: return CASSize.leaderboard
                default: return CASSize.banner
                }
            }
        }
    }
}
