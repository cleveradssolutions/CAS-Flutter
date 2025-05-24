import '../ad_content_info.dart';
import '../on_ad_impression_listener.dart';
import 'internal/cas_interstitial_impl.dart';
import 'screen_ad_content_callback.dart';

/// Manages an interstitial ad, allowing for loading, showing, and destroying the ad content.
///
/// This class provides functionality to handle interstitial ads, which are full-screen ads that cover the entire
/// screen and are typically used at natural transition points within an app.
///
/// [casId] The unique identifier for the CAS content, typically an application bundle name.
abstract class CASInterstitial {
  static CASInterstitial create(String casId) {
    return CASInterstitialImpl(casId);
  }

  /// Gets or sets the callback for handling ad content events.
  ///
  /// This callback is used to handle various ad content events, such as when the ad is loaded, failed to load,
  /// or shown. Setting this property allows you to respond to these events as needed.
  abstract ScreenAdContentCallback? contentCallback;

  /// Gets or sets the listener for ad impression events.
  ///
  /// This listener is notified when an ad impression is recorded and will be paid. It allows you to track when
  /// the ad has been successfully shown and the impression has been accounted for. You can use this to handle
  /// actions that should occur upon a successful ad impression, such as logging or updating analytics.
  abstract OnAdImpressionListener? impressionListener;

  /// Gets or sets whether autoloading of ads is enabled.
  ///
  /// If enabled, the ad will automatically load new content when the current ad is dismissed or completed.
  /// Additionally, it will automatically retry loading the ad if an error occurs during the loading process.
  ///
  /// Disabled by default.
  Future<bool> isAutoloadEnabled();

  /// See [getAutoloadEnabled]
  Future<void> setAutoloadEnabled(bool isEnabled);

  /// Controls whether the ad should be automatically displayed when the user returns to the app.
  ///
  /// Note that the ad must be ready for display at the time of returning to the app.
  ///
  /// Disabled by default.
  Future<bool> isAutoshowEnabled();

  /// See [getAutoshowEnabled]
  Future<void> setAutoshowEnabled(bool isEnabled);

  /// Indicates whether the ad is currently loaded and ready to be shown.
  Future<bool> isLoaded();

  /// Information about the currently loaded ad.
  ///
  /// This property is `null` if the ad has not been loaded yet or has been destroyed.
  Future<AdContentInfo?> getContentInfo();

  /// Loads the interstitial ad content.
  ///
  /// Initiates the process of loading ad content.
  /// This method should be called before attempting to show the ad.
  Future<void> load();

  /// Shows the interstitial ad to the user.
  ///
  /// Displays the ad from the given activity context. This method should be called after the ad has been loaded
  /// and is ready to be shown.
  ///
  /// @param activity The activity context from which the ad is shown.
  Future<void> show();

  /// Disposes the ad content and releases any associated resources.
  ///
  /// Call this method when the ad is no longer needed to clean up resources and prevent memory leaks.
  Future<void> dispose();

  @Deprecated('Use dispose instead')
  Future<void> destroy();

  /// The minimum interval between showing interstitial ads, in seconds.
  ///
  /// Attempting to show a new interstitial ad before the interval has passed after the previous one was closed
  /// will trigger a call to [ScreenAdContentCallback.onAdFailedToShow] with [AdErrorCode.NOT_PASSED_INTERVAL].
  ///
  /// Note that the timer for the minimum interval is shared across all interstitial ad instances, but the minimum
  /// interval value may differ for each ad instance.
  ///
  /// If you need to reset the minimum interval timer after showing a Rewarded Ad or an AppOpen Ad, you can
  /// call the [restartInterval] method in the [ScreenAdContentCallback.onAdDismissed] for these ad formats.
  ///
  /// By default, this interval is set to 0 seconds.
  Future<int> getMinInterval();

  Future<void> setMinInterval(int minInterval);

  /// Restarts the interval countdown until the next interstitial ad display.
  ///
  /// By default, the interval before the first interstitial ad impression is ignored. Use this method to delay
  /// displaying the ad by restarting the interval countdown.
  Future<void> restartInterval();
}
