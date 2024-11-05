import '../ad_callback.dart';
import '../ad_impression.dart';

class AppOpenAdListener extends AdCallback {
  /// Executed when the ad is displayed.
  final void Function() _onShown;

  /// Executed when an ad impression is registered.
  ///
  /// [adImpression] Impression details
  final void Function() _onImpression;

  /// Executed when the ad is failed to display.
  ///
  /// [message] Error message
  final void Function(String? message) _onShowFailed;

  /// Executed when the Ad is closed.
  final void Function() _onClosed;

  AppOpenAdListener({
    required onShown,
    required onImpression,
    required onShowFailed,
    required onClosed,
  })  : _onShown = onShown,
        _onImpression = onImpression,
        _onShowFailed = onShowFailed,
        _onClosed = onClosed;

  @override
  void onShown() => _onShown;

  @override
  void onImpression(AdImpression? adImpression) => _onImpression;

  @override
  void onShowFailed(String? message) => _onShowFailed;

  @override
  void onClosed() => _onClosed;

  @override
  void onClicked() {}

  @override
  void onComplete() {}
}
