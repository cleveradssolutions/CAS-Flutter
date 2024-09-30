//
//  BannerMethodHandler.swift
//  clever_ads_solutions
//
//  Created by Dmytro Uzhva on 24.09.2024.
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
        super.init(channelName: channelName + flutterId)
        self.bannerView = bannerView
        self.bridgeProvider = bridgeProvider
        self.disposeBanner = disposeBanner
    }

    override func onMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isAdReady": result(bannerView.isAdReady)
        case "loadNextAd": bannerView.loadNextAd()

        case "createBannerView": createBannerView(call: call, result: result)
        case "loadBanner": loadBanner(call: call, result: result)
        case "isBannerReady": isBannerReady(call: call, result: result)
        case "showBanner": showBanner(call: call, result: result)
        case "hideBanner": hideBanner(call: call, result: result)
        case "setBannerPosition": setBannerPosition(call: call, result: result)
        case "setBannerAdRefreshRate": setBannerAdRefreshRate(call: call, result: result)
        case "disableBannerRefresh": disableBannerRefresh(call: call, result: result)
        case "dispose": dispose(call: call, result: result)
        default: super.onMethodCall(call: call, result: result)
        }
    }

    private func createBannerView(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? [String: Any?],
           let sizeId = args["sizeId"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.showGlobalBannerAd(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func loadBanner(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.loadNextBanner(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func isBannerReady(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            result(Bool(CASFlutter.cleverAdsSolutions.getCasBridge()?.isBannerViewAdReady(sizeId: sizeId) ?? false))
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func showBanner(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.showGlobalBannerAd(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func hideBanner(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.hideBanner(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func setBannerPosition(call: FlutterMethodCall, result: @escaping FlutterResult) {
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

    private func setBannerAdRefreshRate(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int,
           let interval = args["refresh"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.setBannerAdRefreshRate(refresh: interval, sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func disableBannerRefresh(call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let args = call.arguments as? Dictionary<String, Any>,
           let sizeId = args["sizeId"] as? Int {
            CASFlutter.cleverAdsSolutions.getCasBridge()?.disableBannerRefresh(sizeId: sizeId)
            result(nil)
        } else {
            result(FlutterError(code: "", message: "Bad argument", details: nil))
        }
    }

    private func dispose(call: FlutterMethodCall, result: @escaping FlutterResult) {
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
