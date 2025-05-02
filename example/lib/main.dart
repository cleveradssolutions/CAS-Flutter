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
                  LayoutBuilder(builder: (_, BoxConstraints constraints) {
                    return BannerWidget(
                      key: _bannerKey,
                      casId: _casId,
                      size: AdSize.getAdaptiveBanner(constraints.maxWidth),
                      listener: BannerListener(),
                    );
                  }),
                  ElevatedButton(
                    child: const Text('Load next ad on upper widget'),
                    onPressed: () => _bannerKey.currentState?.load(),
                  ),
                  ElevatedButton(
                    onPressed: _isInterstitialReady ? _showInterstitial : null,
                    child: const Text('Show interstitial'),
                  ),
                  ElevatedButton(
                    onPressed: _isRewardedReady ? _showRewarded : null,
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

  void _initialize() {
    // Set Ads Settings
    CAS.settings.setDebugMode(true);
    CAS.settings.setTaggedAudience(Audience.notChildren);

    // Set Manual loading mode to disable auto requests
    // CAS.settings.setLoadingMode(LoadingManagerMode.manual);

    // Initialize SDK
    CAS
        .buildManager()
        .withCasId(_casId)
        .withTestMode(true)
        .withConsentFlow(ConsentFlow.create()
            .withDismissListener(this)
            .withPrivacyPolicy('https://example.com/'))
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
  BannerListener();

  @override
  void onAdViewPresented() {
    logDebug('Banner ad presented!');
  }

  @override
  void onClicked() {
    logDebug('Banner ad clicked!');
  }

  @override
  void onFailed(String? message) {
    logDebug('Banner failed! $message');
  }

  @override
  void onImpression(AdImpression? adImpression) {
    logDebug('Banner impression: $adImpression');
  }

  @override
  void onLoaded() {
    logDebug('Banner ad loaded!');
  }
}

void logDebug(String message) {
  if (kDebugMode) {
    debugPrint('CAS.AI.Flutter.Example: $message');
  }
}
