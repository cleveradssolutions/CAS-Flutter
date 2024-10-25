import CleverAdsSolutions
import Foundation

class FlutterAppReturnCallback: CASAppReturnDelegate {
    private var handler: MethodHandler?

    func setMethodHandler(handler: MethodHandler) {
        self.handler = handler
    }

    func willShown(ad adStatus: CASImpression) {
        handler?.invokeMethod("OnAppReturnAdShown")
    }

    func didPayRevenue(for ad: CASImpression) {
        handler?.invokeMethod("OnAppReturnAdImpression", ad.toDict())
    }

    func didShowAdFailed(error: String) {
        handler?.invokeMethod("OnAppReturnAdFailedToShow", error)
    }

    func didClickedAd() {
        handler?.invokeMethod("OnAppReturnAdClicked")
    }

    func didClosedAd() {
        handler?.invokeMethod("OnAppReturnAdClosed")
    }

    func viewControllerForPresentingAppReturnAd() -> UIViewController {
        return Util.findRootViewController()!
    }
}
