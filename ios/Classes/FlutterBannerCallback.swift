import Foundation
import CleverAdsSolutions

public class FlutterBannerCallback : CASBannerDelegate, FlutterCaller {
    
    private var sizeId = 0;
    
    init(sizeId: Int) {
        self.sizeId = sizeId
    }
    
    var flutterCaller: completion?
    
    func setFlutterCaller(caller: @escaping(completion)) {
        flutterCaller = caller
    }
    
    public func bannerAdViewDidLoad(_ view: CleverAdsSolutions.CASBannerView) {
        flutterCaller?(String(sizeId) + "OnBannerAdLoaded", nil)
    }

    public func bannerAdView(_ adView: CleverAdsSolutions.CASBannerView, didFailWith error: CleverAdsSolutions.CASError) {
        var args = [String: Any]()
        args["message"] = error.message
        flutterCaller?(String(sizeId) + "OnBannerAdFailedToLoad", args)
    }

    public func bannerAdView(_ adView: CleverAdsSolutions.CASBannerView, willPresent impression: CleverAdsSolutions.CASImpression) {
        flutterCaller?(String(sizeId) + "OnBannerAdShown", nil)
        flutterCaller?(String(sizeId) + "OnBannerAdImpression", impression.toDict())
    }

    public func bannerAdViewDidRecordClick(_ adView: CleverAdsSolutions.CASBannerView) {
        flutterCaller?(String(sizeId) + "OnBannerAdClicked", nil)
    }
}
