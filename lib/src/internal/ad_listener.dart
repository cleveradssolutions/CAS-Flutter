import 'package:flutter/services.dart';

import '../ad_impression.dart';

abstract class AdListener {
  AdImpression? tryGetAdImpression(MethodCall call) {
    if ((call.arguments as Object?) != null) {
      AdImpression adImpression = AdImpression(
          call.arguments["adType"],
          call.arguments["cpm"],
          call.arguments["networkName"],
          call.arguments["priceAccuracy"],
          call.arguments["versionInfo"],
          call.arguments["creativeIdentifier"],
          call.arguments["identifier"],
          call.arguments["impressionDepth"],
          call.arguments["lifetimeRevenue"]);
      return adImpression;
    } else {
      return null;
    }
  }
}
