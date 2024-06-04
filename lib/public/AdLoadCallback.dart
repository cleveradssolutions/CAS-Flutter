import 'package:clever_ads_solutions/public/AdType.dart';

abstract class AdLoadCallback {
  void onAdLoaded(AdType adType);
  void onAdFailedToLoad(AdType adType, String? error);
}
