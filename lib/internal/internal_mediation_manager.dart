import 'dart:async';

import 'package:clever_ads_solutions/internal/internal_listener_container.dart';
import 'package:clever_ads_solutions/public/ad_callback.dart';
import 'package:clever_ads_solutions/public/ad_load_callback.dart';
import 'package:clever_ads_solutions/public/ad_size.dart';
import 'package:clever_ads_solutions/public/cas_banner_view.dart';
import 'package:clever_ads_solutions/public/mediation_manager.dart';
import 'package:flutter/services.dart';

import 'internal_cas_banner_view.dart';

class InternalMediationManager extends MediationManager {
  final MethodChannel _channel;
  final InternalListenerContainer _listenerContainer;

  InternalMediationManager(this._channel, this._listenerContainer);

  @override
  Future<void> enableAppReturn(AdCallback? callback) async {
    _listenerContainer.appReturnListener = callback;
    return _channel.invokeMethod('enableAppReturn', {'enable': true});
  }

  @override
  Future<void> disableAppReturn() async {
    return _channel.invokeMethod('enableAppReturn', {'enable': false});
  }

  @override
  Future<int> getBannerRefreshDelay() async {
    final delay = await _channel.invokeMethod<int>('getBannerRefreshDelay');
    return delay ?? 0;
  }

  @override
  Future<bool> isEnabled(int adType) async {
    bool? isEnabled =
        await _channel.invokeMethod<bool>('isEnabled', {"adType": adType});
    return isEnabled ?? false;
  }

  @override
  Future<void> loadInterstitial() async {
    return _channel.invokeMethod('loadAd', {'adType': 1});
  }

  @override
  Future<void> loadRewarded() async {
    return _channel.invokeMethod('loadAd', {'adType': 2});
  }

  @override
  Future<void> setBannerRefreshDelay(int delay) async {
    return _channel.invokeMethod("setBannerRefreshDelay", {"delay": delay});
  }

  @override
  Future<void> setEnabled(int adType, bool isEnable) async {
    return _channel
        .invokeMethod("setEnabled", {"adType": adType, "enable": isEnable});
  }

  @override
  Future<void> showInterstitial(AdCallback? callback) async {
    _listenerContainer.interstitialListener = callback;
    return _channel.invokeMethod("showAd", {"adType": 1});
  }

  @override
  Future<void> showRewarded(AdCallback? callback) async {
    _listenerContainer.rewardedListener = callback;
    return _channel.invokeMethod("showAd", {"adType": 2});
  }

  @override
  Future<void> skipNextAppReturnAds() async {
    return _channel.invokeMethod("skipNextAppReturnAds");
  }

  @override
  CASBannerView getAdView(AdSize size) {
    int sizeId = size.index + 1;
    createAdView(sizeId);
    return InternalCASBannerView(_channel, _listenerContainer, size.index + 1);
  }

  Future<void> createAdView(int sizeId) async {
    _channel.invokeMethod("createBannerView", {"sizeId": sizeId});
  }

  @override
  void setAdLoadCallback(AdLoadCallback callback) {
    _listenerContainer.adLoadCallback = callback;
  }

  @override
  Future<bool> isInterstitialReady() async {
    bool? isReady =
        await _channel.invokeMethod<bool>('isReadyAd', {"adType": 1});
    return isReady ?? false;
  }

  @override
  Future<bool> isRewardedAdReady() async {
    bool? isReady =
        await _channel.invokeMethod<bool>('isReadyAd', {"adType": 2});
    return isReady ?? false;
  }
}
