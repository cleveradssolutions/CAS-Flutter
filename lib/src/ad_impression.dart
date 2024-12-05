import 'package:flutter/services.dart';

import 'ad_type.dart';
import 'price_accuracy.dart';

class AdImpression {
  final AdType adType;
  final double cpm;
  final String network;
  final PriceAccuracy priceAccuracy;
  final String versionInfo;
  final String? creativeIdentifier;
  final String identifier;
  final int impressionDepth;
  final double lifetimeRevenue;

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
      : adType = AdType.get(adType),
        priceAccuracy = PriceAccuracy.get(priceAccuracy);

  @override
  String toString() {
    return 'AdImpression('
        'adType: $adType, '
        'cpm: $cpm, '
        'network: $network, '
        'priceAccuracy: $priceAccuracy, '
        'versionInfo: $versionInfo, '
        'creativeIdentifier: $creativeIdentifier, '
        'identifier: $identifier, '
        'impressionDepth: $impressionDepth, '
        'lifetimeRevenue: $lifetimeRevenue)';
  }

  static AdImpression? tryParse(MethodCall call) {
    final arguments = call.arguments as Map<dynamic, dynamic>?;

    if (arguments != null) {
      return AdImpression(
        arguments["adType"] as int,
        arguments["cpm"] as double? ?? 0,
        arguments["networkName"] as String? ?? '',
        arguments["priceAccuracy"] as int? ?? 0,
        arguments["versionInfo"] as String? ?? '',
        arguments["creativeIdentifier"] as String?,
        arguments["identifier"] as String? ?? '',
        arguments["impressionDepth"] as int? ?? 0,
        arguments["lifetimeRevenue"] as double? ?? 0,
      );
    }

    return null;
  }
}
