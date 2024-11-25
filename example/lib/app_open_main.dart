import 'dart:async';

import 'package:clever_ads_solutions/clever_ads_solutions.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'log.dart';

const _casId = "demo";

void main() {
  runApp(const AppWithSplashScreen());
}

class AppWithSplashScreen extends StatelessWidget {
  const AppWithSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
      },
    );
  }
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _simulationLongAppResourcesLoading();
      _createAppOpenAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              'assets/icon.webp',
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
                _isLoadingAppResources = false;
                _openNextScreen();
              },
              child: const Text('Skip AppOpenAd'),
            ),
          ],
        ),
      ),
    );
  }

  void _createAppOpenAd() {
    // Create an Ad
    final appOpenAd = CASAppOpen.create(_casId);

    // Handle fullscreen callback events
    appOpenAd.contentCallback = AppOpenAdListener(
      onShown: () => logDebug("App open ad shown"),
      onImpression: (adImpression) =>
          logDebug("App open ad did impression: $adImpression!"),
      onShowFailed: (message) {
        logDebug("App open ad show failed: $message");

        _isVisibleAppOpenAd = false;
        _openNextScreen();
      },
      onClosed: () {
        logDebug("App open ad closed");

        _isVisibleAppOpenAd = false;
        _openNextScreen();
      },
    );

    // Load the Ad
    appOpenAd.loadAd(LoadAdCallback(onAdLoaded: () {
      logDebug("App Open Ad loaded");
      if (_isLoadingAppResources) {
        _isVisibleAppOpenAd = true;
        appOpenAd.show();
      }
    }, onAdFailedToLoad: (adError) {
      logDebug("App Open Ad failed to load: ${adError.message}");
      _openNextScreen();
    }));
  }

  void _openNextScreen() {
    if (_isLoadingAppResources || _isVisibleAppOpenAd || _isCompletedSplash) {
      return;
    }
    _isCompletedSplash = true;

    Navigator.pushReplacementNamed(context, '/home');
  }

  Future<void> _simulationLongAppResourcesLoading() async {
    _isLoadingAppResources = true;
    // Simulation of long application resources loading for 5 seconds.
    await Future.delayed(const Duration(seconds: 15));
    setState(() {
      _isLoadingAppResources = false;
      _openNextScreen();
    });
  }
}
