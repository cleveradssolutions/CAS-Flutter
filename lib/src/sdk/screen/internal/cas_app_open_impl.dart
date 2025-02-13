import 'package:flutter/services.dart';

import '../../../internal/mapped_object.dart';
import '../../ad_content.dart';
import '../../ad_format.dart';
import '../../on_ad_impression_listener.dart';
import '../cas_app_open.dart';
import '../screen_ad_content_callback.dart';

class CASAppOpenImpl extends MappedObject implements CASAppOpen {
  @override
  ScreenAdContentCallback? contentCallback;

  @override
  OnAdImpressionListener? impressionListener;

  CASAppOpenImpl(String managerId) : super('cleveradssolutions/app_open', managerId);

  @override
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAdLoaded':
        contentCallback?.onAdLoaded(AdContent.tryParse(call));
        break;
      case 'onAdFailedToLoad':
        final arguments = call.arguments
        contentCallback?.onAdFailedToLoad(AdFormat(arguments), AdError(arguments));
        break;
      case 'onAdShowed':
        contentCallback?.onAdShowed(AdContent.tryParse(call));
        break;
      case 'onAdFailedToShow':
        final arguments = call.arguments
        contentCallback?.onAdFailedToShow(AdFormat(arguments), AdError(arguments));
        break;
      case 'onAdClicked':
        contentCallback?.onAdClicked(AdContent.tryParse(call));
        break;
      case 'onAdDismissed':
        contentCallback?.onAdDismissed(AdContent.tryParse(call));
        break;

      case 'onAdImpression':
        impressionListener?.onAdImpression(AdContent.tryParse(call));
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
    return invokeMethod('destroy');
  }
}
