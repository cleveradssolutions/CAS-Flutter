import 'dart:async';

import 'package:flutter/services.dart';

import '../ad_position.dart';
import '../ad_view_listener.dart';
import '../cas_banner_view.dart';
import 'internal_listener_container.dart';

@Deprecated("Use BannerView instead")
class InternalCASBannerView extends CASBannerView {
  final MethodChannel _channel;
  final InternalListenerContainer _listenerContainer;
  final int _sizeId;

  InternalCASBannerView(this._channel, this._listenerContainer, this._sizeId);

  @override
  Future<void> disableBannerRefresh() {
    return _channel.invokeMethod('disableBannerRefresh', {"sizeId": _sizeId});
  }

  @override
  Future<void> disposeBanner() {
    return _channel.invokeMethod('disposeBanner', {"sizeId": _sizeId});
  }

  @override
  Future<void> hideBanner() {
    return _channel.invokeMethod('hideBanner', {"sizeId": _sizeId});
  }

  @override
  Future<bool> isBannerReady() async {
    bool? isReady =
        await _channel.invokeMethod<bool>('isAdReady', {"sizeId": _sizeId});
    return isReady ?? false;
  }

  @override
  Future<void> loadBanner() {
    return _channel.invokeMethod('loadNextAd', {"sizeId": _sizeId});
  }

  @override
  Future<void> setBannerAdRefreshRate(int refresh) {
    return _channel.invokeMethod(
        'setBannerAdRefreshRate', {"refresh": refresh, "sizeId": _sizeId});
  }

  @override
  Future<void> setBannerPosition(AdPosition position) {
    return _channel.invokeMethod('setBannerPosition',
        {"positionId": position.index, "sizeId": _sizeId, "x": 0, "y": 0});
  }

  @override
  Future<void> showBanner() {
    return _channel.invokeMethod('showBanner', {"sizeId": _sizeId});
  }

  @override
  Future<void> setBannerPositionWithOffset(
      AdPosition position, int xOffsetInDP, int yOffsetInDP) {
    return _channel.invokeMethod('setBannerPosition', {
      "positionId": AdPosition.TopLeft.index,
      "sizeId": _sizeId,
      "x": xOffsetInDP,
      "y": yOffsetInDP
    });
  }

  @override
  void setAdListener(AdViewListener listener) {
    switch (_sizeId) {
      case 1:
        _listenerContainer.standardBannerListener = listener;
        break;

      case 2:
        _listenerContainer.adaptiveBannerListener = listener;
        break;

      case 3:
        _listenerContainer.smartBannerListener = listener;
        break;

      case 4:
        _listenerContainer.leaderBannerListener = listener;
        break;

      case 5:
        _listenerContainer.mrecBannerListener = listener;
        break;
    }
  }
}
