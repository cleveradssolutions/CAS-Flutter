import 'ad_type.dart';

abstract class AdLoadCallback {
  /// Executed when the ad loaded and ready to present.
  void onAdLoaded(AdType adType);

  /// Executed when the ad failed to load.
  void onAdFailedToLoad(AdType adType, String? error);
}
