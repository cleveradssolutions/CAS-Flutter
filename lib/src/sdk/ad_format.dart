/// This class defines a format of an ad.
enum AdFormat {
  banner("Banner"),
  interstitial("Interstitial"),
  rewarded("Rewarded"),
  appOpen("AppOpen"),
  native("Native"),
  mediumRectangle("MREC"),
  inlineBanner("InlineBanner");

  /// Human-readable representation of the format.
  final String label;

  const AdFormat(this.label);

  /// Checks if the format is an AdView.
  bool get isAdView =>
      this == banner || this == inlineBanner || this == mediumRectangle;

  @override
  String toString() => label;
}
