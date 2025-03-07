import '../../ad_error.dart';
import '../ad_content_info.dart';
import '../ad_format.dart';

/// A callback class for handling events related to ad content.
///
/// Implement this class to respond to various states and actions associated with ad content,
/// such as loading success, showing success, and user interactions.
///
/// Methods in this class are called on the main thread.
class ScreenAdContentCallback {
  /// Called when the ad content has been successfully loaded.
  ///
  /// This method provides an opportunity to handle successful ad loading,
  /// such as preparing the ad for display.
  ///
  /// @param ad The ad content that has been successfully loaded.
  final void Function(AdContentInfo ad) onAdLoaded;

  /// Called when the ad content fails to load.
  ///
  /// This method provides an opportunity to handle loading failures,
  /// such as displaying an error message to the user or attempting to load a different ad.
  ///
  /// @param format The format of ad content.
  /// @param error The error that occurred while attempting to load the ad content.
  final void Function(AdFormat format, AdError error) onAdFailedToLoad;

  /// Called when the ad content is successfully shown.
  ///
  /// This method is triggered when the ad content has been successfully displayed.
  /// Use this method to perform any actions required after the ad is shown,
  /// such as logging or UI updates.
  ///
  /// @param ad The ad content that has been successfully shown.
  final void Function(AdContentInfo ad) onAdShowed;

  /// Called when the ad content fails to show.
  ///
  /// This method is triggered if there is an issue displaying the ad content. Implement this method to handle
  /// errors related to ad presentation, such as retrying the display or notifying the user.
  ///
  /// @param format The format of ad content.
  /// @param error The error that occurred while attempting to show the ad content.
  final void Function(AdFormat format, AdError error) onAdFailedToShow;

  /// Called when the ad content is clicked by the user.
  ///
  /// This method provides an opportunity to handle user clicks on the ad,
  /// such as tracking click events or updating the UI.
  ///
  /// @param ad The ad content that was clicked by the user.
  final void Function(AdContentInfo ad) onAdClicked;

  /// Called when the ad content is dismissed.
  ///
  /// This method is triggered when the ad content is closed or dismissed by the user. Use this method to perform
  /// any necessary actions after the ad has been dismissed, such as cleaning up resources or updating the UI.
  ///
  /// @param ad The ad content that was dismissed.
  final void Function(AdContentInfo ad) onAdDismissed;

  ScreenAdContentCallback(
      {required Function(AdContentInfo ad) this.onAdLoaded,
      required Function(AdFormat format, AdError error) this.onAdFailedToLoad,
      required Function(AdContentInfo ad) this.onAdShowed,
      required Function(AdFormat format, AdError error) this.onAdFailedToShow,
      required Function(AdContentInfo ad) this.onAdClicked,
      required Function(AdContentInfo ad) this.onAdDismissed});
}
