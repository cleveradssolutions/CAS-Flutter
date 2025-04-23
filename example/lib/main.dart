import 'package:clever_ads_solutions/clever_ads_solutions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const String _casId = 'com.FailGames.RusCarsCrash';
// const String _casId = 'demo';

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

class _HomeScreenState extends State<HomeScreen> implements OnDismissListener {
  final GlobalKey<BannerWidgetState> _bannerKey = GlobalKey();

  CASInterstitial? _interstitial;
  bool _isInterstitialReady = false;

  CASRewarded? _rewarded;
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
                  // BannerWidget(
                    // key: _bannerKey,
                    // listener: BannerListener('Standard'),
                  // ),
                  ElevatedButton(
                    child: const Text('Load next ad on upper widget'),
                    onPressed: () => _bannerKey.currentState?.load(),
                  ),
                  // BannerWidget(
                  //   size: AdSize.leaderboard,
                  //   refreshInterval: 20,
                  //   listener: BannerListener('Leaderboard'),
                  // ),
                  ElevatedButton(
                    onPressed: _isInterstitialReady ? _showInterstitial : null,
                    child: const Text('Show interstitial'),
                  ),
                  ElevatedButton(
                    onPressed: _isRewardedReady ? _showRewarded : null,
                    child: const Text('Show rewarded'),
                  ),
                  // BannerWidget(
                  //   size: AdSize.mediumRectangle,
                  //   refreshInterval: 60,
                  //   listener: BannerListener('MediumRectangle'),
                  // ),
                  LayoutBuilder(builder: (_, BoxConstraints constraints) {
                    logDebug(
                        'Build layout with size ${constraints.maxWidth}-${constraints.maxHeight}');
                    return BannerWidget(
                      key: _bannerKey,
                      size: AdSize.getAdaptiveBanner(constraints.maxWidth),
                      refreshInterval: 120,
                      listener: BannerListener('Adaptive'),
                    );
                  }),
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
    CAS.settings.setTestDeviceId('250B851807B25F2887D4A7A420C579DA');
    CAS.settings.setDebugMode(true);
    CAS.settings.setTaggedAudience(Audience.notChildren);

    // Set Manual loading mode to disable auto requests
    // CAS.settings.setLoadingMode(LoadingManagerMode.manual);

    // Initialize SDK
    CAS
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

    final interstitial = CASInterstitial.create(_casId);
    interstitial.contentCallback = ContentCallback('Interstitial', _onAdLoaded);
    interstitial.impressionListener = ImpressionListener('Interstitial');
    interstitial.load();
    _interstitial = interstitial;

    final rewarded = CASRewarded.create(_casId);
    rewarded.contentCallback = ContentCallback('Rewarded', _onAdLoaded);
    rewarded.impressionListener = ImpressionListener('Rewarded');
    rewarded.load();
    _rewarded = rewarded;

    final String sdkVersion = await CAS.getSDKVersion();
    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  @override
  void onConsentFlowDismissed(int status) {
    logDebug('Consent flow dismissed: $status');
  }

  void _onAdLoaded(AdFormat adFormat) {
    setState(() {
      if (adFormat == AdFormat.interstitial) {
        _isInterstitialReady = true;
      } else if (adFormat == AdFormat.rewarded) {
        _isRewardedReady = true;
      }
    });
  }

  void _showInterstitial() {
    _interstitial?.show();
  }

  void _showRewarded() {
    _rewarded?.show(OnRewardEarnedListener(onUserEarnedReward: (ad) async {
      logDebug('Rewarded ad earned reward: ${await ad.getSourceName()}');
    }));
  }
}

class ContentCallback extends ScreenAdContentCallback {
  ContentCallback(String name, void Function(AdFormat) onAdLoaded)
      : super(
          onAdLoaded: (ad) async {
            onAdLoaded(await ad.getFormat());

            logDebug('$name ad loaded: ${await ad.getSourceName()}');
          },
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

class ImpressionListener extends OnAdImpressionListener {
  ImpressionListener(String name)
      : super(
          onAdImpression: (ad) async =>
              logDebug('$name ad impression: ${await ad.getSourceName()}'),
        );
}

class BannerListener extends AdViewListener {
  final String _name;

  BannerListener(this._name);

  @override
  void onAdViewPresented() {
    logDebug('$_name banner ad presented!');
  }

  @override
  void onClicked() {
    logDebug('$_name banner ad clicked!');
  }

  @override
  void onFailed(String? message) {
    logDebug('$_name banner failed! $message');
  }

  @override
  void onImpression(AdImpression? adImpression) {
    logDebug('$_name banner impression: $adImpression');
  }

  @override
  void onLoaded() {
    logDebug('$_name banner ad loaded!');
  }
}

void logDebug(String message) {
  if (kDebugMode) {
    debugPrint('CAS.AI.Flutter.Example: $message');
  }
}
