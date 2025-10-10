// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:clever_ads_solutions/clever_ads_solutions.dart';
import 'package:flutter/material.dart';

/// This example demonstrates inline banners ads in a list view, where banners
/// are recycle to improve performance.
class MultiBannersWithRecycleExample extends StatefulWidget {
  const MultiBannersWithRecycleExample({super.key});

  @override
  State<MultiBannersWithRecycleExample> createState() =>
      _MultiBannersWithRecycleExampleState();
}

class _MultiBannersWithRecycleExampleState
    extends State<MultiBannersWithRecycleExample> {
  // The maximum number of banners to create.
  static const int _cacheSize = 10;

  // Show a banner every 3 rows (i.e. row index 3, 6, 9 etc) will be banner rows.
  static const int _adInterval = 3;

  // The number of banner ads to preload ahead of time before they are shown.
  static const int _preloadAdCount = 2;

  // The height of row in list view.
  static const double _rowHeight = 350;

  // A list of all the banners created.
  final List<CASBanner?> _banners = [];

  // Keep track of the positions of banners.
  final Map<CASBanner, int> _bannerPositions = {};

  void _createBannerAd(int bannerIndex) {
    CASBanner.createAndLoad(
      size: AdSize.getInlineBanner(360, _rowHeight.truncate()),
      // disable autoload ad
      autoReload: false,
      // Use auto refresh ad, or set 0 to disable
      refreshInterval: 30,
      onAdLoaded: (AdViewInstance ad) {
        // Mark need build to replace placeholder to CASWidget
        // with loaded banner ad.
        setState(() {
          _banners[bannerIndex] = ad as CASBanner;
        });
      },
      onAdFailedToLoad: (AdInstance ad, AdError error) {
        // Save the created banner for reloading later
        final bannerAd = ad as CASBanner;
        _banners[bannerIndex] = bannerAd;
      },
      onAdImpression: (AdInstance ad, AdContentInfo contentInfo) {
        print('Banner ad impression occurred.');
      },
    );
  }

  CASBanner? _getBannerAdForPosition(int position) {
    // Reusing banners if position exceeds _cacheSize.
    int bannerIndex = position % _cacheSize;

    // Preload banners if they haven’t been created yet,
    // up to the desired preload count.
    int preloadCount = min(bannerIndex + 1 + _preloadAdCount, _cacheSize);
    for (int index = _banners.length; index < preloadCount; index++) {
      // Reserve a slot in the list for a future banner.
      _banners.add(null);

      // Create and load the banner at the given index.
      _createBannerAd(index);
    }

    // If a banner is already placed in the current position, just reuse it.
    for (var element in _bannerPositions.entries) {
      if (element.value == position) {
        return element.key;
      }
    }

    CASBanner? bannerAd = _banners[bannerIndex];
    if (bannerAd == null) {
      // if ad is null then still loading.
      return null;
    }
    if (bannerAd.isLoaded() == false) {
      // if it's failed previously,
      // remove from list and reload it in same AdInstance.
      _banners[bannerIndex] = null;
      unawaited(bannerAd.load());
      return null;
    }
    if (bannerAd.isMounted) {
      // This should be a corner case indicating _adInterval should be increased.
      print("Warning! You should increase the banner ad Interval in ListView.");
      return null;
    }
    _bannerPositions[bannerAd] = position;
    return bannerAd;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi Inline Banners')),
      body: SafeArea(
        child: ListView.builder(
            // Arbitrary example of 100 items in the list.
            itemCount: 100,
            itemBuilder: (BuildContext context, int index) {
              // if Banner Ad position
              if ((index + 1) % _adInterval == 0) {
                int adPosition = (index) ~/ _adInterval;
                CASBanner? bannerAd = _getBannerAdForPosition(adPosition);
                if (bannerAd == null) {
                  // Null banner ad means the banner's content is not loaded yet.
                  // Return placeholder.
                  return Container(
                    height: _rowHeight,
                    color: Colors.blueGrey,
                    alignment: Alignment.center,
                    child: const Text("Loading Ad..."),
                  );
                }
                // Now this banner is loaded.
                return CASWidget(ad: bannerAd);
              }

              // Show your regular non-ad content.
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                ),
                child: const SizedBox(
                  height: _rowHeight,
                  child: ColoredBox(color: Colors.greenAccent),
                ),
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    for (final banner in _banners) {
      banner?.dispose();
    }
    super.dispose();
  }
}
