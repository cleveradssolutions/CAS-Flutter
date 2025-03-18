import '../ad_content_info.dart';

/// A functional interface for listening to reward events.
///
/// Implement this interface to handle events where a user earns a reward from interacting with an ad.
class OnRewardEarnedListener {
  /// Called when a user earns a reward from the ad.
  ///
  /// This method provides an opportunity to handle the reward event, such as updating the user's rewards balance,
  /// or displaying a confirmation message to the user.
  ///
  /// [ad] The ad content associated with the reward.
  final void Function(AdContentInfo ad) onUserEarnedReward;

  OnRewardEarnedListener({required Function(AdContentInfo ad) this.onUserEarnedReward});
}
