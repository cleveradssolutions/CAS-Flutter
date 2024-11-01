import 'package:clever_ads_solutions/clever_ads_solutions.dart';
import 'package:flutter/material.dart';

import 'log.dart';
import 'main.dart';

void main() {
  final appOpenAd = CASAppOpen.create("demo");
  appOpenAd.contentCallback = AppOpenAdListener();
  appOpenAd.loadAd(AppOpenAdLoadListener());
  runApp(const SplashScreen());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoadingAppResources = false;
  bool _isVisibleAppOpenAd = false;
  bool _isCompletedSplash = false;

  @override
  void initState() {
    super.initState();
    _simulationLongAppResourcesLoading();
    _createAppOpenAd();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CAS.AI Sample'),
        ),
        backgroundColor: const Color(0x001a283e),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon.png',
                height: 150,
                width: double.infinity,
              ),
              const SizedBox(height: 16),
              const Text(
                'AppOpenAd loading is carried out before the application resources are ready.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _openNextScreen();
                },
                child: const Text(
                  'Skip AppOpenAd',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _openNextScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyApp()),
    );
  }
}

class AppOpenAdLoadListener extends AdLoadCallback {
  @override
  void onAdLoaded() {
    logDebug("App Open Ad loaded");
    if (isLoadingAppResources) {
      isVisibleAppOpenAd = true;
      appOpenAd.show(SampleAppOpenAdActivity.this);
    }

    _openNextScreen();
  }

  @override
  void onAdFailedToLoad(AdError adError) {
    logDebug("App Open Ad failed to load: " + adError.getMessage());

    _openNextScreen();
  }
}

class AppOpenAdListener extends AdCallback {
  @override
  void onShown(AdStatusHandler adStatusHandler) {
    logDebug("App Open Ad shown");
  }

  @override
  void onShowFailed(String message) {
    logDebug("App Open Ad show failed: " + message);

    isVisibleAppOpenAd = false;
    _openNextScreen();
  }

  @override
  void onClosed() {
    logDebug("App Open Ad closed");

    isVisibleAppOpenAd = false;
    _openNextScreen();
  }
}
