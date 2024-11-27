enum PriceAccuracy {
  FLOOR,
  BID,
  UNDISCLOSED;

  static PriceAccuracy get(int index) {
    const priceAccuracies = PriceAccuracy.values;
    if (index >= 0 && index < priceAccuracies.length) {
      return priceAccuracies[index];
    } else {
      return PriceAccuracy.UNDISCLOSED;
    }
  }
}
