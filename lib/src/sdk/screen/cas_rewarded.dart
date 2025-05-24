import '../ad_content_info.dart';
import '../on_ad_impression_listener.dart';
import 'internal/cas_rewarded_impl.dart';
import 'on_reward_earned_listener.dart';
import 'screen_ad_content_callback.dart';

/// Manages a rewarded ad, allowing for loading, showing, and destroying the ad content.
///
/// This class provides functionality to handle rewarded ads, which are ads where
/// users can earn rewards for interacting with them.
///
/// [casId] The unique identifier for the CAS content, typically an application bundle name.
abstract class CASRewarded {
  static CASRewarded create(String casId) {
    return CASRewardedImpl(casId);
  }

  /// Gets or sets the callback for handling ad content events.
  ///
  /// This callback is used to handle various ad content events, such as when the ad is loaded, failed to load,
  /// or shown. Setting this property allows you to respond to these events as needed.
  abstract ScreenAdContentCallback? contentCallback;

  /// Gets or sets the listener for ad impression events.
  ///
  /// This listener is notified when an ad impression is recorded and will be paid.
  /// It allows you to track when the impression has been accounted for.
  /// You can use this to handle actions that should occur upon a successful ad impression,
  /// such as logging or updating analytics.
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

  /// Controls whether interstitial ads are shown as a fallback when a rewarded video ad has no available fill.
  ///
  /// Interstitial ads do not require the user to watch the entire ad to completion. However, the
  /// [OnRewardEarnedListener] will still be triggered as if the user completed the rewarded video.
  ///
  /// This option is enabled by default.
  Future<bool> isExtraFillInterstitialAdEnabled();

  /// See [isExtraFillInterstitialAdEnabled]
  Future<void> setExtraFillInterstitialAdEnabled(bool isEnabled);

  /// Indicates whether the ad is currently loaded and ready to be shown.
  Future<bool> isLoaded();

  /// Information about the currently loaded ad.
  ///
  /// This property is `null` if the ad has not been loaded yet or has been destroyed.
  Future<AdContentInfo?> getContentInfo();

  /// Loads the rewarded ad content.
  ///
  /// Initiates the process of loading ad content. This method should be called before attempting to show the ad.
  Future<void> load();

  /// Shows the rewarded ad to the user.
  ///
  /// Displays the ad from the given activity context. You must provide an [OnRewardEarnedListener] to handle
  /// reward events when the user earns a reward from interacting with the ad.
  ///
  /// [listener] The listener that handles the reward event when the user earns a reward.
  Future<void> show(OnRewardEarnedListener listener);

  /// Disposes the ad content and releases any associated resources.
  ///
  /// Call this method when the ad is no longer needed to clean up resources and prevent memory leaks.
  Future<void> dispose();

  @Deprecated('Use dispose instead')
  Future<void> destroy();
}
