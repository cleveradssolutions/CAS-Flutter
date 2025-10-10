// ignore_for_file: public_member_api_docs

part of 'ad_instances.dart';

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

/// Defines the precision levels for ad revenue calculations.
/// These levels indicate the accuracy or source of the revenue data provided by the system.
enum AdRevenuePrecision {
  /// Indicates that the revenue precision is unknown.
  /// This occurs when there is insufficient data available for CAS to calculate a revenue value.
  /// In such cases, CAS returns $0 in revenue.
  unknown,

  /// Indicates that the revenue value is provided as part of a real-time auction.
  /// This value represents the most accurate revenue figure available at the time.
  precise,

  /// Indicates that the revenue is based on the manual CPM (Cost Per Mille) value entered
  /// for the waterfall ad network instance in mediation.
  ///
  /// Note: Actual ad revenue is expected to be 10-20% higher than this minimum (floor) value.
  floor,

  /// Indicates that the revenue calculation is based on historical performance data
  /// as analyzed by the CAS platform.
  ///
  /// Note: Estimated ad revenue may have discrepancies of up to 10% compared to actual values.
  estimated;
}

/// Contains information about the loaded ad.
class AdContentInfo {
  /// Constructs a [AdContentInfo]
  @protected
  AdContentInfo({
    required AdFormat format,
    required this.sourceName,
    required this.sourceUnitId,
    required this.creativeId,
    required this.revenue,
    required this.revenuePrecision,
    required this.revenueTotal,
    required this.impressionDepth,
  }) : _format = format;

  final AdFormat _format;

  /// The display name of the mediated network that purchased the impression.
  final String sourceName;

  /// The Ad Unit ID from the mediated network that purchased the impression.
  final String sourceUnitId;

  /// The Creative ID associated with the ad, or null if not available.
  ///
  /// You can use this ID to report creative issues to the Ad review team.
  final String? creativeId;

  /// The revenue generated from the impression, in USD.
  ///
  /// The revenue value may be either estimated or exact,
  /// depending on the precision specified by [revenuePrecision].
  final double revenue;

  /// The precision type of the revenue field.
  final AdRevenuePrecision revenuePrecision;

  /// The accumulated value of user ad revenue in USD from all ad format impressions.
  final double revenueTotal;

  /// The total number of impressions across all ad formats for the current user,
  /// across all sessions.
  final int impressionDepth;

  /// Gets the display name of the mediated network that purchased the impression.
  @Deprecated("Use the not future property with the same name instead.")
  Future<String> getSourceName() {
    return Future.value(sourceName);
  }

  /// Gets the Ad Unit ID from the mediated network that purchased the impression.
  @Deprecated("Use the not future property with the same name instead.")
  Future<String> getSourceUnitId() {
    return Future.value(sourceUnitId);
  }

  /// Gets the Creative ID associated with the ad, if available. May be `null`.
  @Deprecated("Use the not future property with the same name instead.")
  Future<String?> getCreativeId() {
    return Future.value(creativeId);
  }

  /// Gets the revenue generated from the impression, in USD.
  @Deprecated("Use the not future property with the same name instead.")
  Future<double> getRevenue() {
    return Future.value(revenue);
  }

  /// Gets the precision type of the revenue field.
  @Deprecated("Use the not future property with the same name instead.")
  Future<AdRevenuePrecision> getRevenuePrecision() {
    return Future.value(revenuePrecision);
  }

  /// Gets the total number of impressions across all ad formats for the current user, across all sessions.
  @Deprecated("Use the not future property with the same name instead.")
  Future<int> getImpressionDepth() {
    return Future.value(impressionDepth);
  }

  /// Gets the accumulated value of user ad revenue in USD from all ad format impressions.
  @Deprecated("Use the not future property with the same name instead.")
  Future<double> getRevenueTotal() {
    return Future.value(revenueTotal);
  }

  /// Gets the format of the ad that is shown.
  @Deprecated("Please get AdInstance.format instead.")
  Future<AdFormat> getFormat() {
    return Future.value(_format);
  }
}

@Deprecated("Please use the new features of CAS with AdContentInfo.")
enum AdType {
  // ignore: constant_identifier_names
  Banner,
  // ignore: constant_identifier_names
  Interstitial,
  // ignore: constant_identifier_names
  Rewarded;
}

@Deprecated("Please use the new features of CAS with AdContentInfo.")
enum PriceAccuracy {
  // ignore: constant_identifier_names
  FLOOR,
  // ignore: constant_identifier_names
  BID,
  // ignore: constant_identifier_names
  UNDISCLOSED;
}

@Deprecated("Please use the new features of CAS with AdContentInfo.")
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

  AdImpression({
    required this.adType,
    required this.cpm,
    required this.network,
    required this.priceAccuracy,
    required this.versionInfo,
    required this.creativeIdentifier,
    required this.identifier,
    required this.impressionDepth,
    required this.lifetimeRevenue,
  });

  @override
  String toString() {
    return 'AdImpression('
        'adType: $adType, '
        'cpm: $cpm, '
        'network: $network, '
        'priceAccuracy: $priceAccuracy, '
        'creativeIdentifier: $creativeIdentifier, '
        'identifier: $identifier)';
  }
}
