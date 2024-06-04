//
//  AdCallbackWrapper.swift
//  clever_ads_solutions
//
//  Created by Владислав Горик on 08.08.2023.
//

import Foundation
import CleverAdsSolutions

class AdCallbackWrapper : CASCallback, CASPaidCallback, CASBannerDelegate {
    
    let flutterCallback: CASFlutterCallback
    let withComplete: Bool
    
    init(flutterCallback: CASFlutterCallback, withComplete: Bool) {
        self.flutterCallback = flutterCallback
        self.withComplete = withComplete
    }
    
    func willShown(ad adStatus: CASImpression) {
        flutterCallback.onShown()
    }
    
    func didShowAdFailed(error: String) {
        flutterCallback.onShowFailed(message: error)
    }
    
    func didClickedAd() {
        flutterCallback.onClicked()
    }
    
    func didCompletedAd() {
        if (withComplete) {
            flutterCallback.onComplete()
        }
    }
    
    func didClosedAd() {
        flutterCallback.onClosed()
    }
    
    func onAdLoaded() {
        flutterCallback.onLoaded()
    }
    
    func onAdFailedToLoad(withError message: String?) {
        flutterCallback.onFailed(error: message)
    }
    
    func bannerAdView(_ adView: CASBannerView, didFailWith casError: CASError) {
        flutterCallback.onFailed(error: casError.message)
    }
    
    func didPayRevenue(for ad: CASImpression) {
        flutterCallback.onImpression(for: ad)
    }
}
