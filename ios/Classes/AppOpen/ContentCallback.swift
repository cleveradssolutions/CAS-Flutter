//
//  AppOpenMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions

class ContentCallback: MappedCallback, CASPaidCallback {
    func willShown(ad: any CASImpression) {
        invokeMethod("onShown", ad.toDict())
    }

    func didShowAdFailed(error: String) {
        invokeMethod("onShowFailed", ["error": error])
    }

    func didClickedAd() {
        invokeMethod("onClicked")
    }

    func didPayRevenue(for ad: any CASImpression) {
        invokeMethod("onAdRevenuePaid", ad.toDict())
    }

    func didClosedAd() {
        invokeMethod("onClosed")
    }
}
