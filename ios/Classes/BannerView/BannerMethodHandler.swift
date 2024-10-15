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
    private let disposeBanner: () -> Void

    init(_ flutterId: String, _ bannerView: CASBannerView, _ bridgeProvider: @escaping () -> CASBridge?, _ disposeBanner: @escaping () -> Void) {
        self.bannerView = bannerView
        self.bridgeProvider = bridgeProvider
        self.disposeBanner = disposeBanner
        super.init(channelName: channelName + flutterId)
    }

    override func onMethodCall(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "isAdReady": isAdReady(call, result)
        case "loadNextAd": loadNextAd(call, result)
        case "setBannerAdRefreshRate": setBannerAdRefreshRate(call, result)
        case "disableBannerRefresh": disableBannerRefresh(call, result)
        case "dispose": dispose(call, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func isAdReady(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        result(bannerView.isAdReady)
    }

    private func loadNextAd(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        bannerView.loadNextAd()
        result(nil)
    }

    private func setBannerAdRefreshRate(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("refresh", result) { interval in
            bannerView.refreshInterval = interval
        }
    }

    private func disableBannerRefresh(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        bannerView.disableAdRefresh()
        result(nil)
    }

    private func dispose(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        disposeBanner()
        result(nil)
    }
}
