import 'package:clever_ads_solutions/CAS.dart';
import 'package:clever_ads_solutions/public/AdCallback.dart';
import 'package:clever_ads_solutions/public/AdImpression.dart';
import 'package:clever_ads_solutions/public/AdLoadCallback.dart';
import 'package:clever_ads_solutions/public/AdPosition.dart';
import 'package:clever_ads_solutions/public/AdSize.dart';
import 'package:clever_ads_solutions/public/AdType.dart';
import 'package:clever_ads_solutions/public/AdTypes.dart';
import 'package:clever_ads_solutions/public/AdViewListener.dart';
import 'package:clever_ads_solutions/public/BannerView.dart';
import 'package:clever_ads_solutions/public/CASBannerView.dart';
import 'package:clever_ads_solutions/public/InitConfig.dart';
import 'package:clever_ads_solutions/public/InitializationListener.dart';
import 'package:clever_ads_solutions/public/ManagerBuilder.dart';
import 'package:clever_ads_solutions/public/MediationManager.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isReady = false;
  GlobalKey<BannerViewState> _bannerViewKey = GlobalKey();

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    child: Text('Initialize'),
                    onPressed: () => initialize(),
                  ),
                  if (_isReady)
                    BannerView(
                      key: _bannerViewKey,
                      size: AdSize.Banner,
                      isAutoloadEnabled: true,
                      refreshInterval: 20,
                      listener: new BannerListener(size: AdSize.Banner),
                    ),
                  if (_isReady)
                    ElevatedButton(
                      child: Text('Load next add on upper widget'),
                      onPressed: () =>
                          _bannerViewKey.currentState?.loadNextAd(),
                    ),
                  ElevatedButton(
                    child: Text('Show interstitial'),
                    onPressed: () => showInterstitial(),
                  ),
                  if (_isReady)
                    BannerView(
                      size: AdSize.Leaderboard,
                      isAutoloadEnabled: true,
                      refreshInterval: 20,
                      listener: new BannerListener(size: AdSize.Leaderboard),
                    ),
                  ElevatedButton(
                    child: Text('Show rewarded'),
                    onPressed: () => showRewarded(),
                  ),
                  if (_isReady)
                    BannerView(
                      size: AdSize.MediumRectangle,
                      isAutoloadEnabled: true,
                      refreshInterval: 20,
                      listener: new BannerListener(
                          size: AdSize.MediumRectangle),
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
            )
        ),
      ),
    );
  }

  MediationManager? manager;

  Future<void> initialize() async {
    CAS.setDebugMode(true);

    CAS.setFlutterVersion("1.20.0");

    //CAS.validateIntegration();

    ManagerBuilder builder = CAS
        .buildManager()
        .withTestMode(true)
        .withCasId("example")
        .withAdTypes(AdTypeFlags.Banner |
            AdTypeFlags.Rewarded |
            AdTypeFlags.Interstitial)
        .withInitializationListener(InitializationListenerWrapper());

    manager = builder.initialize();
    bool isReady = await getInterStatus();
    print(isReady);
    setState(() {
      _isReady = manager != null;
    });
  }

  Future<bool> getInterStatus() async {
    bool isReady = false;
    final manager = this.manager;
    if (manager != null) {
      isReady = await manager.isInterstitialReady();
    }
    return isReady;
  }

  Future<void> showInterstitial() async {
    bool isReady = await getInterStatus();
    print(isReady);
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
    view?.setBannerPositionWithOffset(25, 100);
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
  void onCASInitialized(InitConfig initConfig) {}
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
  AdSize? size;

  BannerListener({this.size});

  @override
  void onAdViewPresented() {
    debugPrint("Banner ${this.size.toString()} ad was presented!");
  }

  @override
  void onClicked() {
    debugPrint("Banner ${this.size.toString()} ad was pressed!");
  }

  @override
  void onFailed(String? message) {
    debugPrint("Banner ${this.size.toString()} error! $message");
  }

  @override
  void onImpression(AdImpression? adImpression) {
    debugPrint("Banner ${this.size.toString()} impression: $adImpression");
  }

  @override
  void onLoaded() {
    debugPrint("Banner ${this.size.toString()} ad was loaded!");
  }
}

class LoadCallback extends AdLoadCallback {
  @override
  void onAdFailedToLoad(AdType adType, String? error) {}

  @override
  void onAdLoaded(AdType adType) {}
}