import 'package:clever_ads_solutions/clever_ads_solutions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<BannerViewState> _bannerViewKey = GlobalKey();
  MediationManager? manager;
  CASBannerView? view;
  bool _isReady = false;

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
                  child: const Text('Initialize'),
                  onPressed: () => initialize(),
                ),
                if (_isReady)
                  BannerView(
                    key: _bannerViewKey,
                    size: AdSize.Banner,
                    isAutoloadEnabled: true,
                    refreshInterval: 20,
                    listener: BannerListener(size: AdSize.Banner),
                  ),
                if (_isReady)
                  ElevatedButton(
                    child: const Text('Load next add on upper widget'),
                    onPressed: () => _bannerViewKey.currentState?.loadNextAd(),
                  ),
                ElevatedButton(
                  child: const Text('Show interstitial'),
                  onPressed: () => showInterstitial(),
                ),
                if (_isReady)
                  BannerView(
                    size: AdSize.Leaderboard,
                    isAutoloadEnabled: true,
                    refreshInterval: 20,
                    listener: BannerListener(size: AdSize.Leaderboard),
                  ),
                ElevatedButton(
                  child: const Text('Show rewarded'),
                  onPressed: () => showRewarded(),
                ),
                if (_isReady)
                  BannerView(
                    size: AdSize.MediumRectangle,
                    isAutoloadEnabled: true,
                    refreshInterval: 20,
                    listener: BannerListener(size: AdSize.MediumRectangle),
                  ),
                ElevatedButton(
                  child: const Text('Create standart banner'),
                  onPressed: () => createStandartBanner(),
                ),
                ElevatedButton(
                  child: const Text('Create adaptive banner'),
                  onPressed: () => createAdaptiveBanner(),
                ),
                ElevatedButton(
                  child: const Text('Change banner position to top'),
                  onPressed: () => changeBannerTop(),
                ),
                ElevatedButton(
                  child: const Text('Change banner to bottom'),
                  onPressed: () => changeBannerBottom(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> initialize() async {
    CAS.setDebugMode(true);

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
    debugPrint("isReady $isReady");
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
    debugPrint("isReady $isReady");
    manager?.showInterstitial(InterstitialListenerWrapper());
  }

  Future<void> showRewarded() async {
    manager?.showRewarded(InterstitialListenerWrapper());
  }

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
  void onCASInitialized(InitConfig config) {}
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
    debugPrint("Banner ${size.toString()} ad was presented!");
  }

  @override
  void onClicked() {
    debugPrint("Banner ${size.toString()} ad was pressed!");
  }

  @override
  void onFailed(String? message) {
    debugPrint("Banner ${size.toString()} error! $message");
  }

  @override
  void onImpression(AdImpression? adImpression) {
    debugPrint("Banner ${size.toString()} impression: $adImpression");
  }

  @override
  void onLoaded() {
    debugPrint("Banner ${size.toString()} ad was loaded!");
  }
}

class LoadCallback extends AdLoadCallback {
  @override
  void onAdFailedToLoad(AdType adType, String? error) {}

  @override
  void onAdLoaded(AdType adType) {}
}
