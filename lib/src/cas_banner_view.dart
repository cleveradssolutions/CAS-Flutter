import 'dart:async';

import 'ad_position.dart';
import 'ad_view_listener.dart';

@Deprecated("Use BannerWidget instead")
abstract class CASBannerView {
  void setAdListener(AdViewListener listener);

  Future<void> loadBanner();

  Future<bool> isBannerReady();

  Future<void> showBanner();

  Future<void> hideBanner();

  Future<void> setBannerPosition(AdPosition position);

  Future<void> setBannerPositionWithOffset(int xOffsetInDP, int yOffsetInDP);

  Future<void> setBannerAdRefreshRate(int refresh);

  Future<void> disableBannerRefresh();

  Future<void> disposeBanner();
}
