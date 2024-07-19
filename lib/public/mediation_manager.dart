import 'dart:async';

import 'package:clever_ads_solutions/public/ad_callback.dart';
import 'package:clever_ads_solutions/public/ad_load_callback.dart';
import 'package:clever_ads_solutions/public/ad_size.dart';
import 'package:clever_ads_solutions/public/cas_banner_view.dart';

abstract class MediationManager {
  Future<void> loadInterstitial();

  Future<void> loadRewarded();

  Future<bool> isInterstitialReady();

  Future<bool> isRewardedAdReady();

  Future<void> showInterstitial(AdCallback? callback);

  Future<void> showRewarded(AdCallback? callback);

  Future<void> setBannerRefreshDelay(int delay);

  Future<int> getBannerRefreshDelay();

  Future<void> enableAppReturn(AdCallback? callback);

  Future<void> disableAppReturn();

  Future<void> skipNextAppReturnAds();

  Future<void> setEnabled(int adType, bool isEnable);

  Future<bool> isEnabled(int adType);

  CASBannerView getAdView(AdSize size);

  void setAdLoadCallback(AdLoadCallback callback);
}
