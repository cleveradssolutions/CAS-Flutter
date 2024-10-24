import 'ad_type.dart';
import 'price_accuracy.dart';

class AdImpression {
  AdType adType;
  double cpm;
  String network;
  PriceAccuracy priceAccuracy;
  String versionInfo;
  String? creativeIdentifier;
  String identifier;
  int impressionDepth;
  double lifetimeRevenue;

  AdImpression(
      int adType,
      this.cpm,
      this.network,
      int priceAccuracy,
      this.versionInfo,
      this.creativeIdentifier,
      this.identifier,
      this.impressionDepth,
      this.lifetimeRevenue)
      : adType = AdType.values[adType],
        priceAccuracy = PriceAccuracy.values[priceAccuracy];
}
