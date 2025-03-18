import 'package:clever_ads_solutions/src/sdk/screen/cas_interstitial.dart';
import 'package:flutter/services.dart';

import '../../../internal/ad_error_factory.dart';
import '../../../internal/mapped_object.dart';
import '../../ad_content_info.dart';
import '../../internal/ad_content_info_impl.dart';
import '../../internal/ad_format_factory.dart';
import '../../on_ad_impression_listener.dart';
import '../screen_ad_content_callback.dart';

class CASInterstitialImpl extends MappedObject implements CASInterstitial {
  @override
  ScreenAdContentCallback? contentCallback;

  @override
  OnAdImpressionListener? impressionListener;

  CASInterstitialImpl(String casId)
      : super('cleveradssolutions/interstitial', casId);

  AdContentInfo? _contentInfo;
  String? _contentInfoId;

  @override
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAdLoaded':
        contentCallback?.onAdLoaded(_getContentInfo(call));
        break;
      case 'onAdFailedToLoad':
        final arguments = call.arguments;
        contentCallback?.onAdFailedToLoad(
            AdFormatFactory.fromArguments(arguments),
            AdErrorFactory.fromArguments(arguments));
        break;
      case 'onAdShowed':
        contentCallback?.onAdShowed(_getContentInfo(call));
        break;
      case 'onAdFailedToShow':
        final arguments = call.arguments;
        contentCallback?.onAdFailedToShow(
            AdFormatFactory.fromArguments(arguments),
            AdErrorFactory.fromArguments(arguments));
        break;
      case 'onAdClicked':
        contentCallback?.onAdClicked(_getContentInfo(call));
        break;
      case 'onAdDismissed':
        contentCallback?.onAdDismissed(_getContentInfo(call));
        break;

      case 'onAdImpression':
        impressionListener?.onAdImpression(_getContentInfo(call));
        break;
    }
  }

  @override
  Future<bool> isAutoloadEnabled() async {
    return await invokeMethod<bool>('isAutoloadEnabled') ?? false;
  }

  @override
  Future<void> setAutoloadEnabled(bool isEnabled) {
    return invokeMethod('setAutoloadEnabled', {'isEnabled': isEnabled});
  }

  @override
  Future<bool> isAutoshowEnabled() async {
    return await invokeMethod<bool>('isAutoshowEnabled') ?? false;
  }

  @override
  Future<void> setAutoshowEnabled(bool isEnabled) {
    return invokeMethod('setAutoshowEnabled', {'isEnabled': isEnabled});
  }

  @override
  Future<bool> isLoaded() async {
    return await invokeMethod<bool>('isLoaded') ?? false;
  }

  @override
  Future<AdContentInfo?> getContentInfo() async {
    return _contentInfo;
  }

  @override
  Future<void> load() {
    return invokeMethod('load');
  }

  @override
  Future<void> show() {
    return invokeMethod('show');
  }

  @override
  Future<void> destroy() {
    contentCallback = null;
    impressionListener = null;
    _contentInfo = null;
    _contentInfoId = null;
    return invokeMethod('destroy');
  }

  @override
  Future<int> getMinInterval() async {
    return await invokeMethod<int>('getMinInterval') ?? 0;
  }

  @override
  Future<void> setMinInterval(int minInterval) {
    return invokeMethod('setMinInterval', {'minInterval': minInterval});
  }

  @override
  Future<void> restartInterval() {
    return invokeMethod('restartInterval');
  }

  AdContentInfo _getContentInfo(MethodCall call) {
    final String id = call.arguments['contentInfoId'] ?? '';
    if (id != _contentInfoId) {
      _contentInfo = AdContentInfoImpl(id);
      _contentInfoId = id;
    }
    return _contentInfo!;
  }
}
