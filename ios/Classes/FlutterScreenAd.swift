import CleverAdsSolutions

class FlutterScreenAd: NSObject, FlutterAd, CASImpressionDelegate, CASScreenContentDelegate {
    let adId: Int
    let manager: AdInstanceManager
    let screenAd: CASScreenContent

    init(adId: Int, manager: AdInstanceManager, screenAd: CASScreenContent) {
        self.adId = adId
        self.manager = manager
        self.screenAd = screenAd
        super.init()
        screenAd.delegate = self
        screenAd.impressionDelegate = self
    }

    var contentInfo: AdContentInfo? {
        screenAd.contentInfo
    }

    var isAutoloadEnabled: Bool {
        get { screenAd.isAutoloadEnabled }
        set { screenAd.isAutoloadEnabled = newValue }
    }

    var isAutoshowEnabled: Bool {
        get {
            if let inter = screenAd as? CASInterstitial {
                return inter.isAutoshowEnabled
            }
            if let appOpen = screenAd as? CASAppOpen {
                return appOpen.isAutoshowEnabled
            }
            return false
        }
        set {
            if let inter = screenAd as? CASInterstitial {
                inter.isAutoshowEnabled = newValue
            } else if let appOpen = screenAd as? CASAppOpen {
                appOpen.isAutoshowEnabled = newValue
            }
        }
    }

    var interval: Int {
        get {
            if let inter = screenAd as? CASInterstitial {
                return inter.minInterval
            }
            return 0
        }
        set {
            if let inter = screenAd as? CASInterstitial {
                inter.minInterval = newValue
            }
        }
    }

    func isAdLoaded() -> Bool {
        screenAd.isAdLoaded
    }

    func loadAd() {
        screenAd.loadAd()
    }

    func showScreenAd() {
        if let inter = screenAd as? CASInterstitial {
            inter.present()
        } else if let appOpen = screenAd as? CASAppOpen {
            appOpen.present()
        } else if let rewarded = screenAd as? CASRewarded {
            rewarded.present { _ in
                self.manager.onAdUserEarnedReward(adId: self.adId)
            }
        }
    }

    func disposeAd() {
        screenAd.destroy()
    }

    func screenAdDidLoadContent(_ ad: any CASScreenContent) {
        manager.onAdLoaded(adId: adId)
    }

    func screenAd(_ ad: any CASScreenContent, didFailToLoadWithError error: AdError) {
        manager.onAdFailedToLoad(adId: adId, error: error)
    }

    func screenAd(_ ad: any CASScreenContent, didFailToPresentWithError error: AdError) {
        manager.onAdFailedToShow(adId: adId, error: error)
    }

    func screenAdWillPresentContent(_ ad: any CASScreenContent) {
        manager.onAdShowed(adId: adId)
    }

    func screenAdDidClickContent(_ ad: any CASScreenContent) {
        manager.onAdClicked(adId: adId)
    }

    func screenAdDidDismissContent(_ ad: any CASScreenContent) {
        manager.onAdDismissed(adId: adId)
    }

    func adDidRecordImpression(info: AdContentInfo) {
        manager.onAdImpression(adId: adId, contentInfo: info)
    }
}
