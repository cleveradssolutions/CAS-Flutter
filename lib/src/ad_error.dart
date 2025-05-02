import 'internal/cas_utils.dart';

/// To see the error code, see AdError.getCode().
/// To see a description of the error, see AdError.getMessage().
/// See CODE constants for a list of error codes.
class AdError implements Comparable<int> {
  static const int codeInternalError = 0;

  /// Loading ads cannot be successful without an internet connection.
  static const int codeNoConnection = 2;

  /// This means we are not able to serve ads to this person.
  ///
  /// Note that if you can see ads while you are testing with enabled MediationManager.isDemoAdMode(),
  /// your implementation works correctly and people will be able to see ads in your app once it's live.
  static const int codeNoFill = 3;

  /// A configuration error has been detected in one of the mediation ad networks.
  /// Please report error message to your manager support.
  static const int codeConfigurationError = 6;

  /// Ad are not ready to show.
  /// You need to call Load ads or use one of the automatic cache mode.
  ///
  /// If you are already using automatic cache mode then just wait a little longer.
  ///
  /// You can always check if ad is ready to show
  /// using MediationManager.isInterstitialReady() or MediationManager.isRewardedAdReady() or CASBannerView.isAdReady() methods.
  static const int codeNotReady = 1001;

  /// The manager you want to use is not active at the moment.
  /// To change the state of the manager, use MediationManager.setEnabled(AdType, boolean) method.
  static const int codeManagerIsDisabled = 1002;

  /// Ad creative has reached its daily cap for user.
  /// The reason is for cross promo only.
  static const int codeReachedCap = 1004;

  /// There is not enough space in the current view for the selected AdSize.
  /// Please make sure that the size of the banner container has enough free space.
  /// You can choose a smaller size if necessary using CASBannerView.setSize(AdSize) method.
  static const int codeNotEnoughSpace = 1005;

  /// The interval between impressions of Interstitial Ad has not yet passed.
  /// To change the interval, use AdsSettings.setInterstitialInterval(int) method.
  static const int codeIntervalNotYetPassed = 2001;

  /// You can not show ads because another fullscreen ad is being displayed at the moment.
  /// Please check your ad call logic to eliminate duplicate impressions.
  static const int codeAlreadyDisplayed = 2002;

  /// Ads cannot be shown as the application is currently not visible to the user.
  static const int codeAppIsPaused = 2003;

  final int code;

  String? _message;

  String get message => _message ?? CASUtils.getAdErrorMessage(code);

  AdError(this.code, [this._message]);

  AdError.fromMessage(String message) : code = CASUtils.getAdErrorCode(message);

  @override
  String toString() => message;

  @override
  int get hashCode => code;

  @override
  bool operator ==(Object other) {
    if (other is AdError) {
      return code == other.code;
    } else if (other is int) {
      return code == other;
    }
    return false;
  }

  @override
  int compareTo(int other) => code.compareTo(other);
}
