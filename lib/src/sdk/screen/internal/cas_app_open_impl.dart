import 'package:clever_ads_solutions/src/internal/ad_error_extensions.dart';
import 'package:clever_ads_solutions/src/sdk/internal/ad_content_info_impl.dart';
import 'package:clever_ads_solutions/src/sdk/internal/ad_format_extensions.dart';
import 'package:flutter/services.dart';

import '../../../internal/mapped_object.dart';
import '../../ad_content_info.dart';
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
        final int? adContentInfoId = call.arguments['adContentInfo'];

        contentCallback?.onAdLoaded(adContentInfo);
        break;
      case 'onAdFailedToLoad':
        final arguments = call.arguments;
        contentCallback?.onAdFailedToLoad(
            AdFormatExtensions.fromArguments(arguments),
            AdErrorExtensions.fromArguments(arguments));
        break;
      case 'onAdShowed':
        contentCallback?.onAdShowed(adContentInfo);
        break;
      case 'onAdFailedToShow':
        final arguments = call.arguments;
        contentCallback?.onAdFailedToShow(
            AdFormatExtensions.fromArguments(arguments),
            AdErrorExtensions.fromArguments(arguments));
        break;
      case 'onAdClicked':
        contentCallback?.onAdClicked(adContentInfo);
        break;
      case 'onAdDismissed':
        contentCallback?.onAdDismissed(adContentInfo);
        break;

      case 'onAdImpression':
        impressionListener?.onAdImpression(adContentInfo);
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
