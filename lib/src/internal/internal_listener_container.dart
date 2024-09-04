import 'dart:async';

import 'package:flutter/services.dart';

import '../ad_view_listener.dart';
import 'ad_listener.dart';

class InternalListenerContainer extends AdListener {
  AdViewListener? standartBannerListener;
  AdViewListener? adaptiveBannerListener;
  AdViewListener? smartBannerListener;
  AdViewListener? leaderBannerListener;
  AdViewListener? mrecBannerListener;

  InternalListenerContainer(MethodChannel channel) {
    channel.setMethodCallHandler(handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
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
          standartBannerListener?.onImpression(tryGetAdImpression(call));
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
          adaptiveBannerListener?.onImpression(tryGetAdImpression(call));
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
          smartBannerListener?.onImpression(tryGetAdImpression(call));
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
          leaderBannerListener?.onImpression(tryGetAdImpression(call));
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
          mrecBannerListener?.onImpression(tryGetAdImpression(call));
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

}
