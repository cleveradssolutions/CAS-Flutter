import 'ad_impression.dart';

/// A callback interface for handling advertisement events.
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
