import 'ad_type.dart';

@Deprecated(
    "Please migrate to new CASInterstitial and CASRewarded implementation.")
abstract class AdLoadCallback {
  /// Executed when the ad loaded and ready to present.
  void onAdLoaded(AdType adType);

  /// Executed when the ad failed to load.
  void onAdFailedToLoad(AdType adType, String? error);
}
