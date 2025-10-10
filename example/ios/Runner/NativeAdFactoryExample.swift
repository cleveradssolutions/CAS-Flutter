import clever_ads_solutions
import CleverAdsSolutions
import Foundation

class NativeAdFactoryExample: NSObject, CASNativeAdViewFactory {
    func createNativeAdView(for adContent: NativeAdContent,
                            customOptions: [String: Any]) -> CASNativeView? {
        // Assumes that your ad layout is in a file called `NativeAdView.xib`.
        let adView = Bundle.main.loadNibNamed(
            "NativeAdView", owner: nil
        )!.first as! CASNativeView

        // Simply register all the ad assets that are used.
        // CAS will automatically fill in the advertising content in them,
        // or hide the view if the ad asset was not provided in the ad content.
        adView.registerMediaView(tag: 100)
        adView.registerIconView(tag: 101)
        adView.registerHeadlineView(tag: 102)
        adView.registerAdLabelView(tag: 103)
        adView.registerBodyView(tag: 104)
        adView.registerCallToActionView(tag: 105)
        adView.registerAdvertiserView(tag: 106)
        adView.registerStoreView(tag: 107)
        adView.registerPriceView(tag: 108)
        adView.registerStarRatingView(tag: 109)
        adView.registerReviewCountView(tag: 110)

        // The CAS Flutter plugin will automatically call
        // `adView.setNativeAd(nativeAd)` later in any case.
        return adView
    }
}
