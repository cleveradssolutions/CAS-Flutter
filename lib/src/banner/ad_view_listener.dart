import 'package:clever_ads_solutions/clever_ads_solutions.dart';

class AdViewListener {
  /// Invokes this callback when ad loaded and ready to present.
  final void Function()? onAdViewLoaded;

  /// Invokes this callback when an error occurred with the ad.
  /// - To see the error code, see [AdError.code].
  /// - To see a description of the error, see [AdError.message].
  final void Function(String? message)? onAdViewFailed;

  /// Invokes this callback when the ad did present for a user with info about the impression.
  /// Deprecated note: Use [BannerWidget.onImpressionListener] and [OnAdImpressionListener] to get impression info.
  final void Function()? _onAdViewPresented;

  /// Invokes this callback when a user clicks the ad.
  final void Function()? onAdViewClicked;

  const AdViewListener({
    Function()? this.onAdViewLoaded,
    Function(String? message)? this.onAdViewFailed,
    Function()? onAdViewPresented,
    Function()? this.onAdViewClicked,
  }) : _onAdViewPresented = onAdViewPresented;

  @Deprecated('Use constructor parameter')
  void onLoaded() {
    onAdViewLoaded?.call();
  }

  @Deprecated('Use constructor parameter')
  void onFailed(String? message) {
    onAdViewFailed?.call(message);
  }

  @Deprecated('Use constructor parameter')
  void onAdViewPresented() {
    _onAdViewPresented?.call();
  }

  @Deprecated(
      'Use [BannerWidget.onImpressionListener] and [OnAdImpressionListener] to get impression info')
  void onImpression(AdImpression? adImpression) {}

  @Deprecated('Use constructor parameter')
  void onClicked() {
    onAdViewClicked?.call();
  }
}
