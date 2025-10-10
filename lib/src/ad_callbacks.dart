// ignore_for_file: public_member_api_docs

part of 'ad_instances.dart';

/// The callback type to handle an event occurring for an [AdInstance].
typedef OnAdCallback = void Function(AdInstance ad);

/// The callback type to handle an error loading/showing an [AdInstance].
typedef OnAdFailedCallback = void Function(AdInstance ad, AdError error);

/// The callback type for when an ad impression.
typedef OnAdContentCallback = void Function(
    AdInstance ad, AdContentInfo contentInfo);

/// The callback type to handle an event occurring for an [AdScreenInstance].
typedef OnScreenAdCallback = void Function(AdScreenInstance screenAd);

/// The callback type to handle an event occurring for an [AdViewInstance].
typedef OnAdViewCallback = void Function(AdViewInstance adView);

/// A functional interface for listening to ad impression events.
/// Implement this interface to handle actions when an ad impression is recorded.
@Deprecated("Replaced with onAdImpression callback.")
class OnAdImpressionListener {
  /// Called when an ad impression occurs.
  ///
  /// [ad] The ad content associated with the impression. This object contains details
  ///           about the ad, including format, source, and revenue information.
  ///
  /// This method is guaranteed to be called on the main thread.
  final void Function(AdContentInfo ad) onAdImpression;

  OnAdImpressionListener(Function(AdContentInfo ad) this.onAdImpression);
}

/// A callback class for handling events related to ad content.
///
/// Implement this class to respond to various states and actions associated with ad content,
/// such as loading success, showing success, and user interactions.
///
/// Functions in this class are called on the main thread.
@Deprecated(
    "Replaced with separate callbacks: onAdLoaded, onAdFailedToLoad, and others.")
class ScreenAdContentCallback {
  /// Construct a new [ScreenAdContentCallback].
  const ScreenAdContentCallback(
      {this.onAdLoaded,
      this.onAdFailedToLoad,
      this.onAdShowed,
      this.onAdFailedToShow,
      this.onAdClicked,
      this.onAdDismissed});

  /// Called when the ad content has been successfully loaded.
  ///
  /// This function provides an opportunity to handle successful ad loading,
  /// such as preparing the ad for display.
  ///
  /// [ad] The ad content that has been successfully loaded.
  final void Function(AdContentInfo ad)? onAdLoaded;

  /// Called when the ad content fails to load.
  ///
  /// This function provides an opportunity to handle loading failures,
  /// such as displaying an error message to the user or attempting to load a different ad.
  ///
  /// [format] The format of ad content.
  /// [error] The error that occurred while attempting to load the ad content.
  final void Function(AdFormat format, AdError error)? onAdFailedToLoad;

  /// Called when the ad content is successfully shown.
  ///
  /// This function is triggered when the ad content has been successfully displayed.
  /// Use this function to perform any actions required after the ad is shown,
  /// such as logging or UI updates.
  ///
  /// [ad] The ad content that has been successfully shown.
  final void Function(AdContentInfo ad)? onAdShowed;

  /// Called when the ad content fails to show.
  ///
  /// This function is triggered if there is an issue displaying the ad content. Implement this method to handle
  /// errors related to ad presentation, such as retrying the display or notifying the user.
  ///
  /// [format] The format of ad content.
  /// [error] The error that occurred while attempting to show the ad content.
  final void Function(AdFormat format, AdError error)? onAdFailedToShow;

  /// Called when the ad content is clicked by the user.
  ///
  /// This function provides an opportunity to handle user clicks on the ad,
  /// such as tracking click events or updating the UI.
  ///
  /// [ad] The ad content that was clicked by the user.
  final void Function(AdContentInfo ad)? onAdClicked;

  /// Called when the ad content is dismissed.
  ///
  /// This function is triggered when the ad content is closed or dismissed by the user. Use this method to perform
  /// any necessary actions after the ad has been dismissed, such as cleaning up resources or updating the UI.
  ///
  /// [ad] The ad content that was dismissed.
  final void Function(AdContentInfo ad)? onAdDismissed;
}

/// A functional interface for listening to reward events.
///
/// Implement this interface to handle events where a user earns a reward from interacting with an ad.
@Deprecated(
    "Please call the show() function without parameters and set new CASRewarded.onUserEarnedReward callback.")
class OnRewardEarnedListener {
  /// Called when a user earns a reward from the ad.
  ///
  /// This method provides an opportunity to handle the reward event, such as updating the user's rewards balance,
  /// or displaying a confirmation message to the user.
  ///
  /// [ad] The ad content associated with the reward.
  final void Function(AdContentInfo ad) onUserEarnedReward;

  OnRewardEarnedListener(Function(AdContentInfo ad) this.onUserEarnedReward);
}

/// A callback interface for handling advertisement events.
@Deprecated("Please use the new features of CAS with AdContentInfo.")
abstract class AdCallback {
  /// Executed when the ad is displayed.
  void onShown();

  /// Executed when an ad impression is registered.
  ///
  /// [adImpression] Impression details
  void onImpression(AdImpression? adImpression);

  /// Executed when the ad is failed to display.
  ///
  /// [message] Error message
  void onShowFailed(String? message);

  /// Executed when the user clicks on an Ad.
  void onClicked();

  /// Executed when the Ad is completed.
  void onComplete();

  /// Executed when the Ad is closed.
  void onClosed();
}

@Deprecated(
    "Please migrate to new CASInterstitial and CASRewarded implementation.")
abstract class AdLoadCallback {
  /// Executed when the ad loaded and ready to present.
  void onAdLoaded(AdType adType);

  /// Executed when the ad failed to load.
  void onAdFailedToLoad(AdType adType, String? error);
}
