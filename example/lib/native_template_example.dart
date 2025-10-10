// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:clever_ads_solutions/clever_ads_solutions.dart';

/// This example demonstrates native templates.
class NativeTemplateExample extends StatefulWidget {
  const NativeTemplateExample({super.key});

  @override
  State<NativeTemplateExample> createState() => _NativeTemplateExampleState();
}

class _NativeTemplateExampleState extends State<NativeTemplateExample> {
  // The height of row in list view.
  static const double _rowHeight = 300;

  AdViewInstance? _nativeAd;

  void _loadAd() {
    CASNativeContent.load(
      adChoicesPlacement: AdChoicesPlacement.topRightCorner,
      startVideoMuted: true,
      templateStyle: NativeTemplateStyle(
        backgroundColor: Colors.white,
        primaryColor: Colors.blueAccent,
        primaryTextColor: null,
        headlineTextColor: null,
        headlineFontStyle: NativeTemplateFontStyle.bold,
        secondaryTextColor: null,
        secondaryFontStyle: null,
      ),
      onAdLoaded: (AdViewInstance ad) {
        print('$ad loaded');
        setState(() {
          _nativeAd = ad;
        });
      },
      onAdFailedToLoad: (AdInstance ad, AdError error) {
        print('$ad failed to load: $error');
        ad.dispose();
      },
      onAdImpression: (AdInstance ad, AdContentInfo contentInfo) async {
        print('$ad impression creative id: ${contentInfo.creativeId}');
      },
      onAdClicked: (AdInstance ad) {
        print('$ad clicked');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Native ad templates example'),
        ),
        body: SafeArea(
          child: ListView.separated(
            itemCount: 10,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 40,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              if (index == 3) {
                if (_nativeAd == null) {
                  return const SizedBox(
                    height: _rowHeight,
                    child: Center(
                        child: Text(
                      "Ad Loading...",
                      style: TextStyle(fontSize: 24),
                    )),
                  );
                }
                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // CAS will build a default template view based on the size
                    // you specify for the CASWidget.
                    double availableWidth = constraints.maxWidth;
                    return CASWidget(
                      ad: _nativeAd!,
                      width: availableWidth,
                      height: _rowHeight,
                    );
                  },
                );
              }
              return const SizedBox(
                height: _rowHeight,
                child: Center(
                    child: Text(
                  "Scroll to see the native ad template",
                  style: TextStyle(fontSize: 24),
                )),
              );
            },
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();
    _nativeAd?.dispose();
    _nativeAd = null;
  }
}
