import 'package:flutter/material.dart';

import '../ad_size.dart';
import 'ad_view_listener.dart';
import 'internal/banner_widget_state_impl.dart';

@Deprecated('Use BannerWidget instead')
typedef BannerView = BannerWidget;

class BannerWidget extends StatefulWidget {
  final AdViewListener? listener;

  final AdSize size;
  final bool? isAutoloadEnabled;
  final int? refreshInterval;
  @Deprecated('Use AdSize.getAdaptiveBanner(maxWidthDpi) instead')
  final int? maxWidthDpi;

  const BannerWidget(
      {super.key,
      this.size = AdSize.banner,
      this.isAutoloadEnabled,
      this.refreshInterval,
      this.maxWidthDpi,
      this.listener});

  @override
  State<StatefulWidget> createState() {
    return BannerWidgetStateImpl();
  }
}

@Deprecated('Use BannerWidgetState instead')
typedef BannerViewState = BannerWidgetState;

abstract class BannerWidgetState extends State<BannerWidget> {
  /// Through the use of single advanced [AdViewListener], you can listen for ads load events.
  /// Repeats the behavior of [loadCallback] and [contentCallback]
  /// and brings the description of callbacks to a more understandable form.
  void setAdListener(AdViewListener listener);

  /// Current banner ad size.
  ///
  /// If autoload disabled ([isAutoloadEnabled] = false) then please call [loadNextAd] after banner size changed.
  Future<void> setSize(AdSize size);

  /// Check ready banner ads
  Future<bool> isAdReady();

  /// A Boolean value that determines whether autoloading of ads in the receiver is enabled.
  /// If enabled, you do not need to call the [loadNextAd] method to load ads.
  /// - By default enabled if global state [AdsSettings.loadingMode] is NOT [LoadingManagerMode.Manual].
  /// - This value will override global state of [AdsSettings.loadingMode] for specific Banner View.
  Future<bool> isAutoloadEnabled();

  /// See [isAutoloadEnabled]
  Future<void> setAutoloadEnabled(bool isEnabled);

  /// Set the number of seconds an ad is displayed before a new ad is shown.
  /// After the interval has passed, a new advertisement will be automatically loaded.
  /// - This value will override global [AdsSettings.bannerRefreshInterval]
  Future<int> getRefreshInterval();

  /// See [getRefreshInterval]
  Future<void> setRefreshInterval(int interval);

  /// Disable auto refresh ads.
  Future<void> disableAdRefresh();

  /// Manual load Banner Ad or reload current loaded Ad to skip impression.
  /// - If autoload disabled ([isAutoloadEnabled] = false) then you should use [loadNextAd] before present ad.
  /// - This functionality is available only after [CAS.buildManager].
  /// - You can get a callback for the successful loading of an ad by subscribe to [loadCallback].
  Future<void> loadNextAd();

  /// Destroy ad in the Banner View.
  /// Call when banner ad is no longer needed.
  @override
  Future<void> dispose();
}
