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
  String? _sdkVersion;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('CAS.AI Sample'),
          ),
          body: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_sdkVersion != null) Text('CAS.AI $_sdkVersion'),
                    const Spacer(),
                    Text('Plugin version ${CAS.getPluginVersion()}'),
                  ],
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isReady) ...[
                        BannerView(
                          key: _bannerViewKey,
                          size: AdSize.Banner,
                          isAutoloadEnabled: true,
                          refreshInterval: 20,
                          listener: BannerListener(size: AdSize.Banner),
                        ),
                        ElevatedButton(
                          child: const Text('Load next ad on upper widget'),
                          onPressed: () =>
                              _bannerViewKey.currentState?.loadNextAd(),
                        ),
                        BannerView(
                          size: AdSize.Leaderboard,
                          isAutoloadEnabled: true,
                          refreshInterval: 20,
                          listener: BannerListener(size: AdSize.Leaderboard),
                        )
                      ],
                      ElevatedButton(
                        // TODO Check isInterstitialReady
                        onPressed: _isReady ? () => showInterstitial() : null,
                        child: const Text('Show interstitial'),
                      ),
                      ElevatedButton(
                        // TODO Check isRewardedReady
                        onPressed: _isReady ? () => showRewarded() : null,
                        child: const Text('Show rewarded'),
                      ),
                      if (_isReady)
                        BannerView(
                          size: AdSize.MediumRectangle,
                          isAutoloadEnabled: true,
                          refreshInterval: 20,
                          listener:
                              BannerListener(size: AdSize.MediumRectangle),
                        ),
                      ElevatedButton(
                        onPressed:
                            _isReady ? () => createStandardBanner() : null,
                        child: const Text('Create standard banner'),
                      ),
                      ElevatedButton(
                        onPressed:
                            _isReady ? () => createAdaptiveBanner() : null,
                        child: const Text('Create adaptive banner'),
                      ),
                      ElevatedButton(
                        onPressed: _isReady ? () => changeBannerTop() : null,
                        child: const Text('Change banner position to top'),
                      ),
                      ElevatedButton(
                        onPressed: _isReady ? () => changeBannerBottom() : null,
                        child: const Text('Change banner to bottom'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Future<void> initialize() async {
    // Set Ads Settings
    CAS.settings.setDebugMode(true);
    CAS.settings.setTaggedAudience(Audience.notChildren);

    // Set Manual loading mode to disable auto requests
    // CAS.settings.setLoadingMode(LoadingManagerMode.manual);

    // Initialize SDK
    manager = CAS
        .buildManager()
        .withCasId("com.cleveradssolutions.plugin.flutter.example")
        .withTestMode(true)
        .withAdTypes(AdTypeFlags.Banner |
            AdTypeFlags.Interstitial |
            AdTypeFlags.Rewarded)
        // .withConsentFlow(
        //     ConsentFlow().withDismissListener(ConsentFlowDismissListenerImpl()))
        .withInitializationListener(InitializationListenerWrapper())
        .initialize();
  }

  Future<void> showInterstitial() async {
    final manager = this.manager;
    if (manager != null && await manager.isInterstitialReady()) {
      manager.showInterstitial(InterstitialListenerWrapper());
    }
  }

  Future<void> showRewarded() async {
    final manager = this.manager;
    if (manager != null && await manager.isRewardedAdReady()) {
      manager.showRewarded(InterstitialListenerWrapper());
    }
  }

  Future<void> createAdaptiveBanner() async {
    view = manager?.getAdView(AdSize.Adaptive);
    view?.setAdListener(BannerListener());
    view?.setBannerPosition(AdPosition.TopCenter);
    view?.showBanner();
  }

  Future<void> createStandardBanner() async {
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
