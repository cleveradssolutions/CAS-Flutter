import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../ad_size.dart';
import 'log.dart';
import 'utils.dart';

extension AdSizeFactory on AdSize {
  static const MethodChannel _channel =
      MethodChannel("cleveradssolutions/ad_size");

  static AdSize getSmartBanner(BuildContext context) {
    return context.isTablet ? AdSize.leaderboard : AdSize.banner;
  }

  static AdSize getInlineBanner(int width, int maxHeight) {
    if (maxHeight < 32) {
      logDebug(
          'The maximum height set for the inline adaptive ad size was $maxHeight dp, which is below the minimum recommended value of 32 dp.');
    }
    if (width < 300) {
      logDebug(
          'The width set for the inline adaptive ad size was $width dp, with is below the minimum supported value of 300dp.');
      return const AdSizeImpl(0, 0, 0);
    }
    return AdSizeImpl(width, maxHeight, 3);
  }

  static AdSize getAdaptiveBanner(int maxWidthDp) {
    return FutureAdSize(_channel.invokeMethod<Map>("getAdaptiveBanner",
        {"maxWidthDp": maxWidthDp}).then(AdSizeImpl._parseMap));
  }

  static AdSize getAdaptiveBannerInScreen() {
    return FutureAdSize(_channel
        .invokeMethod<Map>("getAdaptiveBannerInScreen")
        .then(AdSizeImpl._parseMap));
  }
}

mixin AdSizeBase implements AdSize {
  int get mode;

  @override
  bool get isAdaptive => mode == 2;

  @override
  bool get isInline => mode == 3;

  @override
  bool operator ==(Object other) =>
      other is AdSize && other.width == width && other.height == height;

  @override
  String toString() => '($width, $height)';

  @override
  int get hashCode => 31 * width + height;
}

class AdSizeImpl with AdSizeBase {
  @override
  final int width;
  @override
  final int height;
  @override
  final int mode;

  const AdSizeImpl(this.width, this.height, [this.mode = 0]);

  AdSizeImpl._parseMap(Map<dynamic, dynamic>? map)
      : width = map?["width"] ?? 0,
        height = map?["height"] ?? 0,
        mode = map?["mode"] ?? 0;
}

class FutureAdSize with AdSizeBase {
  final Future<AdSizeImpl> future;

  @override
  int width = 0;
  @override
  int height = 0;
  @override
  int mode = 0;

  FutureAdSize(this.future) {
    future.then((adSize) {
      width = adSize.width;
      height = adSize.height;
      mode = adSize.mode;
    });
  }
}
