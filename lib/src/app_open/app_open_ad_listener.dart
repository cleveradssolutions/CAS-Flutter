import '../ad_callback.dart';
import '../ad_impression.dart';

class AppOpenAdListener extends AdCallback {
  /// Executed when the ad is displayed.
  final void Function() _onShown;

  /// Executed when an ad impression is registered.
  ///
  /// [adImpression] Impression details
  final void Function(AdImpression? adImpression) _onImpression;

  /// Executed when the ad is failed to display.
  ///
  /// [message] Error message
  final void Function(String? message) _onShowFailed;

  /// Executed when the Ad is closed.
  final void Function() _onClosed;

  AppOpenAdListener({
    required Function() onShown,
    required Function(AdImpression? adImpression) onImpression,
    required Function(String? message) onShowFailed,
    required Function() onClosed,
  })  : _onShown = onShown,
        _onImpression = onImpression,
        _onShowFailed = onShowFailed,
        _onClosed = onClosed;

  @override
  void onShown() => _onShown();

  @override
  void onImpression(AdImpression? adImpression) => _onImpression(adImpression);

  @override
  void onShowFailed(String? message) => _onShowFailed(message);

  @override
  void onClosed() => _onClosed();

  @override
  void onClicked() {}

  @override
  void onComplete() {}
}
