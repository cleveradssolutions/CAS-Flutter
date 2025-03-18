import '../ad_impression.dart';

@Deprecated('Use sdk/screen/screen_ad_content_callback.dart instead')
class AppOpenAdListener {
  /// Executed when the ad is displayed.
  final void Function(AdImpression? adImpression) onShown;

  /// Executed when the ad is failed to display.
  ///
  /// [message] Error message
  final void Function(String? message) onShowFailed;

  /// Executed when the user clicks on an Ad.
  final void Function() onClicked;

  /// Executed when an ad impression is registered.
  ///
  /// [adImpression] Impression details
  final void Function(AdImpression? adImpression) onImpression;

  /// Executed when the Ad is closed.
  final void Function() onClosed;

  AppOpenAdListener({
    required Function(AdImpression? adImpression) this.onShown,
    required Function(String? message) this.onShowFailed,
    required Function() this.onClicked,
    required Function(AdImpression? adImpression) this.onImpression,
    required Function() this.onClosed,
  });
}
