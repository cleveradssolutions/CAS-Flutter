// ignore_for_file: public_member_api_docs

// ignore_for_file: avoid_print

import 'dart:io' show Platform;

import 'package:cas_example/native_factory_example.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:clever_ads_solutions/clever_ads_solutions.dart';

import 'adaptive_banner_example.dart';
import 'inline_banner_example.dart';
import 'native_template_example.dart';
import 'multi_banners_example.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // If you encounter any problems, simply share the `CAS.AI` debug logs with your account manager.
  if (kDebugMode) {
    CASMobileAds.setDebugLoggingEnabled(true);
  }

  // The 'demo' ID is valid for test advertising
  // but don't forget to set your registered IDs for each platform.
  CASMobileAds.initialize(
    casId: Platform.isAndroid ? 'demo' : 'demo',
    showConsentFormIfRequired: true,
    forceTestAds: kDebugMode || kProfileMode,
    testDeviceIds: [
      // You can also test in release build by registering your device as a test device.
      // Check the logs for your device's ID value.
    ],
    debugPrivacyGeography: PrivacyGeography.europeanEconomicArea,
  ).then((InitializationStatus status) {
    if (status.error != null) {
      // If an error occurs, the SDK will attempt automatic reinitialization internally.
      print('CAS Mobile Ads SDK initialization failed: ${status.error}');
    } else {
      print('CAS Mobile Ads SDK initialized in ${status.countryCode} country');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CASAppOpen _appOpenAd;
  late CASInterstitial _interstitialAd;
  late CASRewarded _rewardedAd;

  bool _isAppOpenAdLoaded = false;
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;

  @override
  void initState() {
    super.initState();

    bool useAutoReloadAds = true;
    _createAppOpenAd(useAutoReloadAds);
    _createInterstitialAd(useAutoReloadAds);
    _createRewardedAd(useAutoReloadAds);
  }

  void _createAppOpenAd(bool autoReload) {
    _appOpenAd = CASAppOpen.createAndLoad(
      autoReload: autoReload,
      autoShow: true,
      onAdLoaded: (AdScreenInstance ad) {
        print('$ad loaded');
        setState(() {
          _isAppOpenAdLoaded = true;
        });
      },
      onAdFailedToLoad: (AdInstance ad, AdError error) {
        print('$ad failed to load: ${error.message}.');
        if (autoReload) {
          // just wait for the automatic reload
        } else {
          Future.delayed(const Duration(seconds: 10), () {
            _appOpenAd.load();
          });
        }
      },
      onAdFailedToShow: (AdInstance ad, AdError error) {
        print('$ad failed to show: ${error.message}.');
        if (autoReload) {
          // just wait for the automatic reload
        } else {
          _appOpenAd.load();
        }
      },
      onAdShowed: (AdScreenInstance ad) {
        print('$ad showed');
      },
      onAdImpression: (AdInstance ad, AdContentInfo contentInfo) {
        print('$ad impression creative id: ${contentInfo.creativeId}');
      },
      onAdClicked: (AdInstance ad) {
        print('$ad clicked');
      },
      onAdDismissed: (AdScreenInstance ad) {
        print('$ad dismissed');
        if (autoReload) {
          // just wait for the automatic reload
        } else {
          _appOpenAd.load();
        }
      },
    );
  }

  /// The [CASAppOpen.onAdFailedToShow] callback will be fired if the ad
  /// is not ready to show. Or check [CASAppOpen.isLoaded].
  void _showAppOpenAd() {
    setState(() {
      _isAppOpenAdLoaded = false;
    });
    _appOpenAd.show();
  }

  void _createInterstitialAd(bool autoReload) {
    _interstitialAd = CASInterstitial.createAndLoad(
      autoReload: autoReload,
      autoShow: true,
      minInterval: 0,
      onAdLoaded: (AdScreenInstance ad) {
        print('$ad loaded');
        setState(() {
          _isInterstitialAdLoaded = true;
        });
      },
      onAdFailedToLoad: (AdInstance ad, AdError error) {
        print('$ad failed to load: ${error.message}.');
        if (autoReload) {
          // just wait for the automatic reload
        } else {
          Future.delayed(const Duration(seconds: 10), () {
            _interstitialAd.load();
          });
        }
      },
      onAdFailedToShow: (AdInstance ad, AdError error) {
        print('$ad failed to show: ${error.message}.');
        if (autoReload) {
          // just wait for the automatic reload
        } else {
          _interstitialAd.load();
        }
      },
      onAdShowed: (AdScreenInstance ad) {
        print('$ad showed');
      },
      onAdImpression: (AdInstance ad, AdContentInfo contentInfo) {
        print('$ad impression creative id: ${contentInfo.creativeId}');
      },
      onAdClicked: (AdInstance ad) {
        print('$ad clicked');
      },
      onAdDismissed: (AdScreenInstance ad) {
        print('$ad dismissed');
        if (autoReload) {
          // just wait for the automatic reload
        } else {
          _interstitialAd.load();
        }
      },
    );
  }

  /// The [CASInterstitial.onAdFailedToShow] callback will be fired if the ad
  /// is not ready to show. Or check [CASInterstitial.isLoaded].
  void _showInterstitialAd() {
    setState(() {
      _isInterstitialAdLoaded = false;
    });
    _interstitialAd.show();
  }

  void _createRewardedAd(bool autoReload) {
    _rewardedAd = CASRewarded.createAndLoad(
      autoReload: autoReload,
      onAdLoaded: (AdScreenInstance ad) {
        print('$ad loaded');
        setState(() {
          _isRewardedAdLoaded = true;
        });
      },
      onAdFailedToLoad: (AdInstance ad, AdError error) {
        print('$ad failed to load: ${error.message}.');
        if (autoReload) {
          // just wait for the automatic reload
        } else {
          ad.dispose();
          Future.delayed(const Duration(seconds: 10), () {
            _rewardedAd.load();
          });
        }
      },
      onAdFailedToShow: (AdInstance ad, AdError error) {
        print('$ad failed to show: ${error.message}.');
        if (autoReload) {
          // just wait for the automatic reload
        } else {
          _rewardedAd.load();
        }
      },
      onAdShowed: (AdScreenInstance ad) {
        print('$ad showed');
      },
      onAdImpression: (AdInstance ad, AdContentInfo contentInfo) {
        print('$ad impression creative id: ${contentInfo.creativeId}');
      },
      onAdClicked: (AdInstance ad) {
        print('$ad clicked');
      },
      onAdDismissed: (AdScreenInstance ad) {
        print('$ad dismissed');
        if (autoReload) {
          // just wait for the automatic reload
        } else {
          _rewardedAd.load();
        }
      },
    );
  }

  /// Be sure to implement [CASRewarded.onUserEarnedReward] callback
  /// and reward the user for watching an ad.
  ///
  /// The [CASRewarded.onAdFailedToShow] callback will be fired if the ad
  /// is not ready to show. Or check [CASRewarded.isLoaded].
  void _showRewardedAd() {
    setState(() {
      _isRewardedAdLoaded = false;
    });
    _rewardedAd.onUserEarnedReward = (AdScreenInstance ad) {
      print('Reward the user for watching the $ad');
    };
    _rewardedAd.show();
  }

  @override
  void dispose() {
    super.dispose();
    _appOpenAd.dispose();
    _interstitialAd.dispose();
    _rewardedAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: const Text('CAS.AI Plugin example app')),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              child: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: _isAppOpenAdLoaded ? _showAppOpenAd : null,
                    child: const Text('AppOpen Ad'),
                  ),
                  ElevatedButton(
                    onPressed:
                        _isInterstitialAdLoaded ? _showInterstitialAd : null,
                    child: const Text('Interstitial Ad'),
                  ),
                  ElevatedButton(
                    onPressed: _isRewardedAdLoaded ? _showRewardedAd : null,
                    child: const Text('Rewarded Ad'),
                  ),
                  /**
                       *   static const adaptiveBannerButtonText = 'Adaptive Banner Ad';
                          static const inlineBannerButtonText = 'Inline Banner Ad';
                          static const nativeTemplateButtonText = 'Native Ad template';
                          static const multiBannersButtonText = 'Multi Banner Ads';
                       */
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AdaptiveBannerExample()),
                      );
                    },
                    child: const Text('Adaptive Banner Ad'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InlineBannerExample()),
                      );
                    },
                    child: const Text('Inline Banner Ads'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MultiBannersWithRecycleExample()),
                      );
                    },
                    child: const Text('Multi Banner Ads'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const NativeTemplateExample()),
                      );
                    },
                    child: const Text('Native Ad template'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NativeFactoryExample()),
                      );
                    },
                    child: const Text('Native Ad factory'),
                  ),
                ],
              )),
            ),
          ),
        );
      }),
    );
  }
}
