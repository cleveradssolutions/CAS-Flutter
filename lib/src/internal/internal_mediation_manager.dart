import 'dart:async';

import 'package:flutter/services.dart';

import '../ad_callback.dart';
import '../ad_impression.dart';
import '../ad_load_callback.dart';
import '../ad_size.dart';
import '../ad_type.dart';
import '../banner/cas_banner_view.dart';
import '../banner/internal/internal_cas_banner_view.dart';
import '../banner/internal/internal_listener_container.dart';
import '../mediation_manager.dart';

class InternalMediationManager implements MediationManager {
  static const MethodChannel _channel =
      MethodChannel("cleveradssolutions/mediation_manager");

  AdCallback? _interstitialListener;
  AdCallback? _rewardedListener;
  AdCallback? _appReturnListener;
  AdLoadCallback? _adLoadCallback;

  static final InternalListenerContainer _listenerContainer =
      InternalListenerContainer(_channel);

  InternalMediationManager() {
    _channel.setMethodCallHandler(handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      //Interstitial

      case 'OnInterstitialAdLoaded':
        _adLoadCallback?.onAdLoaded(AdType.Interstitial);
        break;

      case 'OnInterstitialAdFailedToLoad':
        _adLoadCallback?.onAdFailedToLoad(AdType.Interstitial, call.arguments);
        break;

      case 'OnInterstitialAdShown':
        _interstitialListener?.onShown();
        break;

      case 'OnInterstitialAdImpression':
        _interstitialListener?.onImpression(AdImpression.tryParse(call));
        break;

      case 'OnInterstitialAdFailedToShow':
        _interstitialListener?.onShowFailed(call.arguments);
        break;

      case 'OnInterstitialAdClicked':
        _interstitialListener?.onClicked();
        break;

      case 'OnInterstitialAdClosed':
        _interstitialListener?.onClosed();
        break;

      //Rewarded

      case 'OnRewardedAdLoaded':
        _adLoadCallback?.onAdLoaded(AdType.Rewarded);
        break;

      case 'OnRewardedAdFailedToLoad':
        _adLoadCallback?.onAdFailedToLoad(AdType.Rewarded, call.arguments);
        break;

      case 'OnRewardedAdShown':
        _rewardedListener?.onShown();
        break;

      case 'OnRewardedAdImpression':
        _rewardedListener?.onImpression(AdImpression.tryParse(call));
        break;

      case 'OnRewardedAdFailedToShow':
        _rewardedListener?.onShowFailed(call.arguments);
        break;

      case 'OnRewardedAdClicked':
        _rewardedListener?.onClicked();
        break;

      case 'OnRewardedAdCompleted':
        _rewardedListener?.onComplete();
        break;

      case 'OnRewardedAdClosed':
        _rewardedListener?.onClosed();
        break;

      //AppReturn

      case 'OnAppReturnAdShown':
        _appReturnListener?.onShown();
        break;

      case 'OnAppReturnAdImpression':
        _appReturnListener?.onImpression(AdImpression.tryParse(call));
        break;

      case 'OnAppReturnAdFailedToShow':
        if ((call.arguments as Object?) != null) {
          _appReturnListener?.onShowFailed(call.arguments);
        }
        break;

      case 'OnAppReturnAdClicked':
        _appReturnListener?.onClicked();
        break;

      case 'OnAppReturnAdClosed':
        _appReturnListener?.onComplete();
        break;
    }
  }

  @override
  Future<String> getManagerID() async {
    String? id = await _channel.invokeMethod<String>("getManagerID");
    return id ?? "demo";
  }

  @override
  Future<bool> isDemoAdMode() async {
    bool? isDemoAdMode = await _channel.invokeMethod<bool>('isDemoAdMode');
    return isDemoAdMode ?? false;
  }

  @override
  Future<bool> isFullscreenAdVisible() async {
    bool? isFullscreenAdVisible =
        await _channel.invokeMethod<bool>('isFullscreenAdVisible');
    return isFullscreenAdVisible ?? false;
  }

  @override
  Future<void> loadInterstitial() async {
    final result = await _channel.invokeMethod('loadAd', {'adType': 1});
    if (result is PlatformException) {
      _adLoadCallback?.onAdFailedToLoad(AdType.Interstitial, result.message);
    }
    return result;
  }

  @override
  Future<void> loadRewarded() async {
    final result = await _channel.invokeMethod('loadAd', {'adType': 2});
    if (result is PlatformException) {
      _adLoadCallback?.onAdFailedToLoad(AdType.Rewarded, result.message);
    }
    return result;
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

  @override
  Future<void> showInterstitial(AdCallback? callback) async {
    _interstitialListener = callback;
    final result = await _channel.invokeMethod("showAd", {"adType": 1});
    if (result is PlatformException) {
      _interstitialListener?.onShowFailed(result.message);
    }
    return result;
  }

  @override
  Future<void> showRewarded(AdCallback? callback) async {
    _rewardedListener = callback;
    final result = await _channel.invokeMethod("showAd", {"adType": 2});
    if (result is PlatformException) {
      _rewardedListener?.onShowFailed(result.message);
    }
    return result;
  }

  @override
  Future<void> setEnabled(int adType, bool isEnable) {
    return _channel
        .invokeMethod("setEnabled", {"adType": adType, "enable": isEnable});
  }

  @override
  Future<bool> isEnabled(int adType) async {
    bool? isEnabled =
        await _channel.invokeMethod<bool>('isEnabled', {"adType": adType});
    return isEnabled ?? false;
  }

  @override
  Future<void> enableAppReturn(AdCallback? callback) {
    _appReturnListener = callback;
    return _channel.invokeMethod('enableAppReturn', {'enable': true});
  }

  @override
  Future<void> disableAppReturn() {
    return _channel.invokeMethod('enableAppReturn', {'enable': false});
  }

  @override
  Future<void> skipNextAppReturnAds() {
    return _channel.invokeMethod("skipNextAppReturnAds");
  }

  @override
  Future<void> setBannerRefreshDelay(int delay) {
    return _channel.invokeMethod("setBannerRefreshDelay", {"delay": delay});
  }

  @override
  Future<int> getBannerRefreshDelay() async {
    final delay = await _channel.invokeMethod<int>('getBannerRefreshDelay');
    return delay ?? 0;
  }

  @override
  CASBannerView getAdView(AdSize size) {
    int sizeId;
    switch (size) {
      case AdSize.banner:
      case AdSize.Banner:
        sizeId = 1;
        break;
      case AdSize.Adaptive:
        sizeId = 2;
        break;
      case AdSize.Smart:
        sizeId = 3;
        break;
      case AdSize.leaderboard:
      case AdSize.Leaderboard:
        sizeId = 4;
        break;
      case AdSize.mediumRectangle:
      case AdSize.MediumRectangle:
        sizeId = 5;
        break;
      default:
        sizeId = 1;
        break;
    }

    _channel.invokeMethod("showBanner", {"sizeId": sizeId});
    return InternalCASBannerView(_channel, _listenerContainer, sizeId);
  }

  @override
  void setAdLoadCallback(AdLoadCallback? callback) {
    _adLoadCallback = callback;
  }
}
