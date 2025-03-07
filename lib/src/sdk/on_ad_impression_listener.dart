import 'ad_content_info.dart';

/// A functional interface for listening to ad impression events.
/// Implement this interface to handle actions when an ad impression is recorded.
class OnAdImpressionListener {
  /// Called when an ad impression occurs.
  ///
  /// @param ad The ad content associated with the impression. This object contains details
  ///           about the ad, including format, source, and revenue information.
  ///
  /// This method is guaranteed to be called on the main thread.
  final void Function(AdContentInfo ad) onAdImpression;

  OnAdImpressionListener({required Function(AdContentInfo ad) this.onAdImpression});
}
