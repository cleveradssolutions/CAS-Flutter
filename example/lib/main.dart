import 'package:clever_ads_solutions/clever_ads_solutions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const String _casId = 'demo';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<BannerWidgetState> _bannerKey = GlobalKey();

  final CASInterstitial _interstitial = CASInterstitial.create(_casId);
  final CASRewarded _rewarded = CASRewarded.create(_casId);

  String? _sdkVersion;

  @override
  void initState() {
    super.initState();
    _initializeCAS();
  }

  @override
  void dispose() {
    super.dispose();
    _interstitial.dispose();
    _rewarded.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  LayoutBuilder(builder: (_, BoxConstraints constraints) {
                    return BannerWidget(
                      key: _bannerKey,
                      casId: _casId,
                      adListener: _getBannerListener(),
                      onImpressionListener: _getImpressionListener('Banner'),
                      size: AdSize.getAdaptiveBanner(constraints.maxWidth),
                    );
                  }),
                  ElevatedButton(
                    child: const Text('Load next ad on upper widget'),
                    onPressed: () => _bannerKey.currentState?.load(),
                  ),
                  ElevatedButton(
                    onPressed: _showInterstitial,
                    child: const Text('Show interstitial'),
                  ),
                  ElevatedButton(
                    onPressed: _showRewarded,
                    child: const Text('Show rewarded'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initializeCAS() {
    // Set Ads Settings
    CAS.settings.setDebugMode(true);
    CAS.settings.setTaggedAudience(Audience.notChildren);

    // Set Manual loading mode to disable auto requests
    // CAS.settings.setLoadingMode(LoadingMode.Manual);

    // Initialize SDK
    CAS
        .buildManager()
        .withCasId(_casId)
        .withTestMode(true)
        .withConsentFlow(ConsentFlow.create().withDismissListener(
          OnDismissListener((ConsentStatus status) {
            logDebug('Consent flow dismissed: $status');
          }),
        ).withPrivacyPolicy('https://example.com/'))
        .withCompletionListener(_onCASInitialized)
        .build();

    _loadAds();
  }

  void _onCASInitialized(InitConfig initConfig) async {
    final String? error = initConfig.error;
    if (error != null) {
      logDebug('Ad manager initialization failed: $error');
      return;
    }
    logDebug('Ad manager initialized');

    final String sdkVersion = await CAS.getSDKVersion();
    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  void _loadAds() {
    _interstitial.contentCallback = _getAdContentCallback('Interstitial');
    _interstitial.impressionListener = _getImpressionListener('Interstitial');
    _interstitial.load();

    _rewarded.contentCallback = _getAdContentCallback('Rewarded');
    _rewarded.impressionListener = _getImpressionListener('Rewarded');
    _rewarded.load();
  }

  void _showInterstitial() async {
    if (await _interstitial.isLoaded()) {
      _interstitial.show();
    } else {
      logDebug('Interstitial ad not ready to show');
    }
  }

  void _showRewarded() async {
    if (await _rewarded.isLoaded()) {
      _rewarded.show(OnRewardEarnedListener((ad) async {
        logDebug('Rewarded ad earned reward: ${await ad.getSourceName()}');
      }));
    } else {
      logDebug('Rewarded ad not ready to show');
    }
  }

  AdViewListener _getBannerListener() {
    return AdViewListener(
      onAdViewLoaded: () => logDebug('Banner ad loaded!'),
      onAdViewFailed: (message) => logDebug('Banner failed! $message'),
      onAdViewPresented: () => logDebug('Banner ad presented!'),
      onAdViewClicked: () => logDebug('Banner ad clicked!'),
    );
  }

  ScreenAdContentCallback _getAdContentCallback(String name) {
    return ScreenAdContentCallback(
      onAdLoaded: (ad) async =>
          logDebug('$name ad loaded: ${await ad.getSourceName()}'),
      onAdFailedToLoad: (_, error) =>
          logDebug('$name ad failed to load: $error'),
      onAdShowed: (ad) async =>
          logDebug('$name ad showed: ${await ad.getSourceName()}'),
      onAdFailedToShow: (_, error) =>
          logDebug('$name ad failed to show: $error'),
      onAdClicked: (ad) async =>
          logDebug('$name ad clicked: ${await ad.getSourceName()}'),
      onAdDismissed: (ad) async =>
          logDebug('$name ad dismissed: ${await ad.getSourceName()}'),
    );
  }

  OnAdImpressionListener _getImpressionListener(String name) {
    return OnAdImpressionListener((ad) async =>
        logDebug('$name ad impression: ${await ad.getSourceName()}'));
  }
}

void logDebug(String message) {
  if (kDebugMode) {
    debugPrint('CAS.AI.Flutter.Example: $message');
  }
}
