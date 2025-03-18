import '../ad_error.dart';

@Deprecated('Use sdk/screen/screen_ad_content_callback.dart instead')
class LoadAdCallback {
  /// Executed when the ad loaded and ready to present.
  final void Function() onAdLoaded;

  /// Executed when the ad failed to load.
  final void Function(AdError) onAdFailedToLoad;

  const LoadAdCallback({
    required this.onAdLoaded,
    required this.onAdFailedToLoad,
  });
}
