import CleverAdsSolutions
import Flutter

class FlutterBannerAd: NSObject, FlutterAd, FlutterPlatformView, CASImpressionDelegate, CASBannerDelegate {
    
    let adId: Int
    let manager: AdInstanceManager
    let bannerView: CASBannerView

    init(adId: Int, manager: AdInstanceManager, bannerView: CASBannerView) {
        self.adId = adId
        self.manager = manager
        self.bannerView = bannerView
        super.init()
        bannerView.delegate = self
        bannerView.impressionDelegate = self
    }
    
    func view() -> UIView {
        bannerView
    }

    var contentInfo: AdContentInfo? {
        bannerView.contentInfo
    }

    var isAutoloadEnabled: Bool {
        get { bannerView.isAutoloadEnabled }
        set { bannerView.isAutoloadEnabled = newValue }
    }

    var isAutoshowEnabled: Bool {
        get { false }
        set {}
    }

    var interval: Int {
        get { bannerView.refreshInterval }
        set { bannerView.refreshInterval = newValue }
    }

    func isAdLoaded() -> Bool {
        bannerView.isAdLoaded
    }

    func loadAd() {
        bannerView.loadAd()
    }

    func disposeAd() {
        bannerView.destroy()
    }

    func bannerAdViewDidLoad(_ view: CASBannerView) {
        manager.onAdLoaded(adId: adId, size: view.intrinsicContentSize)
    }

    func bannerAdView(_ adView: CASBannerView, didFailWith error: AdError) {
        manager.onAdFailedToLoad(adId: adId, error: error)
    }

    func bannerAdViewDidRecordClick(_ adView: CASBannerView) {
        manager.onAdClicked(adId: adId)
    }

    func adDidRecordImpression(info: AdContentInfo) {
        manager.onAdImpression(adId: adId, contentInfo: info)
    }
}
