import 'package:flutter/material.dart';

/// [AdSize] represents the size of a banner ad.
class AdSize {
  /// Constructs an [AdSize] with the given [width] and [height].
  const AdSize._({required this.width, required this.height}) : _mode = 0;

  /// The vertical span of an ad.
  final int width;

  /// The horizontal span of an ad.
  final int height;

  /// The ad size mode.
  final int _mode;

  /// Is true for AdSize created by [AdSize.getAdaptiveBanner].
  bool get isAdaptive => _mode == 2;

  /// Is true for AdSize created by [AdSize.getInlineBanner].
  bool get isInline => _mode == 3;

  /// Standard banner has a fixed size of 320x50 and is the minimum ad size.
  static const AdSize banner = AdSize._(width: 320, height: 50);

  /// Leaderboard has a fixed size of 728x90 and is allowed on tablets only.
  static const AdSize leaderboard = AdSize._(width: 728, height: 90);

  /// Medium rectangle has a fixed size of 300x250.
  static const AdSize mediumRectangle = AdSize._(width: 300, height: 250);

  /// Adaptive banner ads have a fixed aspect ratio for the maximum width.
  /// The adaptive size calculates the optimal height for that width with an
  /// aspect ratio similar to 320x50.
  ///
  /// Width of the current device can be found using:
  ///  `MediaQuery.of(context).size.width`.
  ///
  /// Be sure to take into account applicable safe areas.
  AdSize.getAdaptiveBanner(double maxWidth)
      : width = maxWidth.truncate(),
        height = 0,
        _mode = 2;

  /// Inline banner ads have a desired width and a maximum height, useful when
  /// you want to limit the banner's height. Inline banners are larger and
  /// taller compared to adaptive banners. They have variable height, including
  /// Medium Rectangle size, and can be as tall as the device screen.
  ///
  /// Width of the current device can be found using:
  ///  `MediaQuery.of(context).size.width.truncate()`.
  /// Be sure to take into account applicable safe areas.
  AdSize.getInlineBanner(this.width, int maxHeight)
      : height = maxHeight,
        _mode = 3 {
    if (width < 300 || maxHeight < 32) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('Invalid Inline Ad Size ($width x $maxHeight)'),
        ErrorHint(
            'The minimum supported values for Inline Ad Size is (300 x 32).'),
      ]);
    }
  }

  /// Smart ad size selects the optimal dimensions depending on the device type.
  /// For mobile devices, it returns 320x50, while for tablets, it returns 728x90.
  /// In the UI, these banners occupy the same amount of space regardless of device type.
  factory AdSize.getSmartBanner(BuildContext context) {
    final isTablet = (MediaQuery.of(context).size.shortestSide > 720.0);
    return isTablet ? AdSize.leaderboard : AdSize.banner;
  }

  /// Create Adaptive AdSize with screen width for current screen orientation.
  @Deprecated(
      "Use getAdaptiveBanner(maxWidthDp) with screen width by `MediaQuery.of(context).size.width` instead.")
  AdSize.getAdaptiveBannerInScreen()
      : width = 0,
        height = 0,
        _mode = 2;

  @override
  bool operator ==(Object other) =>
      other is AdSize && other.width == width && other.height == height;

  @override
  String toString() => '($width, $height)';

  @override
  int get hashCode => Object.hash(width, height);
}
