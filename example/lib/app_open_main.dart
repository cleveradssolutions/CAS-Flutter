import 'package:clever_ads_solutions/clever_ads_solutions.dart';
import 'package:flutter/material.dart';

import 'log.dart';
import 'main.dart';

void main() {
  final appOpenAd = CASAppOpen.create("demo");
  appOpenAd.contentCallback = AppOpenAdListener();
  appOpenAd.loadAd(AppOpenAdLoadListener());
}

class AppOpenAdLoadListener extends AdLoadCallback {
  @override
  void onAdLoaded() {
    logDebug("App Open Ad loaded");
    if (isLoadingAppResources) {
      isVisibleAppOpenAd = true;
      appOpenAd.show(SampleAppOpenAdActivity.this);
    }

    // runApp(const MyApp());
  }

  @override
  void onAdFailedToLoad(AdError adError) {
    logDebug("App Open Ad failed to load: " + adError.getMessage());
    runApp(const MyApp());
  }
}

class AppOpenAdListener extends AdCallback {
  @override
  void onShown(AdStatusHandler adStatusHandler) {
    logDebug("App Open Ad shown");
  }

  @override
  void onShowFailed(String message) {
    logDebug("App Open Ad show failed: " + message);

    isVisibleAppOpenAd = false;
    startNextActivity();
  }

  @override
  void onClosed() {
    logDebug("App Open Ad closed");

    isVisibleAppOpenAd = false;
    startNextActivity();
  }
}
