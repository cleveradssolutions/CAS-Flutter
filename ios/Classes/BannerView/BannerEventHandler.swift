//
//  BannerViewEventListener.swift
//  clever_ads_solutions
//
//  Created by MacMini on 2.04.24.
//

import CleverAdsSolutions
import Flutter
import Foundation

private let channelName = "com.cleveradssolutions.plugin.flutter/banner."

class BannerEventHandler: EventHandler, CASBannerDelegate {
    init(_ flutterId: String) {
        super.init(channelName: channelName + flutterId)
    }

    func bannerAdViewDidLoad(_ view: CASBannerView) {
        success(["event": "onAdViewLoaded"])
    }

    func bannerAdView(_ adView: CASBannerView, didFailWith error: CASError) {
        success([
            "event": "onAdViewFailed",
            "data": error.message,
        ])
    }

    func bannerAdView(_ adView: CASBannerView, willPresent impression: CASImpression) {
        success([
            "event": "onAdViewPresented",
            "data": impression.toDict(),
        ])
    }

    func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
        success(["event": "onAdViewClicked"])
    }
}
