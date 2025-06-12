enum PriceAccuracy {
  // ignore: constant_identifier_names
  FLOOR,
  // ignore: constant_identifier_names
  BID,
  // ignore: constant_identifier_names
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
