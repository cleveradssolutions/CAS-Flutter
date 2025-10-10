import CleverAdsSolutions

protocol FlutterAd: AnyObject {
    var adId: Int { get }

    var contentInfo: AdContentInfo? { get }

    var isAutoloadEnabled: Bool { get set }
    var isAutoshowEnabled: Bool { get set }
    var interval: Int { get set }

    func isAdLoaded() -> Bool

    func loadAd()

    /**
     * Invoked when dispose() is called on the corresponding Flutter ad object. This perform any
     * necessary cleanup.
     */
    func disposeAd()
}
