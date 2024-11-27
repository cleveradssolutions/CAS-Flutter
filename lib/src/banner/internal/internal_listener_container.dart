import 'dart:async';

import 'package:flutter/services.dart';

import '../../ad_impression.dart';
import '../ad_view_listener.dart';

class InternalListenerContainer {
  AdViewListener? standardBannerListener;
  AdViewListener? adaptiveBannerListener;
  AdViewListener? smartBannerListener;
  AdViewListener? leaderBannerListener;
  AdViewListener? mrecBannerListener;

  InternalListenerContainer(MethodChannel channel) {
    channel.setMethodCallHandler(handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'OnBannerAdLoaded':
        getBannerListener(call)?.onLoaded();
        break;

      case 'OnBannerAdShown':
        getBannerListener(call)?.onAdViewPresented();
        break;

      case 'OnBannerAdImpression':
        getBannerListener(call)?.onImpression(AdImpression.tryParse(call));
        break;

      case 'OnBannerAdFailedToShow':
        if ((call.arguments as Object?) != null) {
          getBannerListener(call)?.onFailed(call.arguments["message"]);
        }
        break;

      case 'OnBannerAdFailedToLoad':
        if ((call.arguments as Object?) != null) {
          getBannerListener(call)?.onFailed(call.arguments["message"]);
        }
        break;

      case 'OnBannerAdClicked':
        getBannerListener(call)?.onClicked();
        break;
    }
  }

  AdViewListener? getBannerListener(MethodCall call) {
    switch (call.arguments["name"]) {
      case "adaptive":
        return adaptiveBannerListener;
      case "smart":
        return smartBannerListener;
      case "leader":
        return leaderBannerListener;
      case "mrec":
        return mrecBannerListener;
      case "standard":
        return standardBannerListener;
      default:
        return null;
    }
  }
}
