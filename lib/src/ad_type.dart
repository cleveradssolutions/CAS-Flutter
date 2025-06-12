enum AdType {
  // ignore: constant_identifier_names
  Banner,
  // ignore: constant_identifier_names
  Interstitial,
  // ignore: constant_identifier_names
  Rewarded;

  static AdType get(int index) {
    const adTypes = AdType.values;
    if (index >= 0 && index < adTypes.length) {
      return adTypes[index];
    } else {
      return AdType.Banner;
    }
  }
}
