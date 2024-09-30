//
//  BannerMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter
import Foundation

private let logTag = "BannerMethodHandler"
private let channelName = "com.cleveradssolutions.plugin.flutter/banner."

class BannerMethodHandler: MethodHandler {
    private let bannerView: CASBannerView
    private let bridgeProvider: () -> CASBridge?
    private let disposeBanner: () -> ()

    init(_ flutterId: String, _ bannerView: CASBannerView, _ bridgeProvider: @escaping () -> CASBridge?, _ disposeBanner: @escaping () -> ()) {
        self.bannerView = bannerView
        self.bridgeProvider = bridgeProvider
        self.disposeBanner = disposeBanner
        super.init(channelName: channelName + flutterId)
    }

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "isAdReady": result(bannerView.isAdReady)
        case "loadNextAd": bannerView.loadNextAd()

        case "createBannerView": createBannerView(call, result)
        case "loadBanner": loadBanner(call, result)
        case "isBannerReady": isBannerReady(call, result)
        case "showBanner": showBanner(call, result)
        case "hideBanner": hideBanner(call, result)
        case "setBannerPosition": setBannerPosition(call, result)
        case "setBannerAdRefreshRate": setBannerAdRefreshRate(call, result)
        case "disableBannerRefresh": disableBannerRefresh(call, result)
        case "dispose": dispose(call, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func createBannerView(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any?],
           let sizeId = args["sizeId"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.showGlobalBannerAd(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func loadBanner(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.loadNextBanner(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func isBannerReady(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            result(Bool(CASFlutter.cleverAdsSolutions.getCasBridge()?.isBannerViewAdReady(sizeId: sizeId) ?? false))
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func showBanner(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.showGlobalBannerAd(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func hideBanner(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.hideBanner(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func setBannerPosition(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int,
           let positionId = args["positionId"] as? Int,
           let xOffset = args["x"] as? Int,
           let yOffset = args["y"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.setBannerPosition(sizeId: sizeId, positionId: positionId, x: xOffset, y: yOffset)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func setBannerAdRefreshRate(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int,
           let interval = args["refresh"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.setBannerAdRefreshRate(refresh: interval, sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func disableBannerRefresh(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.disableBannerRefresh(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func dispose(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        disposeBanner()
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.disposeBanner(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }
}
