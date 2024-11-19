//
//  AppOpenMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions

class ContentCallback: CASCallback {
    private var handler: MethodHandler?

    func setMethodHandler(handler: MethodHandler) {
        self.handler = handler
    }

    func willShown(ad adStatus: any CASImpression) {
        handler?.invokeMethod("onShown", adStatus.toDict())
    }

    func didShowAdFailed(error: String) {
        handler?.invokeMethod("onShowFailed", error)
    }

    func didClosedAd() {
        handler?.invokeMethod("onClosed")
    }
}
