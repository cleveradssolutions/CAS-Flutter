// ignore_for_file: public_member_api_docs

// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:clever_ads_solutions/clever_ads_solutions.dart';

/// This example demonstrates adaptive banner ads.
///
/// Loads an adaptive banner ad and displays it at the bottom of the screen.
/// This also handles loading a new ad on orientation change.
class AdaptiveBannerExample extends StatefulWidget {
  const AdaptiveBannerExample({super.key});

  @override
  State<AdaptiveBannerExample> createState() => _AdaptiveBannerExampleState();
}

class _AdaptiveBannerExampleState extends State<AdaptiveBannerExample> {
  static const bool _useAutoReloadAd = true;

  CASBanner? _adaptiveBannerAd;
  Orientation? _currentOrientation;

  void _loadAd(double maxWidth) {
    // Disposing of the current ad if there is one.
    _adaptiveBannerAd?.dispose();

    _adaptiveBannerAd = CASBanner.createAndLoad(
      size: AdSize.getAdaptiveBanner(maxWidth),
      autoReload: _useAutoReloadAd,
      refreshInterval: 30,
      onAdLoaded: (AdViewInstance ad) {
        print('$ad loaded');
        // CASWidget will automatically populate with an ad
        // without any additional changes to the state.
      },
      onAdFailedToLoad: (AdInstance ad, AdError error) {
        print('$ad failed to load: $error');
        if (_useAutoReloadAd) {
          // just wait for the automatic reload
        } else {
          Future.delayed(const Duration(seconds: 10), () {
            // You may reuse the same ad instance as long as the size
            // has not changed.
            if (_adaptiveBannerAd == ad) {
              _adaptiveBannerAd!.load();
            }
          });
        }
      },
      onAdImpression: (AdInstance ad, AdContentInfo contentInfo) {
        print('$ad impression creative id: ${contentInfo.creativeId}');
      },
      onAdClicked: (AdInstance ad) {
        print('$ad clicked');
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    MediaQueryData mediaQuery = MediaQuery.of(context);

    // didChangeDependencies will also be called during initState()
    // when the orientation is null.
    if (_currentOrientation != mediaQuery.orientation) {
      _currentOrientation = mediaQuery.orientation;

      // Reload the ad if the orientation changes.
      _loadAd(mediaQuery.size.width);
    }
  }

  Widget _getAdWidget() {
    // The widget size matches the loaded ad content.
    // If the ad is not loaded yet, the widget defaults to 1x1 size.
    return CASWidget(ad: _adaptiveBannerAd!);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Adaptive banner example'),
        ),
        body: SafeArea(
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemBuilder: (context, index) {
                    return const Text(
                      'Below you can see an adaptive banner ad.',
                      style: TextStyle(fontSize: 24),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(height: 40);
                  },
                  itemCount: 5),
              _getAdWidget(),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();
    _adaptiveBannerAd?.dispose();
  }
}
