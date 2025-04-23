import '../../app_open/cas_app_open.dart' as Old;
import '../ad_content_info.dart';
import '../on_ad_impression_listener.dart';
import 'internal/cas_app_open_impl.dart';
import 'screen_ad_content_callback.dart';

/// Manages an app open ad, allowing for loading, showing, and destroying the ad content.
///
/// This class handles app open ads, which are full-screen ads shown when the user opens the app. These ads are
/// designed to capture the user's attention and are typically displayed when the app is launched or resumed.
///
/// [casId] The unique identifier for the CAS content, typically an application bundle name.
abstract class CASAppOpen extends Old.CASAppOpen {
  static CASAppOpen create(String casId) {
    return CASAppOpenImpl(casId);
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

  /// Loads the app open ad content.
  ///
  /// Initiates the process of loading ad content.
  /// This method should be called before attempting to show the ad.
  Future<void> load();

  /// Shows the app open ad to the user.
  ///
  /// Displays the ad from the given activity context.
  /// This method should be called after the ad has been loaded and is ready to be shown.
  Future<void> show();

  /// Destroys the ad content and releases any associated resources.
  ///
  /// Call this method when the ad is no longer needed to clean up resources and prevent memory leaks.
  Future<void> destroy();
}
