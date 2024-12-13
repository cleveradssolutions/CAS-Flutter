//
//  AppOpenMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions

class BannerCallback: MappedCallback, CASBannerDelegate {
    func bannerAdViewDidLoad(_ view: CASBannerView) {
        invokeMethod("onAdViewLoaded")
    }

    func bannerAdView(_ adView: CASBannerView, didFailWith error: CASError) {
        invokeMethod("onAdViewFailed", ["error": error.message])
    }

    func bannerAdView(_ adView: CASBannerView, willPresent impression: CASImpression) {
        invokeMethod("onAdViewPresented", impression.toDict())
    }

    func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
        invokeMethod("onAdViewClicked")
    }
}
