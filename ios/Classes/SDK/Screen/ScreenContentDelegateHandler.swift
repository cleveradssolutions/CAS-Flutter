//
//  CASScreenContentDelegateHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2025 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions
import Flutter

class ScreenContentDelegateHandler: MappedCallback, CASScreenContentDelegate {
    private let handler: AdMethodHandlerProtocol
    private let contentInfoId: String

    init(_ handler: AdMethodHandlerProtocol, _ id: String, _ contentInfoId: String) {
        self.handler = handler
        self.contentInfoId = contentInfoId
        super.init(handler, id)
    }

    func screenAdDidLoadContent(_ ad: CASScreenContent) {
        handler.onAdContentLoaded(contentInfoId, ad.contentInfo)
        invokeMethod("onAdLoaded", ["contentInfoId": contentInfoId])
    }

    func screenAd(_ ad: CASScreenContent, didFailToLoadWithError error: AdError) {
        invokeMethod(
            "onAdFailedToLoad",
            [
                "format": ad.contentInfo?.format.value,
                "error": error.toDict(),
            ]
        )
    }

    func screenAdWillPresentContent(_ ad: CASScreenContent) {
        invokeMethod("onAdShowed", ["contentInfoId": contentInfoId])
    }

    func screenAd(_ ad: CASScreenContent, didFailToPresentWithError error: AdError) {
        invokeMethod(
            "onAdFailedToShow",
            [
                "format": ad.contentInfo?.format.value,
                "error": error.toDict(),
            ]
        )
    }

    func screenAdDidClickContent(_ ad: CASScreenContent) {
        invokeMethod("onAdClicked", ["contentInfoId": contentInfoId])
    }

    func screenAdDidDismissContent(_ ad: CASScreenContent) {
        invokeMethod("onAdDismissed", ["contentInfoId": contentInfoId])
    }
}
