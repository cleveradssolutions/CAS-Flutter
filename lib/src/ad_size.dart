import 'package:flutter/services.dart';

class AdSize {
  static const MethodChannel _channel =
      MethodChannel("com.cleveradssolutions.plugin.flutter/ad_size");

  final int width;
  final int height;
  final int mode;

  const AdSize._(this.width, this.height, this.mode);

  AdSize._parseMap(Map<dynamic, dynamic>? map)
      : width = map?["width"] ?? 0,
        height = map?["height"] ?? 0,
        mode = map?["mode"] ?? 0;

  /// Standard banner size 320dp width and 50dp height
  static const AdSize banner = AdSize._(320, 50, 0);

  @Deprecated("Use AdSize.banner instead")
  static const AdSize Banner = banner;

  /// Leaderboard banner size 728dp width and 90dp height
  static const AdSize leaderboard = AdSize._(728, 90, 0);

  @Deprecated("Use AdSize.leaderboard instead")
  static const AdSize Leaderboard = leaderboard;

  /// Medium Rectangle size 300dp width and 250dp height
  static const AdSize mediumRectangle = AdSize._(300, 250, 0);

  @Deprecated("Use AdSize.mediumRectangle instead")
  static const AdSize MediumRectangle = mediumRectangle;

  @Deprecated("Use AdSize.getAdaptiveBanner() instead")
  static const AdSize Adaptive = AdSize._(728, 90, 2);

  @Deprecated("Use AdSize.getSmartBanner() instead")
  static const AdSize Smart = AdSize._(320, 50, 0);

  /// Typically, Smart Banners on phones have a [BANNER] size.
  /// Or on tablets a [LEADERBOARD] size.
  static Future<AdSize> getSmartBanner() async {
    final map = await _channel.invokeMethod<Map>("getSmartBanner");
    return AdSize._parseMap(map);
  }

  /// Inline adaptive banners are larger, taller banners compared to anchored adaptive banners.
  /// They are of variable height, and can be as tall as the device screen.
  ///
  /// - The height of adaptive banners cannot be less than 32 dp.
  /// - You must know the width of the view that the ad will be placed in,
  /// and this should take into account the device width and any safe areas that are applicable.
  /// - The inline adaptive banner sizes are designed to work best when using the full available width.
  /// In most cases, this will be the full width of the screen of the device in use.
  /// Be sure to take into account applicable safe areas.
  static Future<AdSize> getInlineBanner(int width, int maxHeight) async {
    final map = await _channel.invokeMethod<Map>(
        "getInlineBanner", {"width": width, "maxHeight": maxHeight});
    return AdSize._parseMap(map);
  }

  /// Create Adaptive AdSize with Max Width dp for current screen orientation.
  /// - The height of adaptive banners cannot be less than 50 dp and more than 250 dp.
  /// - The width of adaptive banners cannot be less than 300 dp.
  /// - The adaptive banners use fixed aspect ratios instead of fixed heights.
  static Future<AdSize> getAdaptiveBanner(int maxWidthDp) async {
    final map = await _channel
        .invokeMethod<Map>("getAdaptiveBanner", {"maxWidthDp": maxWidthDp});
    return AdSize._parseMap(map);
  }

  /// Create Adaptive AdSize with screen width for current screen orientation.
  /// - The height of adaptive banners cannot be less than 50 dp and more than 250 dp.
  /// - The width of adaptive banners cannot be less than 300 dp.
  /// - The adaptive banners use fixed aspect ratios instead of fixed heights.
  static Future<AdSize> getAdaptiveBannerInScreen() async {
    final map = await _channel.invokeMethod<Map>("getAdaptiveBannerInScreen");
    return AdSize._parseMap(map);
  }
}
