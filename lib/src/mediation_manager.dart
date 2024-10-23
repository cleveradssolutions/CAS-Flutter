import 'dart:async';

import 'ad_callback.dart';
import 'ad_load_callback.dart';
import 'ad_size.dart';
import 'ad_type.dart';
import 'cas_banner_view.dart';

abstract class MediationManager {
  /// CAS manager (Placement) identifier
  Future<String> getManagerID();

  /// Check is visible [AdType.Interstitial] or [AdType.Rewarded] right now.
  Future<bool> isFullscreenAdVisible();

  Future<bool> isDemoAdMode();

  /// Manual load Interstitial Ad.
  /// You should only use this method if [AdsSettings.loadingMode] == [LoadingManagerMode.Manual] is active.
  /// Please call load before each show ad.
  /// You can get a callback for the successful loading of an ad subscribe [onAdLoadEvent].
  Future<void> loadInterstitial();

  /// Manual load Rewarded Video Ad.
  /// You should only use this method if [AdsSettings.loadingMode] == [LoadingManagerMode.Manual] is active.
  /// Please call load before each show ad.
  /// You can get a callback for the successful loading of an ad by subscribe [onAdLoadEvent].
  Future<void> loadRewarded();

  /// Check if Interstitial ad is ready to be shown.
  Future<bool> isInterstitialReady();

  /// Check if Rewarded ad is ready to be shown.
  Future<bool> isRewardedAdReady();

  /// Shows the Interstitial ad if available.
  /// @param activity The activity from which the Interstitial ad should be shown.
  /// @param callback The callback for Interstitial ad events.
  Future<void> showInterstitial(AdCallback? callback);

  /// Shows the Rewarded ad if available.
  /// @param activity The activity from which the Rewarded ad should be shown.
  /// @param callback The callback for Rewarded ad events.
  Future<void> showRewarded(AdCallback? callback);

  /// Set [enabled] ad [type] to processing.
  /// The state will not be saved between sessions.
  Future<void> setEnabled(int adType, bool isEnable);

  /// Ad [type] is processing.
  Future<bool> isEnabled(int adType);

  /// The Return Ad which is displayed once the user returns to your application after a certain period of time.
  /// To minimize the intrusiveness, short time periods are ignored.
  ///
  /// Return ads are disabled by default.
  /// If you want to enable this feature, simply pass AdCallback as the parameter of the method.
  Future<void> enableAppReturn(AdCallback? callback);

  /// Disable the Return Ad which is displayed once the user returns to your application after a certain period of time.
  Future<void> disableAppReturn();

  /// Calling this method will indicate to skip one next ad impression when returning to the app.
  ///
  /// You can call this method when you intentionally redirect the user to another application (for example Google Play)
  /// and do not want them to see ads when they return to your application.
  Future<void> skipNextAppReturnAds();

  Future<void> setBannerRefreshDelay(int delay);

  Future<int> getBannerRefreshDelay();

  @Deprecated("This method is no longer maintained and should not be used")
  CASBannerView getAdView(AdSize size);

  void setAdLoadCallback(AdLoadCallback? callback);
}
