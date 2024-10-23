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

class BannerMethodHandler: MethodHandler, CASBannerDelegate {
    private let bannerView: CASBannerView

    init(
        with registrar: FlutterPluginRegistrar,
        _ flutterId: String,
        _ bannerView: CASBannerView
    ) {
        self.bannerView = bannerView
        super.init(with: registrar, on: channelName + flutterId)
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

    func bannerAdViewDidLoad(_ view: CASBannerView) {
        invokeMethod(methodName: "onAdViewLoaded")
    }

    func bannerAdView(_ adView: CASBannerView, didFailWith error: CASError) {
        invokeMethod(methodName: "onAdViewFailed", args: error.message)
    }

    func bannerAdView(_ adView: CASBannerView, willPresent impression: CASImpression) {
        invokeMethod(methodName: "onAdViewPresented", args: impression.toDict())
    }

    func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
        invokeMethod(methodName: "onAdViewClicked")
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
        bannerView.destroy()
        result(nil)
    }
}
