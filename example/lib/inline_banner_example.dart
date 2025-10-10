// ignore_for_file: public_member_api_docs

// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:clever_ads_solutions/clever_ads_solutions.dart';

/// This example demonstrates inline banner ads.
///
/// Loads an inline banner ad and displays it in a scrolling view.
/// This also handles loading a new ad on orientation change.
class InlineBannerExample extends StatefulWidget {
  const InlineBannerExample({super.key});

  @override
  State<InlineBannerExample> createState() => _InlineBannerExampleState();
}

class _InlineBannerExampleState extends State<InlineBannerExample> {
  static const _insets = 16.0;
  static const _maxHeight = 300;
  static const _useAutoReloadAd = true;

  CASBanner? _inlineBannerAd;
  Orientation? _currentOrientation;

  void _loadAd(int adWidth) {
    // Disposing of the current ad if there is one.
    _inlineBannerAd?.dispose();

    _inlineBannerAd = CASBanner.createAndLoad(
      size: AdSize.getInlineBanner(adWidth, _maxHeight),
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
            if (_inlineBannerAd == ad) {
              _inlineBannerAd!.load();
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
      double adWidth = MediaQuery.of(context).size.width - (2 * _insets);
      _loadAd(adWidth.truncate());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _inlineBannerAd?.dispose();
  }

  Widget _getAdWidget() {
    // The widget size matches the loaded ad content.
    // If the ad is not loaded yet, the widget defaults to 1x1 size.
    return CASWidget(ad: _inlineBannerAd!);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Inline banner example'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _insets),
          child: ListView.separated(
            itemCount: 3,
            separatorBuilder: (BuildContext context, int index) {
              return Container(height: 40);
            },
            itemBuilder: (BuildContext context, int index) {
              if (index == 1) {
                return _getAdWidget();
              }
              return const Text(
                'In the ListView you can see an inline banner ad.',
                style: TextStyle(fontSize: 24),
              );
            },
          ),
        ),
      ));
}
