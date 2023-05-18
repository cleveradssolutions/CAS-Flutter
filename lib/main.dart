import 'package:clever_ads_solutions/public/AdCallback.dart';
import 'package:clever_ads_solutions/public/AdImpression.dart';
import 'package:clever_ads_solutions/public/AdLoadCallback.dart';
import 'package:clever_ads_solutions/public/AdPosition.dart';
import 'package:clever_ads_solutions/public/AdSize.dart';
import 'package:clever_ads_solutions/public/AdType.dart';
import 'package:clever_ads_solutions/public/AdViewListener.dart';
import 'package:clever_ads_solutions/public/CASBannerView.dart';
import 'package:clever_ads_solutions/public/ConsentFlow.dart';
import 'package:clever_ads_solutions/public/InitializationListener.dart';
import 'package:clever_ads_solutions/public/ManagerBuilder.dart';
import 'package:clever_ads_solutions/public/MediationManager.dart';
import 'package:flutter/material.dart';
import 'package:clever_ads_solutions/CAS.dart';
import 'package:clever_ads_solutions/public/AdTypes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Clever Ads Solutions Example App'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: Text('Inititalize'),
                onPressed: () => inititalize(),
              ),
              ElevatedButton(
                child: Text('Show interstitial'),
                onPressed: () => showInterstitial(),
              ),
              ElevatedButton(
                child: Text('Show rewarded'),
                onPressed: () => showRewarded(),
              ),
              ElevatedButton(
                child: Text('Create standart banner'),
                onPressed: () => createStandartBanner(),
              ),
              ElevatedButton(
                child: Text('Create adaptive banner'),
                onPressed: () => createAdaptiveBanner(),
              ),
              ElevatedButton(
                child: Text('Change banner position to top'),
                onPressed: () => changeBannerTop(),
              ),
              ElevatedButton(
                child: Text('Change banner to bottom'),
                onPressed: () => changeBannerBottom(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  MediationManager? manager;

  Future<void> inititalize() async {
    CAS.setDebugMode(true);

    CAS.setFlutterVersion("1.20.0");

    CAS.setAnalyticsCollectionEnabled(true);
    //CAS.validateIntegration();

    ManagerBuilder builder = CAS
        .buildManager()
        .withTestMode(true)
        .withCasId("demo")
        .withAdTypes(AdTypeFlags.Banner |
            AdTypeFlags.Rewarded |
            AdTypeFlags.Interstitial)
        .withInitializationListener(InitializationListenerWrapper());

    manager = builder.initialize();
  }

  Future<void> showInterstitial() async {
    manager?.showInterstitial(InterstitialListenerWrapper());
  }

  Future<void> showRewarded() async {
    manager?.showRewarded(InterstitialListenerWrapper());
  }

  CASBannerView? view;
  Future<void> createAdaptiveBanner() async {
    view = manager?.getAdView(AdSize.Adaptive);
    view?.setAdListener(BannerListener());
    view?.setBannerPosition(AdPosition.TopCenter);
    view?.showBanner();
  }

  Future<void> createStandartBanner() async {
    view = manager?.getAdView(AdSize.Banner);
    view?.setAdListener(BannerListener());
    view?.showBanner();
  }

  void changeBannerTop() {
    view?.setBannerPosition(AdPosition.TopCenter);
  }

  void changeBannerBottom() {
    view?.setBannerPosition(AdPosition.BottomCenter);
  }
}

class InitializationListenerWrapper extends InitializationListener {
  @override
  void onCASInitialized(bool success, String error) {}
}

class InterstitialListenerWrapper extends AdCallback {
  @override
  void onClicked() {}

  @override
  void onClosed() {}

  @override
  void onComplete() {}

  @override
  void onImpression(AdImpression? adImpression) {}

  @override
  void onShowFailed(String? message) {}

  @override
  void onShown() {}
}

class BannerListener extends AdViewListener {
  @override
  void onAdViewPresented() {}

  @override
  void onClicked() {}

  @override
  void onFailed(String? message) {}

  @override
  void onImpression(AdImpression? adImpression) {}

  @override
  void onLoaded() {}
}

class LoadCallback extends AdLoadCallback {
  @override
  void onAdFailedToLoad(AdType adType, String? error) {}

  @override
  void onAdLoaded(AdType adType) {}
}
