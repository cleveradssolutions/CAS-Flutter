import CleverAdsSolutions
import Foundation

class FlutterBannerCallback: CASBannerDelegate {
    private var handler: MethodHandler?
    private var sizeId = 0

    init(sizeId: Int) {
        self.sizeId = sizeId
    }

    func setMethodHandler(handler: MethodHandler) {
        self.handler = handler
    }

    func bannerAdViewDidLoad(_ view: CleverAdsSolutions.CASBannerView) {
        handler?.invokeMethod("OnBannerAdLoaded", ["name": "banner"])
    }

    func bannerAdView(_ adView: CleverAdsSolutions.CASBannerView, didFailWith error: CleverAdsSolutions.CASError) {
        handler?.invokeMethod("OnBannerAdFailedToLoad", [
            "name": "banner",
            "message": error.message
        ])
    }

    func bannerAdView(_ adView: CleverAdsSolutions.CASBannerView, willPresent impression: CleverAdsSolutions.CASImpression) {
        let args: [String: Any?] = ["name": "banner"]
        handler?.invokeMethod("OnBannerAdShown", args)
        handler?.invokeMethod("OnBannerAdImpression", args.merging(impression.toDict()) { current, _ in current })
    }

    func bannerAdViewDidRecordClick(_ adView: CleverAdsSolutions.CASBannerView) {
        handler?.invokeMethod("OnBannerAdClicked", ["name": "banner"])
    }
}
