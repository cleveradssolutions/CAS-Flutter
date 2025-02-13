import 'ad_format.dart';

abstract class AdContent {
  /// Gets the format of the ad that is shown.
  AdFormat get format;

  /// Gets the display name of the mediated network that purchased the impression.
  String get sourceName;

  /// Gets the ID of the mediated network that purchased the impression.
  /// 
  /// See [AdSourceId].
  int get sourceId;

  /// Gets the Ad Unit ID from the mediated network that purchased the impression.
  String get sourceUnitId;

  /// Gets the Creative ID associated with the ad, if available. May be `null`.
  /// 
  /// You can use this ID to report creative issues to the Ad review team.
  String? get creativeId;

  /// Gets the revenue generated from the impression, in USD.
  /// 
  /// The revenue value may be either estimated or exact, depending on the precision specified by [revenuePrecision].
  double get revenue;

  /// Gets the precision type of the revenue field.
  /// 
  /// See [AdRevenuePrecision].
  int get revenuePrecision;

  /// Gets the total number of impressions across all ad formats for the current user, across all sessions.
  int get impressionDepth;

  /// Gets the accumulated value of user ad revenue in USD from all ad format impressions.
  double get revenueTotal;
}