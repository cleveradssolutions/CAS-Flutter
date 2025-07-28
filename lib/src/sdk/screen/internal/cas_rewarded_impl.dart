import 'package:flutter/services.dart';

import '../../../internal/ad_error_factory.dart';
import '../../../internal/mapped_object.dart';
import '../../internal/ad_format_factory.dart';
import '../../on_ad_impression_listener.dart';
import '../cas_rewarded.dart';
import '../on_reward_earned_listener.dart';
import '../screen_ad_content_callback.dart';
import 'ad_mapped_object.dart';

class CASRewardedImpl extends MappedObject
    with AdMappedObject
    implements CASRewarded {
  @override
  ScreenAdContentCallback? contentCallback;

  @override
  OnAdImpressionListener? impressionListener;

  OnRewardEarnedListener? onRewardEarnedListener;

  CASRewardedImpl(String casId) : super('cleveradssolutions/rewarded', casId);

  @override
  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onAdLoaded':
        contentCallback?.onAdLoaded?.call(getContentInfoFromCall(call));
        break;
      case 'onAdFailedToLoad':
        final arguments = call.arguments;
        contentCallback?.onAdFailedToLoad?.call(
            AdFormatFactory.fromArguments(arguments),
            AdErrorFactory.fromArguments(arguments));
        break;
      case 'onAdShowed':
        contentCallback?.onAdShowed?.call(getContentInfoFromCall(call));
        break;
      case 'onAdFailedToShow':
        final arguments = call.arguments;
        contentCallback?.onAdFailedToShow?.call(
            AdFormatFactory.fromArguments(arguments),
            AdErrorFactory.fromArguments(arguments));
        break;
      case 'onAdClicked':
        contentCallback?.onAdClicked?.call(getContentInfoFromCall(call));
        break;
      case 'onAdDismissed':
        contentCallback?.onAdDismissed?.call(getContentInfoFromCall(call));
        break;

      case 'onAdImpression':
        impressionListener?.onAdImpression(getContentInfoFromCall(call));
        break;

      case 'onUserEarnedReward':
        onRewardEarnedListener
            ?.onUserEarnedReward(getContentInfoFromCall(call));
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
  Future<bool> isExtraFillInterstitialAdEnabled() async {
    return await invokeMethod<bool>('isExtraFillInterstitialAdEnabled') ??
        false;
  }

  @override
  Future<void> setExtraFillInterstitialAdEnabled(bool isEnabled) {
    return invokeMethod(
        'setExtraFillInterstitialAdEnabled', {'isEnabled': isEnabled});
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
  Future<void> show(OnRewardEarnedListener listener) {
    onRewardEarnedListener = listener;
    return invokeMethod('show');
  }

  @override
  Future<void> dispose() {
    disposeContent();
    contentCallback = null;
    impressionListener = null;
    onRewardEarnedListener = null;
    return invokeMethod('destroy');
  }

  @override
  Future<void> destroy() {
    return dispose();
  }
}
