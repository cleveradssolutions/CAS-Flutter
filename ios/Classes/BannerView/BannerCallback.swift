//
//  AppOpenMethodHandler.swift
//  clever_ads_solutions
//
//  Copyright © 2024 CleverAdsSolutions LTD, CAS.AI. All rights reserved.
//

import CleverAdsSolutions

class BannerCallback: MappedCallback, CASBannerDelegate {
    private let sizeListener: BannerSizeListener

    init(_ sizeListener: BannerSizeListener, _ handler: AnyMappedMethodHandler, _ id: String) {
        self.sizeListener = sizeListener
        super.init(handler, id)
    }

    func bannerAdViewDidLoad(_ view: CASBannerView) {
        invokeMethod("onAdViewLoaded")

        let size = view.intrinsicContentSize
        sizeListener.updateSize(size.width, size.height)
    }

    func bannerAdView(_ adView: CASBannerView, didFailWith error: CASError) {
        invokeMethod("onAdViewFailed", ["error": error.message])

        sizeListener.updateSize(0, 0)
    }

    func bannerAdView(_ adView: CASBannerView, willPresent impression: CASImpression) {
        invokeMethod("onAdViewPresented", impression.toDict())
    }

    func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
        invokeMethod("onAdViewClicked")
    }
}
