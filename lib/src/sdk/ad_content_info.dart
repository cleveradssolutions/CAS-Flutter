import 'package:clever_ads_solutions/src/sdk/ad_revenue_precision.dart';
import 'package:clever_ads_solutions/src/sdk/ad_source_id.dart';

import 'ad_format.dart';

abstract class AdContentInfo {
  /// Gets the format of the ad that is shown.
  Future<AdFormat> getFormat();

  /// Gets the display name of the mediated network that purchased the impression.
  Future<String> getSourceName();

  /// Gets the ID of the mediated network that purchased the impression.
  ///
  /// See [AdSourceId].
  Future<AdSourceId> getSourceId();

  /// Gets the Ad Unit ID from the mediated network that purchased the impression.
  Future<String> getSourceUnitId();

  /// Gets the Creative ID associated with the ad, if available. May be `null`.
  ///
  /// You can use this ID to report creative issues to the Ad review team.
  Future<String?> getCreativeId();

  /// Gets the revenue generated from the impression, in USD.
  ///
  /// The revenue value may be either estimated or exact, depending on the precision specified by [revenuePrecision].
  Future<double> getRevenue();

  /// Gets the precision type of the revenue field.
  ///
  /// See [AdRevenuePrecision].
  Future<AdRevenuePrecision> getRevenuePrecision();

  /// Gets the total number of impressions across all ad formats for the current user, across all sessions.
  Future<int> getImpressionDepth();

  /// Gets the accumulated value of user ad revenue in USD from all ad format impressions.
  Future<double> getRevenueTotal();
}
