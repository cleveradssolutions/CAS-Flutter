import CleverAdsSolutions
import Foundation

class FlutterInterstitialCallback: CASPaidCallback {
    private var handler: MethodHandler?

    func setMethodHandler(handler: MethodHandler) {
        self.handler = handler
    }

    func onAdLoaded() {
        handler?.invokeMethod("OnInterstitialAdLoaded")
    }

    func onAdFailedToLoad(withError message: String?) {
        handler?.invokeMethod("OnInterstitialAdFailedToLoad", message)
    }

    func willShown(ad adStatus: CASImpression) {
        handler?.invokeMethod("OnInterstitialAdShown")
    }

    func didPayRevenue(for ad: CASImpression) {
        handler?.invokeMethod("OnInterstitialAdImpression", ad.toDict())
    }

    func didShowAdFailed(error: String) {
        handler?.invokeMethod("OnInterstitialAdFailedToShow", error)
    }

    func didClickedAd() {
        handler?.invokeMethod("OnInterstitialAdClicked")
    }

    func didClosedAd() {
        handler?.invokeMethod("OnInterstitialAdClosed")
    }
}
