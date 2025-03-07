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

  static AdRevenuePrecision fromValue(int? index) {
    if (index == null) {
      return unknown;
    } else {
      return values[index];
    }
  }
}
