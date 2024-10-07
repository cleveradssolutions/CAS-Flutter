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

class _MyAppState extends State<MyApp> implements AdLoadCallback {
  final GlobalKey<BannerWidgetState> _bannerKey = GlobalKey();
  MediationManager? _manager;

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
                        onPressed:
                            _isInterstitialReady ? _showInterstitial : null,
                        child: const Text('Show interstitial'),
                      ),
                      ElevatedButton(
                        onPressed: _isRewardedReady ? _showRewarded : null,
                        child: const Text('Show rewarded'),
                      ),
                      if (_isReady)
                        BannerWidget(
                          size: AdSize.mediumRectangle,
                          isAutoloadEnabled: true,
                          refreshInterval: 20,
                          listener: BannerListener("mediumRectangle"),
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
    final String? error = initConfig.error;
    if (error != null) {
      logDebug("Ad manager initialization failed: $error");
      return;
    }
    logDebug("Ad manager initialized");

    setState(() {
      _isReady = true;
    });

    _manager?.setAdLoadCallback(this);
    final String sdkVersion = await CAS.getSDKVersion();
    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  @override
  void onAdLoaded(AdType adType) {
    if (adType == AdType.Interstitial) {
      setState(() {
        _isInterstitialReady = true;
      });
    } else if (adType == AdType.Rewarded) {
      setState(() {
        _isRewardedReady = true;
      });
    }
  }

  @override
  void onAdFailedToLoad(AdType adType, String? error) {
    logDebug("Ad ${adType.name} failed to load: ${error}");
  }

  void _onConsentFlowDismiss(Status status) {
    logDebug("Consent flow dismissed");
  }

  void _showInterstitial() {
    _manager?.showInterstitial(AdListener("Interstitial"));
  }

  void _showRewarded() {
    _manager?.showRewarded(AdListener("Rewarded"));
  }
}

class AdListener extends AdCallback {
  String? _name;

  AdListener(this._name);

  @override
  void onClicked() {
    debugPrint("$_name ad was pressed!");
  }

  @override
  void onClosed() {
    debugPrint("$_name ad was closed!");
  }

  @override
  void onComplete() {
    debugPrint("$_name ad was complete!");
  }

  @override
  void onImpression(AdImpression? adImpression) {
    debugPrint("$_name ad did impression: $adImpression!");
  }

  @override
  void onShowFailed(String? message) {
    debugPrint("$_name ad failed to show: $message!");
  }

  @override
  void onShown() {
    debugPrint("$_name ad shown!");
  }
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
