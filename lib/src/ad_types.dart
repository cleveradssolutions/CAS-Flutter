class AdTypeFlags {
  static const int none = 0;
  static const int banner = 1;
  static const int interstitial = 1 << 1;
  static const int rewarded = 1 << 2;
  // static const int native = 1 << 3;
  static const int appOpen = 1 << 6;

  @Deprecated("Use AdTypeFlags.banner instead")
  static const int Banner = banner;
  @Deprecated("Use AdTypeFlags.interstitial instead")
  static const int Interstitial = interstitial;
  @Deprecated("Use AdTypeFlags.rewarded instead")
  static const int Rewarded = rewarded;
}
