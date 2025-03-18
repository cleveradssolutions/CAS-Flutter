import 'package:clever_ads_solutions/clever_ads_solutions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

class _HomeScreenState extends State<HomeScreen>
    implements AdLoadCallback, OnDismissListener {
  final GlobalKey<BannerWidgetState> _bannerKey = GlobalKey();
  MediationManager? _manager;

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
                  BannerWidget(
                    key: _bannerKey,
                    listener: BannerListener('banner'),
                  ),
                  ElevatedButton(
                    child: const Text('Load next ad on upper widget'),
                    onPressed: () => _bannerKey.currentState?.loadNextAd(),
                  ),
                  BannerWidget(
                    size: AdSize.leaderboard,
                    refreshInterval: 20,
                    listener: BannerListener('leaderboard'),
                  ),
                  ElevatedButton(
                    onPressed: _isInterstitialReady ? _showInterstitial : null,
                    child: const Text('Show interstitial'),
                  ),
                  ElevatedButton(
                    onPressed: _isRewardedReady ? _showRewarded : null,
                    child: const Text('Show rewarded'),
                  ),
                  BannerWidget(
                    size: AdSize.mediumRectangle,
                    refreshInterval: 60,
                    listener: BannerListener('mediumRectangle'),
                  ),
                  LayoutBuilder(
                    builder: (_, BoxConstraints constraints) => BannerWidget(
                      size: AdSize.getAdaptiveBanner(constraints.maxWidth),
                      listener: BannerListener('adaptive'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
        .withCasId('com.FailGames.RusCarsCrash')
        .withTestMode(true)
        .withMediationExtras("testMediationData",
            "{\"admob_app_id\":\"ca-app-pub-3940256099942544~3347511713\",\"admob_app_open_ad\":\"ca-app-pub-3940256099942544\\/9257395921\",\"applovin_app_id\":\"TxhDiMQVbncc9h4M1QzqCMODZz7gMzTwuF8bbT6CKipTPuqQJoFV8dihbrNzpxthA0ImTOyt6mLWeAxyyBS5q9\",\"providers\":[{\"net\":\"Vungle\",\"label\":\"Bid\",\"lvl\":0,\"settings\":\"{\\\"ApplicationID\\\":\\\"6694f35c4d6765df32fed8c4\\\",\\\"AccountID\\\":\\\"5c657afed9e6e60012bab5d9\\\",\\\"banner_rtb\\\":\\\"B_BID-4817686\\\",\\\"banner_rtbMREC\\\":\\\"B_MREC_BID-8528832\\\",\\\"inter_rtb\\\":\\\"I_BID-5522832\\\",\\\"reward_rtb\\\":\\\"V_BID-8760313\\\",\\\"appopen_rtb\\\":\\\"O_BID-0247338\\\",\\\"native_rtb\\\":\\\"N_BID-3340641\\\"}\"}],\"bEcpm\":[0.01],\"iEcpm\":[0.01],\"rEcpm\":[0.01],\"oEcpm\":[0.01],\"nEcpm\":[0.01]}\n")
        .withAdTypes(AdTypeFlags.banner |
            AdTypeFlags.interstitial |
            AdTypeFlags.rewarded)
        .withConsentFlow(ConsentFlow.create()
            .withDismissListener(this)
            .withPrivacyPolicy('https://example.com/'))
        .withCompletionListener(_onCASInitialized)
        .build();
  }

  void _onCASInitialized(InitConfig initConfig) async {
    final String? error = initConfig.error;
    if (error != null) {
      logDebug('Ad manager initialization failed: $error');
      return;
    }
    logDebug('Ad manager initialized');

    _manager?.setAdLoadCallback(this);

    final String sdkVersion = await CAS.getSDKVersion();
    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  @override
  void onConsentFlowDismissed(int status) {
    logDebug('Consent flow dismissed: $status');
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
    logDebug('Ad ${adType.name} failed to load: $error');
  }

  void _showInterstitial() {
    _manager?.showInterstitial(AdListener('Interstitial'));
  }

  void _showRewarded() {
    _manager?.showRewarded(AdListener('Rewarded'));
  }
}

class AdListener extends AdCallback {
  final String? _name;

  AdListener(this._name);

  @override
  void onClicked() {
    logDebug('$_name ad was pressed!');
  }

  @override
  void onClosed() {
    logDebug('$_name ad was closed!');
  }

  @override
  void onComplete() {
    logDebug('$_name ad was complete!');
  }

  @override
  void onImpression(AdImpression? adImpression) {
    logDebug('$_name ad did impression: $adImpression!');
  }

  @override
  void onShowFailed(String? message) {
    logDebug('$_name ad failed to show: $message!');
  }

  @override
  void onShown() {
    logDebug('$_name ad shown!');
  }
}

class BannerListener extends AdViewListener {
  final String _name;

  BannerListener(this._name);

  @override
  void onAdViewPresented() {
    logDebug('Banner $_name ad was presented!');
  }

  @override
  void onClicked() {
    logDebug('Banner $_name ad was pressed!');
  }

  @override
  void onFailed(String? message) {
    logDebug('Banner $_name error! $message');
  }

  @override
  void onImpression(AdImpression? adImpression) {
    logDebug('Banner $_name impression: $adImpression');
  }

  @override
  void onLoaded() {
    logDebug('Banner $_name ad was loaded!');
  }
}

void logDebug(String message) {
  if (kDebugMode) {
    debugPrint('CAS.AI.Flutter.Example: $message');
  }
}
