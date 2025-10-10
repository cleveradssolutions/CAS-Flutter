import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'internal_bridge.dart';
import 'ad_size.dart';
import 'ad_error.dart';

part 'ad_callbacks.dart';

part 'ad_content_info.dart';

part 'banner_ads.dart';

part 'native_ads.dart';

part 'ad_widgets.dart';

/// The base class for all ads formats.
abstract class AdInstance {
  /// Default constructor, used by subclasses.
  AdInstance({
    required this.format,
    this.onAdFailedToLoad,
    this.onAdClicked,
    this.onAdImpression,
  });

  /// The ad format of this instance.
  final AdFormat format;

  /// Called when the ad content fails to load.
  ///
  /// This function provides an opportunity to handle loading failures,
  /// such as displaying an error message to the user or attempting to load a different ad.
  OnAdFailedCallback? onAdFailedToLoad;

  /// Called when the ad content is clicked by the user.
  ///
  /// This function provides an opportunity to handle user clicks on the ad,
  /// such as tracking click events or updating the UI.
  OnAdCallback? onAdClicked;

  /// Callback to be invoked when an ad is estimated to have earned money.
  /// Available for allowlisted accounts only.
  OnAdContentCallback? onAdImpression;

  /// Contains information about the loaded request.
  ///
  /// Only present if the ad has been successfully loaded.
  Future<AdContentInfo?> getContentInfo() {
    return casInternalBridge.getContentInfo(this);
  }

  /// Frees the plugin resources associated with this ad.
  void dispose() {
    onAdFailedToLoad = null;
    onAdClicked = null;
    onAdImpression = null;

    casInternalBridge.disposeAd(this);
  }
}

/// The base class for all full screen ads.
///
/// The [AdScreenInstance] is displayed as an [Overlay] on top of all app content
/// and is positioned statically; therefore, it cannot be added to the Flutter widget tree.
abstract class AdScreenInstance extends AdInstance {
  /// Default constructor, used by subclasses.
  AdScreenInstance({
    required super.format,
    this.onAdLoaded,
    super.onAdFailedToLoad,
    this.onAdFailedToShow,
    this.onAdShowed,
    super.onAdImpression,
    super.onAdClicked,
    this.onAdDismissed,
  });

  /// Called when the ad content has been successfully loaded.
  ///
  /// This function provides an opportunity to handle successful ad loading,
  /// such as preparing the ad for display.
  OnScreenAdCallback? onAdLoaded;

  /// Called when the ad content fails to show.
  ///
  /// This function is triggered if there is an issue displaying the ad content. Implement this method to handle
  /// errors related to ad presentation, such as retrying the display or notifying the user.
  OnAdFailedCallback? onAdFailedToShow;

  /// Called when the ad content is successfully shown.
  ///
  /// This function is triggered when the ad content has been successfully displayed.
  /// Use this function to perform any actions required after the ad is shown,
  /// such as logging or UI updates.
  OnScreenAdCallback? onAdShowed;

  /// Called when the ad content is dismissed.
  ///
  /// This function is triggered when the ad content is closed or dismissed by the user. Use this method to perform
  /// any necessary actions after the ad has been dismissed, such as cleaning up resources or updating the UI.
  OnScreenAdCallback? onAdDismissed;

  /// Gets or sets whether auto loading of ads is enabled.
  ///
  /// If enabled, the ad will automatically load new content when the current ad is dismissed or completed.
  /// Additionally, it will automatically retry loading the ad if an error occurs during the loading process.
  Future<void> setAutoloadEnabled(bool isEnabled) {
    return casInternalBridge.setAutoloadEnabled(this, isEnabled);
  }

  /// Indicates whether the auto reload ad is currently enabled.
  Future<bool> isAutoloadEnabled() {
    return casInternalBridge.isAutoloadEnabled(this);
  }

  /// Indicates whether the ad is currently loaded and ready to be shown.
  Future<bool> isLoaded() {
    return casInternalBridge.isAdLoaded(this);
  }

  /// Manual retry to load the ad.
  ///
  /// If [AdScreenInstance.isAutoloadEnabled] is enabled,
  /// this function will be called automatically when necessary.
  Future<void> load() {
    return casInternalBridge.loadAd(this);
  }

  /// Display this on top of the application.
  ///
  /// Set ad callbacks before calling this method to be notified of events
  /// that occur when showing the ad.
  Future<void> show() {
    return casInternalBridge.showScreenAd(this);
  }

  /// The dispose function should be called from [onAdFailedToShow] and [onAdDismissed]
  /// to free up resources if you do not expect automatic loading
  /// and will not load this instance again.
  @override
  void dispose() {
    super.dispose();
    onAdLoaded = null;
    onAdShowed = null;
    onAdFailedToShow = null;
    onAdDismissed = null;
    // ignore: deprecated_member_use_from_same_package
    contentCallback = null;
    // ignore: deprecated_member_use_from_same_package
    impressionListener = null;
  }

  /// Listener to be invoked when an ad is estimated to have earned money.
  /// Available for allowlisted accounts only.
  ///
  /// **Deprecated:** Replaced with [onAdImpression] callback.
  @Deprecated("Replaced with onAdImpression callback.")
  OnAdImpressionListener? impressionListener;

  /// Gets or sets the callback for handling ad content events.
  ///
  /// This callback is used to handle various ad content events, such as when the ad is loaded, failed to load,
  /// or shown. Setting this property allows you to respond to these events as needed.
  @Deprecated(
      "Replaced with separate callbacks: onAdLoaded, onAdFailedToLoad, and others.")
  ScreenAdContentCallback? contentCallback;
}

/// Manages an app open ad, allowing for loading, showing, and destroying the ad content.
///
/// This class provides functionality to handle app open ads, which are
/// full-screen ads that cover the entire screen.
class CASAppOpen extends AdScreenInstance {
  /// Create [CASAppOpen] and load ad content.
  ///
  /// - [casId] - The unique identifier of the CAS content for each platform.
  /// Leave blank to use the initialization identifier.
  /// - [autoReload] - If enabled, the ad will automatically load new content when the current ad is dismissed or completed.
  /// Additionally, it will automatically retry loading the ad if an error occurs during the loading process.
  /// - [autoShow] - If enabled, the ad will automatically displayed when the user returns to the app.
  /// - [onAdLoaded] - Callback to be invoked when the ad content has been successfully loaded.
  /// - [onAdFailedToLoad] - Callback to be invoked when the ad content fails to load.
  /// - [onAdFailedToShow] - Callback to be invoked when the ad content fails to show.
  /// - [onAdImpression] - Callback to be invoked when an ad is estimated to have earned money.
  /// - [onAdClicked] - Callback to be invoked when the ad content is clicked by the user.
  /// - [onAdDismissed] - Callback to be invoked when the ad content is dismissed.
  CASAppOpen.createAndLoad({
    String? casId,
    bool autoReload = false,
    bool autoShow = false,
    super.onAdLoaded,
    super.onAdFailedToLoad,
    super.onAdFailedToShow,
    super.onAdShowed,
    super.onAdImpression,
    super.onAdClicked,
    super.onAdDismissed,
  }) : super(format: AdFormat.appOpen) {
    casInternalBridge.createAdInstance(
      ad: this,
      shouldLoad: true,
      casId: casId,
      arguments: <String, dynamic>{
        'autoload': autoReload,
        'autoshow': autoShow,
      },
    );
  }

  /// Create new [CASAppOpen] Instance
  @Deprecated("Please use new createAndLoad() function")
  CASAppOpen.create(String casId) : super(format: AdFormat.appOpen) {
    casInternalBridge.createAdInstance(
        ad: this, shouldLoad: false, casId: casId);
  }

  /// Controls whether the ad should be automatically displayed when the user returns to the app.
  ///
  /// Note that the ad must be ready for display at the time of returning to the app.
  Future<void> setAutoshowEnabled(bool isEnabled) {
    return casInternalBridge.setAutoshowEnabled(this, isEnabled);
  }

  /// Indicates whether the auto show ad is currently enabled.
  Future<bool> isAutoshowEnabled() {
    return casInternalBridge.isAutoshowEnabled(this);
  }
}

/// Manages an interstitial ad, allowing for loading, showing, and destroying the ad content.
///
/// This class provides functionality to handle interstitial ads, which are
/// full-screen ads that cover the entire screen and are typically used at natural transition points within an app.
class CASInterstitial extends AdScreenInstance {
  /// Create [CASInterstitial] and load ad content.
  ///
  /// - [casId] - The unique identifier of the CAS content for each platform.
  /// Leave blank to use the initialization identifier.
  /// - [autoReload] - If enabled, the ad will automatically load new content
  /// when the current ad is dismissed or completed.
  /// Additionally, it will automatically retry loading the ad if an error occurs
  /// during the loading process.
  /// - [autoShow] - If enabled, the ad will automatically displayed when the user returns to the app.
  /// - [minInterval] - The minimum interval between showing interstitial ads, in seconds.
  /// - [onAdLoaded] - Callback to be invoked when the ad content has been successfully loaded.
  /// - [onAdFailedToLoad] - Callback to be invoked when the ad content fails to load.
  /// - [onAdFailedToShow] - Callback to be invoked when the ad content fails to show.
  /// - [onAdImpression] - Callback to be invoked when an ad is estimated to have earned money.
  /// - [onAdClicked] - Callback to be invoked when the ad content is clicked by the user.
  /// - [onAdDismissed] - Callback to be invoked when the ad content is dismissed.
  CASInterstitial.createAndLoad({
    String? casId,
    bool autoReload = false,
    bool autoShow = false,
    int? minInterval,
    super.onAdLoaded,
    super.onAdFailedToLoad,
    super.onAdFailedToShow,
    super.onAdShowed,
    super.onAdImpression,
    super.onAdClicked,
    super.onAdDismissed,
  }) : super(format: AdFormat.interstitial) {
    casInternalBridge.createAdInstance(
      ad: this,
      shouldLoad: true,
      casId: casId,
      arguments: <String, dynamic>{
        'autoload': autoReload,
        'autoshow': autoShow,
        'minInterval':
            minInterval ?? casInternalBridge.defaultInterstitialMinInterval,
      },
    );
  }

  /// Create new Interstitial Instance
  @Deprecated("Please use new createAndLoad() function")
  CASInterstitial.create(String casId) : super(format: AdFormat.interstitial) {
    casInternalBridge.createAdInstance(
      ad: this,
      shouldLoad: false,
      casId: casId,
      arguments: <String, dynamic>{
        'minInterval': casInternalBridge.defaultInterstitialMinInterval,
      },
    );
  }

  /// Controls whether the ad should be automatically displayed when the user returns to the app.
  ///
  /// Note that the ad must be ready for display at the time of returning to the app.
  Future<void> setAutoshowEnabled(bool isEnabled) {
    return casInternalBridge.setAutoshowEnabled(this, isEnabled);
  }

  /// Indicates whether the auto show ad is currently enabled.
  Future<bool> isAutoshowEnabled() {
    return casInternalBridge.isAutoshowEnabled(this);
  }

  /// The minimum interval between showing interstitial ads, in seconds.
  ///
  /// Attempting to show a new interstitial ad before the interval has passed
  /// after the previous one was dismissed will trigger
  /// [AdScreenInstance.onAdFailedToShow] with [AdError.codeNotPassedInterval].
  ///
  /// Note that the timer for the minimum interval is shared across all
  /// interstitial ad instances, but the minimum interval value may differ for
  /// each ad instance.
  ///
  /// If you need to reset the minimum interval timer after showing a Rewarded Ad
  /// or an AppOpen Ad, you can call the [restartInterval] method
  /// in the [AdScreenInstance.onAdDismissed] for these ad formats.
  Future<void> setMinInterval(int minInterval) {
    return casInternalBridge.setAdInterval(this, minInterval);
  }

  /// Gets the minimum interval between showing interstitial ads, in seconds.
  Future<int> getMinInterval() {
    return casInternalBridge.getAdInterval(this);
  }

  /// Restarts the interval countdown until the next interstitial ad display.
  ///
  /// By default, the interval before the first interstitial ad impression is ignored.
  /// Use this method to delay displaying the ad by restarting the interval countdown.
  Future<void> restartInterval() {
    return casInternalBridge.restartInterstitialAdInterval();
  }
}

/// Manages a rewarded ad, allowing for loading, showing, and destroying the ad content.
///
/// This class provides functionality to handle rewarded ads, which are ads where
/// users can earn rewards for interacting with them.
class CASRewarded extends AdScreenInstance {
  /// Create [CASRewarded] and load ad content.
  ///
  /// - [casId] - The unique identifier of the CAS content for each platform.
  /// Leave blank to use the initialization identifier.
  /// - [autoReload] - If enabled, the ad will automatically load new content
  /// when the current ad is dismissed or completed.
  /// Additionally, it will automatically retry loading the ad if an error occurs
  /// during the loading process.
  /// - [extraFillByInterstitialAd] - If enabled, the interstitial ads are shown
  /// as a fallback when a rewarded video ad has no available fill.
  /// Interstitial ads do not require the user to watch the entire ad to completion.
  /// However, the [onUserEarnedReward] will still be triggered as if the user completed the rewarded video.
  /// - [onAdLoaded] - Callback to be invoked when the ad content has been successfully loaded.
  /// - [onAdFailedToLoad] - Callback to be invoked when the ad content fails to load.
  /// - [onAdFailedToShow] - Callback to be invoked when the ad content fails to show.
  /// - [onAdImpression] - Callback to be invoked when an ad is estimated to have earned money.
  /// - [onAdClicked] - Callback to be invoked when the ad content is clicked by the user.
  /// - [onAdDismissed] - Callback to be invoked when the ad content is dismissed.
  /// - [onUserEarnedReward] - Called when the user earns a reward.
  CASRewarded.createAndLoad({
    String? casId,
    bool autoReload = false,
    bool extraFillByInterstitialAd = true,
    super.onAdLoaded,
    super.onAdFailedToLoad,
    super.onAdFailedToShow,
    super.onAdShowed,
    super.onAdImpression,
    super.onAdClicked,
    super.onAdDismissed,
    this.onUserEarnedReward,
  }) : super(format: AdFormat.rewarded) {
    casInternalBridge.createAdInstance(
      ad: this,
      shouldLoad: true,
      casId: casId,
      arguments: <String, dynamic>{
        'autoload': autoReload,
        'extraFillByInterstitialAd': extraFillByInterstitialAd,
      },
    );
  }

  /// Create [CASRewarded]
  @Deprecated("Please use new createAndLoad() function")
  CASRewarded.create(String casId) : super(format: AdFormat.rewarded) {
    casInternalBridge.createAdInstance(
        ad: this, casId: casId, shouldLoad: false);
  }

  /// Called when the user earns a reward.
  OnScreenAdCallback? onUserEarnedReward;

  /// Display this on top of the application.
  ///
  /// Be sure to implement [CASRewarded.onUserEarnedReward] callback
  /// and reward the user for watching an ad.
  ///
  /// Set ad callbacks before calling this method to be notified of events
  /// that occur when showing the ad.
  ///
  /// The [listener] argument is deprecated and will be removed in the future.
  @override
  Future<void> show([
    // ignore: deprecated_member_use_from_same_package
    OnRewardEarnedListener? listener,
  ]) {
    if (listener != null) {
      onUserEarnedReward = (ad) async {
        listener.onUserEarnedReward((await ad.getContentInfo())!);
      };
    }
    return super.show();
  }

  /// Deprecated: Set parameters in [CASRewarded.createAndLoad] function
  @Deprecated(
      "Set parameters in createAndLoad(extraFillByInterstitialAd:) function")
  Future<void> setExtraFillInterstitialAdEnabled(bool isEnabled) {
    return Future<void>.value();
  }

  /// Deprecated
  @Deprecated("Not allowed")
  Future<bool> isExtraFillInterstitialAdEnabled() {
    return Future<bool>.value(true);
  }
}
