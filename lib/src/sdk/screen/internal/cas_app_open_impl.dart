import 'package:flutter/services.dart';

import '../../../internal/ad_error_factory.dart';
import '../../../internal/mapped_object.dart';
import '../../ad_content_info.dart';
import '../../internal/ad_content_info_impl.dart';
import '../../internal/ad_format_factory.dart';
import '../../on_ad_impression_listener.dart';
import '../cas_app_open.dart';
import '../screen_ad_content_callback.dart';

class CASAppOpenImpl extends MappedObject implements CASAppOpen {
  @override
  ScreenAdContentCallback? contentCallback;

  @override
  OnAdImpressionListener? impressionListener;

  CASAppOpenImpl(String managerId)
      : super('cleveradssolutions/app_open', managerId);

  String? _adContentInfoId;
  AdContentInfo? _adContentInfo;

  @override
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAdLoaded':
        contentCallback?.onAdLoaded(_getAdContentInfo(call));
        break;
      case 'onAdFailedToLoad':
        final arguments = call.arguments;
        contentCallback?.onAdFailedToLoad(
            AdFormatFactory.fromArguments(arguments),
            AdErrorFactory.fromArguments(arguments));
        break;
      case 'onAdShowed':
        contentCallback?.onAdShowed(_getAdContentInfo(call));
        break;
      case 'onAdFailedToShow':
        final arguments = call.arguments;
        contentCallback?.onAdFailedToShow(
            AdFormatFactory.fromArguments(arguments),
            AdErrorFactory.fromArguments(arguments));
        break;
      case 'onAdClicked':
        contentCallback?.onAdClicked(_getAdContentInfo(call));
        break;
      case 'onAdDismissed':
        contentCallback?.onAdDismissed(_getAdContentInfo(call));
        break;

      case 'onAdImpression':
        impressionListener?.onAdImpression(_getAdContentInfo(call));
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
    _adContentInfo = null;
    return invokeMethod('destroy');
  }

  AdContentInfo _getAdContentInfo(MethodCall call) {
    final String adContentInfoId = call.arguments['adContentInfoId'] ?? '';
    if (adContentInfoId != _adContentInfoId) {
      _adContentInfo = AdContentInfoImpl(adContentInfoId);
      _adContentInfoId = adContentInfoId;
    }
    return _adContentInfo!;
  }
}
