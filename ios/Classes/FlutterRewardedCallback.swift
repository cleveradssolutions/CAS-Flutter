import CleverAdsSolutions
import Foundation

class FlutterRewardedCallback: CASPaidCallback {
    weak var handler: CASChannel?

    func onAdLoaded() {
        handler?.invokeMethod("OnRewardedAdLoaded")
    }

    func onAdFailedToLoad(withError message: String?) {
        handler?.invokeMethod("OnRewardedAdFailedToLoad", message)
    }

    func willShown(ad adStatus: CASImpression) {
        handler?.invokeMethod("OnRewardedAdShown")
    }

    func didPayRevenue(for ad: CASImpression) {
        handler?.invokeMethod("OnRewardedAdImpression", ad.toDict())
    }

    func didShowAdFailed(error: String) {
        handler?.invokeMethod("OnRewardedAdFailedToShow", error)
    }

    func didClickedAd() {
        handler?.invokeMethod("OnRewardedAdClicked")
    }

    func didCompletedAd() {
        handler?.invokeMethod("OnRewardedAdCompleted")
    }

    func didClosedAd() {
        handler?.invokeMethod("OnRewardedAdClosed")
    }
}
