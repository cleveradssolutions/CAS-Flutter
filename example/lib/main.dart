import 'package:clever_ads_solutions/clever_ads_solutions.dart';
import 'package:flutter/material.dart';

import 'log.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<BannerWidgetState> _bannerKey = GlobalKey();
  GlobalKey<BannerWidgetState>? _dynamicBannerKey;
  MediationManager? _manager;

  //BannerWidget? _bannerWidget;
  bool _isReady = false;
  bool _isInterstitialReady = false;
  bool _isRewardedReady = false;
  String? _sdkVersion;

  @override
  void initState() {
    super.initState();
    _initialize();
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
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_sdkVersion != null) Text('CAS.AI $_sdkVersion'),
                    const Spacer(),
                    Text('Plugin version ${CAS.getPluginVersion()}'),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Column(
                    children: [
                      if (_isReady) ...[
                        BannerWidget(
                          key: _bannerKey,
                          listener: BannerListener("banner"),
                        ),
                        ElevatedButton(
                          child: const Text('Load next ad on upper widget'),
                          onPressed: () =>
                              _bannerKey.currentState?.loadNextAd(),
                        ),
                        BannerWidget(
                          size: AdSize.leaderboard,
                          isAutoloadEnabled: true,
                          refreshInterval: 20,
                          listener: BannerListener("leaderboard"),
                        )
                      ],
                      ElevatedButton(
                        onPressed: _isInterstitialReady
                            ? () => _showInterstitial()
                            : null,
                        child: const Text('Show interstitial'),
                      ),
                      ElevatedButton(
                        onPressed:
                            _isRewardedReady ? () => _showRewarded() : null,
                        child: const Text('Show rewarded'),
                      ),
                      if (_isReady)
                        BannerWidget(
                          size: AdSize.mediumRectangle,
                          isAutoloadEnabled: true,
                          refreshInterval: 20,
                          listener: BannerListener("mediumRectangle"),
                        ),
                      ElevatedButton(
                        onPressed: _isReady ? _createStandardBanner : null,
                        child: const Text('Create standard banner'),
                      ),
                      ElevatedButton(
                        onPressed: _isReady ? _createAdaptiveBanner : null,
                        child: const Text('Create adaptive banner'),
                      ),
                      ElevatedButton(
                        onPressed: _isReady
                            ? () => _bannerKey.currentState
                                ?.setBannerPosition(AdPosition.topCenter)
                            : null,
                        child: const Text('Move banner to top'),
                      ),
                      ElevatedButton(
                        onPressed: _isReady
                            ? () => _bannerKey.currentState
                                ?.setBannerPosition(AdPosition.middleCenter)
                            : null,
                        child: const Text('Move banner to middle'),
                      ),
                      ElevatedButton(
                        onPressed: _isReady
                            ? () => _bannerKey.currentState
                                ?.setBannerPosition(AdPosition.bottomCenter)
                            : null,
                        child: const Text('Move banner to bottom'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  void _initialize() {
    // Set Ads Settings
    CAS.settings.setDebugMode(true);
    CAS.settings.setTaggedAudience(Audience.notChildren);

    // Set Manual loading mode to disable auto requests
    // CAS.settings.setLoadingMode(LoadingManagerMode.manual);

    // Initialize SDK
    _manager = CAS
        .buildManager()
        .withCasId("demo")
        .withTestMode(true)
        .withAdTypes(AdTypeFlags.Banner |
            AdTypeFlags.Interstitial |
            AdTypeFlags.Rewarded)
        .withConsentFlow(ConsentFlow(isEnabled: true)
            .withDismissListener(_onConsentFlowDismiss))
        .withCompletionListener(_onCASInitialized)
        .build();
  }

  void _onCASInitialized(InitConfig initConfig) async {
    String? error = initConfig.error;
    logDebug(error == null
        ? "Ad manager initialized"
        : "Ad manager initialization failed: $error");

    String sdkVersion = await CAS.getSDKVersion();
    setState(() {
      _isReady = true;
      _sdkVersion = sdkVersion;
    });
    // TODO Use AdLoadCallback
    _manager?.isInterstitialReady().then((status) {
      setState(() {
        _isInterstitialReady = status;
      });
    });
    _manager?.isRewardedAdReady().then((status) {
      setState(() {
        _isRewardedReady = status;
      });
    });
  }

  void _onConsentFlowDismiss(Status status) {
    logDebug("Consent flow dismissed");
  }

  Future<void> _showInterstitial() async {
    final manager = _manager;
    if (manager != null && await manager.isInterstitialReady()) {
      manager.showInterstitial(InterstitialListenerWrapper());
    }
  }

  Future<void> _showRewarded() async {
    final manager = _manager;
    if (manager != null && await manager.isRewardedAdReady()) {
      manager.showRewarded(InterstitialListenerWrapper());
    }
  }

  Future<void> _createAdaptiveBanner() async {
    _dynamicBannerKey?.currentState?.hideBanner();
    _dynamicBannerKey?.currentState?.dispose();

    _dynamicBannerKey = GlobalKey<BannerWidgetState>();
    BannerWidget(
      key: _dynamicBannerKey,
      size: await AdSize.getAdaptiveBannerInScreen(),
      listener: BannerListener("adaptive"),
      // position: AdPosition.topCenter
    );
    _dynamicBannerKey?.currentState?.showBanner();
  }

  void _createStandardBanner() {
    _dynamicBannerKey?.currentState?.hideBanner();
    _dynamicBannerKey?.currentState?.dispose();

    _dynamicBannerKey = GlobalKey<BannerWidgetState>();
    BannerWidget(
      key: _dynamicBannerKey,
      listener: BannerListener("standard"),
      // position: AdPosition.topCenter
    );
    _dynamicBannerKey?.currentState?.showBanner();
    // view?.setBannerPositionWithOffset(25, 100);
  }
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
  String? _name;

  BannerListener(this._name);

  @override
  void onAdViewPresented() {
    debugPrint("Banner $_name ad was presented!");
  }

  @override
  void onClicked() {
    debugPrint("Banner $_name ad was pressed!");
  }

  @override
  void onFailed(String? message) {
    debugPrint("Banner $_name error! $message");
  }

  @override
  void onImpression(AdImpression? adImpression) {
    debugPrint("Banner $_name impression: $adImpression");
  }

  @override
  void onLoaded() {
    debugPrint("Banner $_name ad was loaded!");
  }
}

class LoadCallback extends AdLoadCallback {
  @override
  void onAdFailedToLoad(AdType adType, String? error) {}

  @override
  void onAdLoaded(AdType adType) {}
}
