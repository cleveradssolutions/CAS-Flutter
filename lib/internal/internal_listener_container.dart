import 'dart:async';

import 'package:clever_ads_solutions/public/ad_callback.dart';
import 'package:clever_ads_solutions/public/ad_impression.dart';
import 'package:clever_ads_solutions/public/ad_load_callback.dart';
import 'package:clever_ads_solutions/public/ad_type.dart';
import 'package:clever_ads_solutions/public/ad_view_listener.dart';
import 'package:clever_ads_solutions/public/init_config.dart';
import 'package:clever_ads_solutions/public/initialization_listener.dart';
import 'package:clever_ads_solutions/public/on_dismiss_listener.dart';
import 'package:flutter/services.dart';

class InternalListenerContainer {
  InitializationListener? initializationListener;
  AdCallback? interstitialListener;
  AdCallback? rewardedListener;
  AdCallback? appReturnListener;

  AdViewListener? standartBannerListener;
  AdViewListener? adaptiveBannerListener;
  AdViewListener? smartBannerListener;
  AdViewListener? leaderBannerListener;
  AdViewListener? mrecBannerListener;

  AdLoadCallback? adLoadCallback;

  OnDismissListener? onDismissListener;

  InternalListenerContainer(MethodChannel channel) {
    channel.setMethodCallHandler(handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      // Inititalization

      case 'onCASInitialized':
        {
          String? error = call.arguments["error"];
          String? countryCode = call.arguments["countryCode"];
          bool? isConsentRequired = call.arguments["isConsentRequired"];
          bool? isTestMode = call.arguments["testMode"];

          String finalError = "";
          if (error != null) {
            finalError = error;
          }

          String finalCountryCode = "";
          if (countryCode != null) {
            finalCountryCode = countryCode;
          }

          bool finalIsConsentRequired = false;
          if (isConsentRequired != null) {
            finalIsConsentRequired = isConsentRequired;
          }

          bool finalIsTestMode = false;
          if (isTestMode != null) {
            finalIsTestMode = isTestMode;
          }

          initializationListener?.onCASInitialized(InitConfig(finalError,
              finalCountryCode, finalIsConsentRequired, finalIsTestMode));
        }
        break;

      //Consent Flow

      case "OnDismissListener":
        {
          int status = call.arguments["status"];
          onDismissListener?.onConsentFlowDismissed(status);
          break;
        }

      //Interstitial

      case 'OnInterstitialAdLoaded':
        {
          adLoadCallback?.onAdLoaded(AdType.Interstitial);
        }
        break;

      case 'OnInterstitialAdFailedToLoad':
        {
          if ((call.arguments as Object?) != null) {
            adLoadCallback?.onAdFailedToLoad(
                AdType.Interstitial, call.arguments["message"]);
          } else {
            adLoadCallback?.onAdFailedToLoad(AdType.Interstitial, null);
          }
        }
        break;

      case 'OnInterstitialAdShown':
        {
          interstitialListener?.onShown();
        }
        break;

      case 'OnInterstitialAdImpression':
        {
          interstitialListener?.onImpression(_tryGetAdStatusHandler(call));
        }
        break;

      case 'OnInterstitialAdFailedToShow':
        {
          if ((call.arguments as Object?) != null) {
            interstitialListener?.onShowFailed(call.arguments["message"]);
          }
        }
        break;

      case 'OnInterstitialAdClicked':
        {
          interstitialListener?.onClicked();
        }
        break;

      case 'OnInterstitialAdComplete':
        {
          interstitialListener?.onComplete();
        }
        break;

      case 'OnInterstitialAdClosed':
        {
          interstitialListener?.onClosed();
        }
        break;

      //Rewarded

      case 'OnRewardedAdLoaded':
        {
          adLoadCallback?.onAdLoaded(AdType.Rewarded);
        }
        break;

      case 'OnRewardedAdFailedToLoad':
        {
          if ((call.arguments as Object?) != null) {
            adLoadCallback?.onAdFailedToLoad(
                AdType.Rewarded, call.arguments["message"]);
          } else {
            adLoadCallback?.onAdFailedToLoad(AdType.Rewarded, null);
          }
        }
        break;

      case 'OnRewardedAdShown':
        {
          rewardedListener?.onShown();
        }
        break;

      case 'OnRewardedAdImpression':
        {
          rewardedListener?.onImpression(_tryGetAdStatusHandler(call));
        }
        break;

      case 'OnRewardedAdFailedToShow':
        {
          if ((call.arguments as Object?) != null) {
            rewardedListener?.onShowFailed(call.arguments["message"]);
          }
        }
        break;

      case 'OnRewardedAdClicked':
        {
          rewardedListener?.onClicked();
        }
        break;

      case 'OnRewardedAdCompleted':
        {
          rewardedListener?.onComplete();
        }
        break;

      case 'OnRewardedAdClosed':
        {
          rewardedListener?.onClosed();
        }
        break;

      //AppReturn

      case 'OnAppReturnAdShown':
        {
          rewardedListener?.onShown();
        }
        break;

      case 'OnAppReturnAdImpression':
        {
          appReturnListener?.onImpression(_tryGetAdStatusHandler(call));
        }
        break;

      case 'OnAppReturnAdFailedToShow':
        {
          if ((call.arguments as Object?) != null) {
            rewardedListener?.onShowFailed(call.arguments["message"]);
          }
        }
        break;

      case 'OnAppReturnAdClicked':
        {
          rewardedListener?.onClicked();
        }
        break;

      case 'OnAppReturnAdClosed':
        {
          rewardedListener?.onComplete();
        }
        break;

      // banner standart

      case '1OnBannerAdLoaded':
        {
          standartBannerListener?.onLoaded();
        }
        break;

      case '1OnBannerAdShown':
        {
          standartBannerListener?.onAdViewPresented();
        }
        break;

      case '1OnBannerAdImpression':
        {
          standartBannerListener?.onImpression(_tryGetAdStatusHandler(call));
        }
        break;

      case '1OnBannerAdFailedToShow':
        {
          if ((call.arguments as Object?) != null) {
            standartBannerListener?.onFailed(call.arguments["message"]);
          }
        }
        break;

      case '1OnBannerAdFailedToLoad':
        {
          if ((call.arguments as Object?) != null) {
            standartBannerListener?.onFailed(call.arguments["message"]);
          }
        }
        break;

      case '1OnBannerAdClicked':
        {
          standartBannerListener?.onClicked();
        }

        break;

      // banner Adaptive

      case '2OnBannerAdLoaded':
        {
          adaptiveBannerListener?.onLoaded();
        }
        break;

      case '2OnBannerAdShown':
        {
          adaptiveBannerListener?.onAdViewPresented();
        }
        break;

      case '2OnBannerAdImpression':
        {
          adaptiveBannerListener?.onImpression(_tryGetAdStatusHandler(call));
        }
        break;

      case '2OnBannerAdFailedToShow':
        {
          if ((call.arguments as Object?) != null) {
            adaptiveBannerListener?.onFailed(call.arguments["message"]);
          }
        }
        break;

      case '2OnBannerAdFailedToLoad':
        {
          if ((call.arguments as Object?) != null) {
            adaptiveBannerListener?.onFailed(call.arguments["message"]);
          }
        }
        break;

      case '2OnBannerAdClicked':
        {
          adaptiveBannerListener?.onClicked();
        }
        break;

      // banner Smart

      case '3OnBannerAdLoaded':
        {
          smartBannerListener?.onLoaded();
        }
        break;

      case '3OnBannerAdShown':
        {
          smartBannerListener?.onAdViewPresented();
        }
        break;

      case '3OnBannerAdImpression':
        {
          smartBannerListener?.onImpression(_tryGetAdStatusHandler(call));
        }
        break;

      case '3OnBannerAdFailedToShow':
        {
          if ((call.arguments as Object?) != null) {
            smartBannerListener?.onFailed(call.arguments["message"]);
          }
        }
        break;

      case '3OnBannerAdFailedToLoad':
        {
          if ((call.arguments as Object?) != null) {
            smartBannerListener?.onFailed(call.arguments["message"]);
          }
        }
        break;

      case '3OnBannerAdClicked':
        {
          smartBannerListener?.onClicked();
        }
        break;

      // banner Leader

      case '4OnBannerAdLoaded':
        {
          leaderBannerListener?.onLoaded();
        }
        break;

      case '4OnBannerAdShown':
        {
          leaderBannerListener?.onAdViewPresented();
        }
        break;

      case '4OnBannerAdImpression':
        {
          leaderBannerListener?.onImpression(_tryGetAdStatusHandler(call));
        }
        break;

      case '4OnBannerAdFailedToShow':
        {
          if ((call.arguments as Object?) != null) {
            leaderBannerListener?.onFailed(call.arguments["message"]);
          }
        }
        break;

      case '4OnBannerAdFailedToLoad':
        {
          if ((call.arguments as Object?) != null) {
            leaderBannerListener?.onFailed(call.arguments["message"]);
          }
        }
        break;

      case '4OnBannerAdClicked':
        {
          leaderBannerListener?.onClicked();
        }
        break;

      // banner MREC

      case '5OnBannerAdLoaded':
        {
          mrecBannerListener?.onLoaded();
        }
        break;

      case '5OnBannerAdShown':
        {
          mrecBannerListener?.onAdViewPresented();
        }
        break;

      case '5OnBannerAdImpression':
        {
          mrecBannerListener?.onImpression(_tryGetAdStatusHandler(call));
        }
        break;

      case '5OnBannerAdFailedToShow':
        {
          if ((call.arguments as Object?) != null) {
            mrecBannerListener?.onFailed(call.arguments["message"]);
          }
        }
        break;

      case '5OnBannerAdFailedToLoad':
        {
          if ((call.arguments as Object?) != null) {
            mrecBannerListener?.onFailed(call.arguments["message"]);
          }
        }
        break;

      case '5OnBannerAdClicked':
        {
          mrecBannerListener?.onClicked();
        }
        break;
    }
  }

  AdImpression? _tryGetAdStatusHandler(MethodCall call) {
    if ((call.arguments as Object?) != null) {
      double cpm = call.arguments["cpm"];
      int priceAccuracy = call.arguments["priceAccuracy"];
      int adType = call.arguments["adType"];
      String networkName = call.arguments["networkName"];
      String versionInfo = call.arguments["versionInfo"];
      String identifier = call.arguments["identifier"];
      int impressionDepth = call.arguments["impressionDepth"];
      double lifeTimeRevenue = call.arguments["lifeTimeRevenue"];
      String? creativeIdentifier = call.arguments["creativeIdentifier"];

      AdImpression adStatusHandler = AdImpression(
          adType,
          cpm,
          networkName,
          priceAccuracy,
          versionInfo,
          creativeIdentifier,
          identifier,
          impressionDepth,
          lifeTimeRevenue);

      return adStatusHandler;
    } else {
      return null;
    }
  }
}
