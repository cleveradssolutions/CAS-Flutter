import CleverAdsSolutions
import Flutter

class AdInstanceManager {
    let channel: FlutterMethodChannel

    private var ads = [Int: FlutterAd]()
    private let adsLockQueue = DispatchQueue(label: "CASMobileAdsInstancesLockQueue", attributes: .concurrent)

    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }

    func findAd(_ adId: Int) -> FlutterAd? {
        adsLockQueue.sync {
            ads[adId]
        }
    }

    func trackAd(_ ad: FlutterAd) {
        adsLockQueue.async(flags: .barrier) {
            self.ads[ad.adId] = ad
        }
    }

    func disposeAd(_ adId: Int) {
        var ad: FlutterAd?
        adsLockQueue.sync {
            ad = self.ads.removeValue(forKey: adId)
        }
        ad?.disposeAd()
    }

    func disposeAllAds() {
        let all = ads
        ads = [Int: FlutterAd]()

        for item in all {
            item.value.disposeAd()
        }
    }

    func onAdLoaded(adId: Int, size: CGSize? = nil) {
        let args: [String: Any?] = [
            "adId": adId,
            "size": size,
        ]
        channel.invokeMethod("onAdLoaded", arguments: args)
    }

    func onAdFailedToLoad(adId: Int, error: AdError) {
        let args: [String: Any] = [
            "adId": adId,
            "error": error,
        ]
        channel.invokeMethod("onAdFailedToLoad", arguments: args)
    }

    func onAdFailedToShow(adId: Int, error: AdError) {
        let args: [String: Any] = [
            "adId": adId,
            "error": error,
        ]
        channel.invokeMethod("onAdFailedToShow", arguments: args)
    }

    func onAdShowed(adId: Int) {
        invokeOnAdEvent("onAdShowed", adId: adId)
    }

    func onAdClicked(adId: Int) {
        invokeOnAdEvent("onAdClicked", adId: adId)
    }

    func onAdImpression(adId: Int, contentInfo: AdContentInfo) {
        let args: [String: Any] = [
            "adId": adId,
            "info": contentInfo,
        ]
        channel.invokeMethod("onAdImpression", arguments: args)
    }

    func onAdDismissed(adId: Int) {
        invokeOnAdEvent("onAdDismissed", adId: adId)
    }

    func onAdUserEarnedReward(adId: Int) {
        invokeOnAdEvent("onAdUserEarnedReward", adId: adId)
    }

    private func invokeOnAdEvent(_ name: String, adId: Int) {
        channel.invokeMethod(name, arguments: ["adId": adId])
    }
}
