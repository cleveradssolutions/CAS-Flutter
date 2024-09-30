import 'dart:async';

import 'package:flutter/services.dart';

import '../ad_callback.dart';
import '../ad_load_callback.dart';
import '../ad_size.dart';
import '../ad_type.dart';
import '../banner_widget.dart';
import '../cas_banner_view.dart';
import '../mediation_manager.dart';
import 'ad_listener.dart';
import 'internal_listener_container.dart';

class InternalMediationManager extends AdListener implements MediationManager {
  static const MethodChannel _channel =
      MethodChannel("com.cleveradssolutions.plugin.flutter/mediation_manager");

  AdCallback? interstitialListener;
  AdCallback? rewardedListener;
  AdCallback? appReturnListener;
  AdLoadCallback? adLoadCallback;

  static final InternalListenerContainer _listenerContainer =
      InternalListenerContainer(_channel);

  InternalMediationManager() {
    _channel.setMethodCallHandler(handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      //Interstitial

      case 'OnInterstitialAdLoaded':
        adLoadCallback?.onAdLoaded(AdType.Interstitial);
        break;

      case 'OnInterstitialAdFailedToLoad':
        if ((call.arguments as Object?) != null) {
          adLoadCallback?.onAdFailedToLoad(
              AdType.Interstitial, call.arguments["message"]);
        } else {
          adLoadCallback?.onAdFailedToLoad(AdType.Interstitial, null);
        }
        break;

      case 'OnInterstitialAdShown':
        interstitialListener?.onShown();
        break;

      case 'OnInterstitialAdImpression':
        interstitialListener?.onImpression(tryGetAdImpression(call));
        break;

      case 'OnInterstitialAdFailedToShow':
        if ((call.arguments as Object?) != null) {
          interstitialListener?.onShowFailed(call.arguments["message"]);
        }
        break;

      case 'OnInterstitialAdClicked':
        interstitialListener?.onClicked();
        break;

      case 'OnInterstitialAdComplete':
        interstitialListener?.onComplete();
        break;

      case 'OnInterstitialAdClosed':
        interstitialListener?.onClosed();
        break;

      //Rewarded

      case 'OnRewardedAdLoaded':
        adLoadCallback?.onAdLoaded(AdType.Rewarded);
        break;

      case 'OnRewardedAdFailedToLoad':
        if ((call.arguments as Object?) != null) {
          adLoadCallback?.onAdFailedToLoad(
              AdType.Rewarded, call.arguments["message"]);
        } else {
          adLoadCallback?.onAdFailedToLoad(AdType.Rewarded, null);
        }
        break;

      case 'OnRewardedAdShown':
        rewardedListener?.onShown();
        break;

      case 'OnRewardedAdImpression':
        rewardedListener?.onImpression(tryGetAdImpression(call));
        break;

      case 'OnRewardedAdFailedToShow':
        if ((call.arguments as Object?) != null) {
          rewardedListener?.onShowFailed(call.arguments["message"]);
        }
        break;

      case 'OnRewardedAdClicked':
        rewardedListener?.onClicked();
        break;

      case 'OnRewardedAdCompleted':
        rewardedListener?.onComplete();
        break;

      case 'OnRewardedAdClosed':
        rewardedListener?.onClosed();
        break;

      //AppReturn

      case 'OnAppReturnAdShown':
        rewardedListener?.onShown();
        break;

      case 'OnAppReturnAdImpression':
        appReturnListener?.onImpression(tryGetAdImpression(call));
        break;

      case 'OnAppReturnAdFailedToShow':
        if ((call.arguments as Object?) != null) {
          rewardedListener?.onShowFailed(call.arguments["message"]);
        }
        break;

      case 'OnAppReturnAdClicked':
        rewardedListener?.onClicked();
        break;

      case 'OnAppReturnAdClosed':
        rewardedListener?.onComplete();
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
  Future<void> loadInterstitial() {
    return _channel.invokeMethod('loadAd', {'adType': 1});
  }

  @override
  Future<void> loadRewarded() {
    return _channel.invokeMethod('loadAd', {'adType': 2});
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
  Future<void> showInterstitial(AdCallback? callback) {
    interstitialListener = callback;
    return _channel.invokeMethod("showAd", {"adType": 1});
  }

  @override
  Future<void> showRewarded(AdCallback? callback) {
    rewardedListener = callback;
    return _channel.invokeMethod("showAd", {"adType": 2});
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
    appReturnListener = callback;
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
        sizeId = 0;
        break;
    }

    _channel.invokeMethod("createBannerView", {"sizeId": sizeId});
    return BannerWidget(size: size, _listenerContainer);
  }

  @override
  void setAdLoadCallback(AdLoadCallback callback) {
    adLoadCallback = callback;
  }
}
