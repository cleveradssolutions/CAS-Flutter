import 'package:flutter/material.dart';

import 'internal/ad_size_impl.dart';

abstract class AdSize {
  /// Standard banner size 320dp width and 50dp height
  static const AdSize banner = AdSizeImpl(320, 50);

  @Deprecated("Use AdSize.banner instead")
  static const AdSize Banner = banner;

  /// Leaderboard banner size 728dp width and 90dp height
  static const AdSize leaderboard = AdSizeImpl(728, 90);

  @Deprecated("Use AdSize.leaderboard instead")
  static const AdSize Leaderboard = leaderboard;

  /// Medium Rectangle size 300dp width and 250dp height
  static const AdSize mediumRectangle = AdSizeImpl(300, 250);

  @Deprecated("Use AdSize.mediumRectangle instead")
  static const AdSize MediumRectangle = mediumRectangle;

  @Deprecated("Use AdSize.getAdaptiveBanner() instead")
  static const AdSize Adaptive = AdSizeImpl(728, 90, 2);

  @Deprecated("Use AdSize.getSmartBanner() instead")
  static const AdSize Smart = AdSizeImpl(320, 50);

  int get width;

  int get height;

  bool get isAdaptive;

  bool get isInline;

  /// Typically, Smart Banners on phones have a [BANNER] size.
  /// Or on tablets a [LEADERBOARD] size.
  factory AdSize.getSmartBanner(BuildContext context) =>
      AdSizeFactory.getSmartBanner(context);

  /// Inline adaptive banners are larger, taller banners compared to anchored adaptive banners.
  /// They are of variable height, and can be as tall as the device screen.
  ///
  /// - The height of adaptive banners cannot be less than 32 dp.
  /// - You must know the width of the view that the ad will be placed in,
  /// and this should take into account the device width and any safe areas that are applicable.
  /// - The inline adaptive banner sizes are designed to work best when using the full available width.
  /// In most cases, this will be the full width of the screen of the device in use.
  /// Be sure to take into account applicable safe areas.
  factory AdSize.getInlineBanner(int width, int maxHeight) =>
      AdSizeFactory.getInlineBanner(width, maxHeight);

  /// Create Adaptive AdSize with Max Width dp for current screen orientation.
  /// - The height of adaptive banners cannot be less than 50 dp and more than 250 dp.
  /// - The width of adaptive banners cannot be less than 300 dp.
  /// - The adaptive banners use fixed aspect ratios instead of fixed heights.
  factory AdSize.getAdaptiveBanner(int maxWidthDp) =>
      AdSizeFactory.getAdaptiveBanner(maxWidthDp);

  /// Create Adaptive AdSize with screen width for current screen orientation.
  /// - The height of adaptive banners cannot be less than 50 dp and more than 250 dp.
  /// - The width of adaptive banners cannot be less than 300 dp.
  /// - The adaptive banners use fixed aspect ratios instead of fixed heights.
  factory AdSize.getAdaptiveBannerInScreen() =>
      AdSizeFactory.getAdaptiveBannerInScreen();
}
