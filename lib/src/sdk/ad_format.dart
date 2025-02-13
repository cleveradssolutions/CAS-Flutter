/// This class defines a format of an ad.
enum AdFormat {
  appOpen(AdFormatId.APP_OPEN, "AppOpen", "appopen", AdTypeFlags.AppOpen),
  banner(AdFormatId.BANNER, "Banner", "banner", AdTypeFlags.Banner),
  inlineBanner(
      AdFormatId.INLINE_BANNER, "InlineBanner", "banner", AdTypeFlags.Banner),
  mediumRectangle(AdFormatId.MREC, "MREC", "banner", AdTypeFlags.Banner),
  interstitial(AdFormatId.INTERSTITIAL, "Interstitial", "inter",
      AdTypeFlags.Interstitial),
  rewarded(AdFormatId.REWARDED, "Rewarded", "reward", AdTypeFlags.Rewarded),
  native(AdFormatId.NATIVE, "Native", "native", AdTypeFlags.Native);

  /// Simple unique numeric representation of the format.
  final int value;

  /// Human-readable representation of the format.
  final String label;

  /// Field name in configuration for the format.
  /// For example:
  /// ```
  /// val parameterKey = AdFormat.APP_OPEN.field + "_id"
  /// ```
  final String field;

  /// Bit flag of the format.
  final int bit;

  const AdFormat(this.value, this.label, this.field, this.bit);

  /// Checks if the format is an AdView.
  bool get isAdView => bit == AdTypeFlags.Banner;

  @override
  String toString() => label;
}
