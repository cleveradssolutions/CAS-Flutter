import 'dart:async';
import 'package:clever_ads_solutions/public/AdCallback.dart';
import 'package:clever_ads_solutions/public/AdLoadCallback.dart';
import 'package:clever_ads_solutions/public/AdSize.dart';
import 'package:clever_ads_solutions/public/CASBannerView.dart';

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
