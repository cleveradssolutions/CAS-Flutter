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
        // ignore: deprecated_member_use_from_same_package
        getBannerListener(call)?.onLoaded();
        break;

      case 'OnBannerAdShown':
        // ignore: deprecated_member_use_from_same_package
        getBannerListener(call)?.onAdViewPresented();
        break;

      case 'OnBannerAdImpression':
        // ignore: deprecated_member_use_from_same_package
        getBannerListener(call)?.onImpression(AdImpression.tryParse(call));
        break;

      case 'OnBannerAdFailedToShow':
        if ((call.arguments as Object?) != null) {
          // ignore: deprecated_member_use_from_same_package
          getBannerListener(call)?.onFailed(call.arguments["message"]);
        }
        break;

      case 'OnBannerAdFailedToLoad':
        if ((call.arguments as Object?) != null) {
          // ignore: deprecated_member_use_from_same_package
          getBannerListener(call)?.onFailed(call.arguments["message"]);
        }
        break;

      case 'OnBannerAdClicked':
        // ignore: deprecated_member_use_from_same_package
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
