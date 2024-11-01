import 'ad_impression.dart';

abstract class AdCallback {
  /// Executed when the ad is displayed.
  void onShown();

  void onImpression(AdImpression? adImpression);

  /// Executed when the ad is failed to display.
  ///
  /// @param message Error message
  void onShowFailed(String? message);

  /// Executed when the user clicks on an Ad.
  void onClicked();

  /// Executed when the Ad is completed.
  void onComplete();

  /// Executed when the Ad is closed.
  void onClosed();
}
