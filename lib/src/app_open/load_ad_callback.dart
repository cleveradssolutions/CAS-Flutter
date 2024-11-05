import '../ad_error.dart';

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
