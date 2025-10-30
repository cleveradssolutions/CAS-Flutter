part of 'ad_instances.dart';

/// A banner ad.
///
/// To display this ad, instantiate an [CASWidget] with this as a parameter.
///
/// While the ad is loading, the widget will have a size of (1x1).
/// When the ad loads, the widget will automatically adopt the selected [size].
class CASBanner extends AdViewInstance {
  /// Create [CASBanner] and load ad content.
  ///
  /// - [size] - Represents the size of a banner ad.
  /// - [casId] - The unique identifier of the CAS content for each platform.
  /// Leave null to use the initialization identifier.
  /// - [autoReload] - If enabled, the ad will automatically retry loading the ad
  /// if an error occurs during the loading process.
  /// - [refreshInterval] - Sets the refresh interval in seconds for displaying
  /// ads. Set `0` to disable automatic refreshing. This automatic refresh works
  /// regardless of the [autoReload] setting. By default 30 seconds.
  /// - [onAdLoaded] - Callback to be invoked when the ad content has been successfully loaded.
  /// - [onAdFailedToLoad] - Callback to be invoked when the ad content fails to load.
  /// - [onAdImpression] - Callback to be invoked when an ad is estimated to have earned money.
  /// - [onAdClicked] - Callback to be invoked when the ad content is clicked by the user.
  CASBanner.createAndLoad({
    required this.size,
    String? casId,
    bool autoReload = true,
    int? refreshInterval,
    super.onAdLoaded,
    super.onAdFailedToLoad,
    super.onAdImpression,
    super.onAdClicked,
  }) : super(
            format: size.isInline
                ? AdFormat.inlineBanner
                : size.height >= 250
                    ? AdFormat.mediumRectangle
                    : AdFormat.banner) {
    casInternalBridge.createAdInstance(
      ad: this,
      shouldLoad: true,
      casId: casId,
      arguments: <String, dynamic>{
        'size': size,
        'autoload': autoReload,
        'refreshInterval':
            refreshInterval ?? casInternalBridge.defaultBannerRefreshInterval,
      },
    );
  }

  /// Represents the size of a banner ad.
  final AdSize size;

  /// If enabled, the ad will automatically retry loading the ad
  /// if an error occurs during the loading process.
  Future<void> setAutoReloadEnabled(bool isEnabled) {
    return casInternalBridge.setAutoloadEnabled(this, isEnabled);
  }

  /// Indicates whether the auto reload ad is currently enabled.
  Future<bool> isAutoReloadEnabled() {
    return casInternalBridge.isAutoloadEnabled(this);
  }

  /// Indicates whether the ad is currently loaded and ready to be shown.
  bool isLoaded() {
    return _platformViewSize != null;
  }

  /// Manual refresh ad or retry to load the ad.
  ///
  /// - If [CASBanner.isAutoReloadEnabled] is enabled,
  /// this function will be called automatically when necessary.
  /// - If [CASBanner.setRefreshInterval] not zero,
  /// this function will be called automatically to refresh ad.
  Future<void> load() {
    return casInternalBridge.loadAd(this);
  }

  /// Sets the refresh interval in seconds for displaying ads.
  /// The interval countdown runs only while the ad is visible on screen.
  /// Once the interval elapses, a new ad will automatically load and display.
  /// Set [interval] to `0` to disable automatic refreshing.
  ///
  /// Note: This automatic refresh works regardless of
  /// the [CASBanner.isAutoReloadEnabled] setting.
  Future<void> setRefreshInterval(int interval) {
    return casInternalBridge.setAdInterval(this, interval);
  }

  /// Gets the refresh interval in seconds for displaying ads.
  Future<int> getRefreshInterval() {
    return casInternalBridge.getAdInterval(this);
  }

  /// Returns the View Size of the associated platform ad object.
  ///
  /// The dimensions of the [AdSize] returned here may differ from [size],
  /// depending on what type of [AdSize] was used.
  ///
  /// Return null if ad has not been loaded yet.
  Size? get platformViewSize => _platformViewSize;

  /// Set the View Size of the associated platform ad object.
  set platformViewSize(Size? newSize) {
    _platformViewSize = newSize;
    if (newSize != null) {
      _onPlatformViewSizeChanged?.call(this, newSize);
    }
  }

  /// The AdSize of the associated platform ad object.
  Size? _platformViewSize;

  /// Platform View Size Changed listener.
  void Function(AdViewInstance ad, Size size)? _onPlatformViewSizeChanged;
}
