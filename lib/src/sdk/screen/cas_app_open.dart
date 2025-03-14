import '../on_ad_impression_listener.dart';
import 'internal/cas_app_open_impl.dart';
import 'screen_ad_content_callback.dart';

/// Manages an app open ad, allowing for loading, showing, and destroying the ad content.
///
/// This class handles app open ads, which are full-screen ads shown when the user opens the app. These ads are
/// designed to capture the user's attention and are typically displayed when the app is launched or resumed.
///
/// @param context The context in which the ad operates, typically an application or activity context.
/// @param casId The unique identifier for the CAS content, typically an application bundle name.
abstract class CASAppOpen {
  static CASAppOpen create(String managerId) {
    return CASAppOpenImpl(managerId);
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

  /// Loads an AppOpenAd.
  ///
  /// Note: You must keep a strong link throughout the ad's lifecycle.
  ///
  /// @param context The context.
  /// @param callback An object that handles events for loading an app open ad.
  Future<void> load();

  /// Shows the AppOpenAd.
  ///
  /// @param activity The activity from which the AppOpenAd is shown from.
  Future<void> show();

  /// Destroys the ad content and releases any associated resources.
  ///
  /// Call this method when the ad is no longer needed to clean up resources and prevent memory leaks.
  Future<void> destroy();
}
