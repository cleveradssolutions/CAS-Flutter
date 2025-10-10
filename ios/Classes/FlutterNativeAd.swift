import CleverAdsSolutions
import Flutter

class FlutterNativeAd: NSObject, FlutterAd, FlutterPlatformView, CASNativeLoaderDelegate, CASNativeContentDelegate, CASImpressionDelegate {
    let adId: Int
    private let manager: AdInstanceManager
    private let viewFactory: CASNativeAdViewFactory?
    private let loader: CASNativeLoader
    private var adContent: NativeAdContent?
    private var adView: CASNativeView
    private let customOptions: [String: Any]
    private let templateStyle: NativeTemplateStyle?
    private var templateSize: AdSize?

    init(adId: Int,
         manager: AdInstanceManager,
         call: FlutterMethodCall,
         casID: String,
         viewFactory: CASNativeAdViewFactory?) {
        self.adId = adId
        self.manager = manager
        self.viewFactory = viewFactory
        loader = CASNativeLoader(casID: casID)

        customOptions = call.argument("customOptions") ?? [String: Any]()
        templateStyle = call.argument("templateStyle")

        adView = CASNativeView(frame: .zero)
        super.init()

        loader.delegate = self

        if let placementId: Int = call.argument("adChoicesPlacement"), placementId >= 0, let placement = AdChoicesPlacement(rawValue: placementId) {
            loader.adChoicesPlacement = placement
        }
        if let muted: Bool = call.argument("startVideoMuted") {
            loader.isStartVideoMuted = muted
        }
    }
    
    func view() -> UIView {
        adView
    }

    var contentInfo: AdContentInfo? {
        adContent?.contentInfo
    }

    var isAutoloadEnabled: Bool {
        get { false }
        set {}
    }

    var isAutoshowEnabled: Bool {
        get { false }
        set {}
    }

    var interval: Int {
        get { 0 }
        set {}
    }

    func isAdLoaded() -> Bool {
        adContent?.isExpired == false
    }

    func loadAd() {
        loader.loadAd()
    }

    func updatePlatformView(width: CGFloat, height: CGFloat) {
        if viewFactory == nil {
            let size = templateSize
            if size?.width != width || size?.height != height {
                let newSize = AdSize.getInlineBanner(width: width, maxHeight: height)
                templateSize = newSize
                adView.setAdTemplateSize(newSize)
                templateStyle?.applyToView(adView)
                adView.setNativeAd(adContent)
            }
        }
    }

    func disposeAd() {
        adContent?.destroy()
        adContent = nil
    }

    func nativeAdDidLoadContent(_ ad: NativeAdContent) {
        adContent = ad

        if let viewFactory {
            guard let view = viewFactory.createNativeAdView(
                for: ad,
                customOptions: customOptions) else {
                manager.onAdFailedToLoad(
                    adId: adId,
                    error: AdError(
                        AdErrorCode.internalError,
                        "Custom Native Ad View factory not create view."
                    )
                )
                return
            }
            view.setNativeAd(ad)

            if adContent == nil {
                // onNativeAdFailedToShow called from setNativeAd()
                // so adContent already destroyed
                return
            }
            templateStyle?.applyToView(view)
            adView = view
        }

        ad.delegate = self
        ad.impressionDelegate = self

        manager.onAdLoaded(adId: adId)
    }

    func nativeAdDidFailToLoad(error: AdError) {
        manager.onAdFailedToLoad(adId: adId, error: error)
    }

    func nativeAdDidClickContent(_ ad: NativeAdContent) {
        manager.onAdClicked(adId: adId)
    }

    func nativeAd(_ ad: NativeAdContent, didFailToPresentWithError error: AdError) {
        disposeAd()
        manager.onAdFailedToLoad(adId: adId, error: error)
    }

    func adDidRecordImpression(info: AdContentInfo) {
        manager.onAdImpression(adId: adId, contentInfo: info)
    }
}
