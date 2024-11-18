enum AdType {
  Banner,
  Interstitial,
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
