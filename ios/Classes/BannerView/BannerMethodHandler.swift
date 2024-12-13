//
//  BannerMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter
import Foundation

private let channelName = "cleveradssolutions/banner"

class BannerMethodHandler: MappedMethodHandler<BannerView> {
    init(with registrar: FlutterPluginRegistrar) {
        super.init(with: registrar, on: channelName)
    }

    override func onMethodCall(_ bannerView: BannerView, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        switch call.method {
        case "isAdReady": isAdReady(bannerView.banner, call, result)
        case "loadNextAd": loadNextAd(bannerView.banner, call, result)
        case "setBannerAdRefreshRate": setBannerAdRefreshRate(bannerView.banner, call, result)
        case "disableBannerRefresh": disableBannerRefresh(bannerView.banner, call, result)
        case "dispose": dispose(bannerView, call, result)
        default: super.onMethodCall(call, result)
        }
    }

    private func isAdReady(_ bannerView: CASBannerView, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        result(bannerView.isAdReady)
    }

    private func loadNextAd(_ bannerView: CASBannerView, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        bannerView.loadNextAd()
        result(nil)
    }

    private func setBannerAdRefreshRate(_ bannerView: CASBannerView, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        call.getArgAndReturn("refresh", result) { interval in
            bannerView.refreshInterval = interval
        }
    }

    private func disableBannerRefresh(_ bannerView: CASBannerView, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        bannerView.disableAdRefresh()
        result(nil)
    }

    private func dispose(_ bannerView: BannerView, _ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        bannerView.banner.destroy()
        _ = remove(bannerView.id)
        result(nil)
    }
}
