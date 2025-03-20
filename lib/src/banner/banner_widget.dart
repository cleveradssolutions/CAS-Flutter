import 'package:flutter/material.dart';

import '../../clever_ads_solutions.dart';
import '../sdk/ad_content_info.dart';
import 'internal/banner_widget_state_impl.dart';

@Deprecated('Use BannerWidget instead')
typedef BannerView = BannerWidget;

class BannerWidget extends StatefulWidget {
  /// The unique identifier for the CAS content, typically an application bundle name.
  final String? casId;

  /// Through the use of single advanced [AdViewListener], you can listen for ads load events.
  /// Repeats the behavior of [loadCallback] and [contentCallback]
  /// and brings the description of callbacks to a more understandable form.
  final AdViewListener? adListener;

  @Deprecated('Use adListener instead')
  final AdViewListener? listener;

  /// Gets or sets the listener for ad impression events.
  ///
  /// This listener is notified when an ad impression is recorded and will be paid. It allows you to track when
  /// the ad has been successfully shown and the impression has been accounted for. You can use this to handle
  /// actions that should occur upon a successful ad impression, such as logging or updating analytics.
  final OnAdImpressionListener? onImpressionListener;

  /// Current banner ad size.
  ///
  /// If autoload disabled ([isAutoloadEnabled] = false) then please call [load] after banner size changed.
  final AdSize size;

  /// A Boolean value that determines whether autoloading of ads in the receiver is enabled.
  /// If enabled, you do not need to call the [load] method to load ads.
  /// - By default enabled if global state [AdsSettings.loadingMode] is NOT [LoadingMode.Manual].
  /// - This value will override global state of [AdsSettings.loadingMode] for specific Banner View.
  final bool? isAutoloadEnabled;

  /// Set the number of seconds an ad is displayed before a new ad is shown.
  /// After the interval has passed, a new advertisement will be automatically loaded.
  /// - This value will override global [AdsSettings.bannerRefreshInterval]
  final int? refreshInterval;

  @Deprecated('Use AdSize.getAdaptiveBanner(maxWidthDpi) instead')
  final int? maxWidthDpi;

  const BannerWidget({
    super.key,
    this.casId,
    this.adListener,
    this.onImpressionListener,
    this.size = AdSize.banner,
    this.isAutoloadEnabled,
    this.refreshInterval,
    this.maxWidthDpi,
    this.listener,
  });

  @override
  State<StatefulWidget> createState() {
    return BannerWidgetStateImpl();
  }
}

@Deprecated('Use BannerWidgetState instead')
typedef BannerViewState = BannerWidgetState;

abstract class BannerWidgetState extends State<BannerWidget> {
  /// See [BannerWidget.casId]
  Future<String> getCASId();

  /// See [BannerWidget.casId]
  Future<void> setCASId(String casId);

  /// See [BannerWidget.adListener]
  void setAdListener(AdViewListener listener);

  /// See [BannerWidget.size]
  Future<void> setSize(AdSize size);

  /// Indicates whether the ad is currently loaded and ready to be shown.
  Future<bool> isLoaded();

  @Deprecated('Use BannerWidgetState.isLoaded instead')
  Future<bool> isAdReady() => isLoaded();

  /// Information about the currently loaded ad.
  ///
  /// This property is `null` if the ad has not been loaded yet or has been destroyed.
  Future<AdContentInfo?> getContentInfo();

  /// See [BannerWidget.isAutoloadEnabled]
  Future<bool> isAutoloadEnabled();

  /// See [BannerWidget.isAutoloadEnabled]
  Future<void> setAutoloadEnabled(bool isEnabled);

  /// Manual load Banner Ad or reload current loaded Ad to skip impression.
  /// - If autoload disabled ([isAutoloadEnabled] = false) then you should use [load] before present ad.
  /// - This functionality is available only after [CAS.buildManager].
  /// - You can get a callback for the successful loading of an ad by subscribe to [loadCallback].
  Future<void> load();

  /// See [BannerWidget.refreshInterval]
  Future<int> getRefreshInterval();

  /// See [getRefreshInterval]
  Future<void> setRefreshInterval(int interval);

  /// Disable auto refresh ads.
  Future<void> disableAdRefresh();

  @Deprecated('Use BannerWidgetState.load instead')
  Future<void> loadNextAd() => load();

  /// Destroy ad in the Banner View.
  /// Call when banner ad is no longer needed.
  @override
  Future<void> dispose();
}
