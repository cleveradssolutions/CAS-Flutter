import CleverAdsSolutions

/// The factory of `CASNativeView` used to display a `NativeAdContent`.
///
/// Added to a `CASMobileAdsPlugin` and creates `CASNativeView`s from Native Ads created in Dart.
@objc(CASNativeAdViewFactory)
public protocol CASNativeAdViewFactory: AnyObject {
    /// Creates a `CASNativeView` with a `NativeAdContent`.
    ///
    /// - Parameter adContent Ad content information used to create a `CASNativeView`.
    /// - Parameter customOptions Used to pass additional custom options to create the `CASNativeView`.
    /// - Returns a `CASNativeView` that is overlaid on top of the FlutterView. Or nil to fire failed to load of Native ads.
    @objc
    func createNativeAdView(for adContent: NativeAdContent, customOptions: [String: Any]) -> CASNativeView?
}
