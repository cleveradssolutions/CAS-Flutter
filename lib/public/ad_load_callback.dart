import 'package:clever_ads_solutions/public/ad_type.dart';

abstract class AdLoadCallback {
  void onAdLoaded(AdType adType);

  void onAdFailedToLoad(AdType adType, String? error);
}
