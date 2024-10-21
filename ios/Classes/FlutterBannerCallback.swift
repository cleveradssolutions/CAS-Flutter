import CleverAdsSolutions
import Foundation

public class FlutterBannerCallback: CASBannerDelegate, FlutterCaller {
    private var sizeId = 0

    init(sizeId: Int) {
        self.sizeId = sizeId
    }

    var flutterCaller: completion?

    func setFlutterCaller(caller: @escaping (completion)) {
        flutterCaller = caller
    }

    public func bannerAdViewDidLoad(_ view: CleverAdsSolutions.CASBannerView) {
        let args = ["name": "banner"]
        flutterCaller?("OnBannerAdLoaded", args)
    }

    public func bannerAdView(_ adView: CleverAdsSolutions.CASBannerView, didFailWith error: CleverAdsSolutions.CASError) {
        let args = ["name": "banner", "message": error.message]
        flutterCaller?("OnBannerAdFailedToLoad", args)
    }

    public func bannerAdView(_ adView: CleverAdsSolutions.CASBannerView, willPresent impression: CleverAdsSolutions.CASImpression) {
        let args: [String: Any?] = ["name": "banner"]
        flutterCaller?("OnBannerAdShown", args)
        flutterCaller?("OnBannerAdImpression", args.merging(impression.toDict()) { current, _ in current })
    }

    public func bannerAdViewDidRecordClick(_ adView: CleverAdsSolutions.CASBannerView) {
        let args = ["name": "banner"]
        flutterCaller?("OnBannerAdClicked", args)
    }
}
