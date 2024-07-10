import 'package:clever_ads_solutions/public/AdType.dart';
import 'package:clever_ads_solutions/public/PriceAccuracy.dart';

class AdImpression {
  AdType adType;
  double cpm;
  String network;
  PriceAccuracy priceAccuracy;
  String versionInfo;
  String? creativeIdentifier;
  String identifier;
  int impressionDepth;
  double lifeTimeRevenue;

  AdImpression(
      int adType,
      double cpm,
      String network,
      int priceAccuracy,
      String versionInfo,
      String? creativeIdentifier,
      String identifier,
      int impressionDepth,
      double lifeTimeRevenue)
      : this.adType = AdType.values[adType],
        this.cpm = cpm,
        this.network = network,
        this.priceAccuracy = PriceAccuracy.values[priceAccuracy],
        this.versionInfo = versionInfo,
        this.creativeIdentifier = creativeIdentifier,
        this.identifier = identifier,
        this.impressionDepth = impressionDepth,
        this.lifeTimeRevenue = lifeTimeRevenue;
}
