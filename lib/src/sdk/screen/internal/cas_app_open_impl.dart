import 'package:flutter/services.dart';

import '../../../internal/ad_error_factory.dart';
import '../../../internal/mapped_object.dart';
import '../../internal/ad_format_factory.dart';
import '../../on_ad_impression_listener.dart';
import '../cas_app_open.dart';
import '../screen_ad_content_callback.dart';
import 'ad_mapped_object.dart';

class CASAppOpenImpl extends MappedObject
    with AdMappedObject
    implements CASAppOpen {
  @override
  ScreenAdContentCallback? contentCallback;

  @override
  OnAdImpressionListener? impressionListener;

  CASAppOpenImpl(String casId) : super('cleveradssolutions/app_open', casId);

  @override
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAdLoaded':
        contentCallback?.onAdLoaded(getContentInfoFromCall(call));
        break;
      case 'onAdFailedToLoad':
        final arguments = call.arguments;
        contentCallback?.onAdFailedToLoad(
            AdFormatFactory.fromArguments(arguments),
            AdErrorFactory.fromArguments(arguments));
        break;
      case 'onAdShowed':
        contentCallback?.onAdShowed(getContentInfoFromCall(call));
        break;
      case 'onAdFailedToShow':
        final arguments = call.arguments;
        contentCallback?.onAdFailedToShow(
            AdFormatFactory.fromArguments(arguments),
            AdErrorFactory.fromArguments(arguments));
        break;
      case 'onAdClicked':
        contentCallback?.onAdClicked(getContentInfoFromCall(call));
        break;
      case 'onAdDismissed':
        contentCallback?.onAdDismissed(getContentInfoFromCall(call));
        break;

      case 'onAdImpression':
        impressionListener?.onAdImpression(getContentInfoFromCall(call));
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
    destroy();
    contentCallback = null;
    impressionListener = null;
    return invokeMethod('destroy');
  }
}
