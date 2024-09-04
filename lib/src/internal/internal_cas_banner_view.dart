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
  Future<void> disableBannerRefresh() async {
    return _channel.invokeMethod('disableBannerRefresh', {"sizeId": _sizeId});
  }

  @override
  Future<void> disposeBanner() async {
    return _channel.invokeMethod('disposeBanner', {"sizeId": _sizeId});
  }

  @override
  Future<void> hideBanner() async {
    return _channel.invokeMethod('hideBanner', {"sizeId": _sizeId});
  }

  @override
  Future<bool> isBannerReady() async {
    bool? isReady =
        await _channel.invokeMethod<bool>('isBannerReady', {"sizeId": _sizeId});
    return isReady ?? false;
  }

  @override
  Future<void> loadBanner() async {
    return _channel.invokeMethod('loadBanner', {"sizeId": _sizeId});
  }

  @override
  Future<void> setBannerAdRefreshRate(int refresh) async {
    return _channel.invokeMethod(
        'setBannerAdRefreshRate', {"refresh": refresh, "sizeId": _sizeId});
  }

  @override
  Future<void> setBannerPosition(AdPosition position) async {
    return _channel.invokeMethod('setBannerPosition',
        {"positionId": position.index, "sizeId": _sizeId, "x": 0, "y": 0});
  }

  @override
  Future<void> showBanner() async {
    return _channel.invokeMethod('showBanner', {"sizeId": _sizeId});
  }

  @override
  Future<void> setBannerPositionWithOffset(int xOffsetInDP, int yOffsetInDP) {
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
        _listenerContainer.standartBannerListener = listener;
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
