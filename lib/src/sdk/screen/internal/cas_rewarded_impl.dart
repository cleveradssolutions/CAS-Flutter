import 'package:clever_ads_solutions/src/sdk/screen/cas_rewarded.dart';
import 'package:clever_ads_solutions/src/sdk/screen/on_reward_earned_listener.dart';
import 'package:flutter/services.dart';

import '../../../internal/ad_error_factory.dart';
import '../../../internal/mapped_object.dart';
import '../../ad_content_info.dart';
import '../../internal/ad_content_info_impl.dart';
import '../../internal/ad_format_factory.dart';
import '../../on_ad_impression_listener.dart';
import '../screen_ad_content_callback.dart';

class CASRewardedImpl extends MappedObject implements CASRewarded {
  @override
  ScreenAdContentCallback? contentCallback;

  @override
  OnAdImpressionListener? impressionListener;

  OnRewardEarnedListener? _onRewardEarnedListener;

  CASRewardedImpl(String casId) : super('cleveradssolutions/rewarded', casId);

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

      case 'onUserEarnedReward':
        _onRewardEarnedListener?.onUserEarnedReward(_getContentInfo(call));
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
  Future<AdContentInfo?> getContentInfo() async {
    return _contentInfo;
  }

  @override
  Future<void> load() {
    return invokeMethod('load');
  }

  @override
  Future<void> show(OnRewardEarnedListener listener) {
    _onRewardEarnedListener = listener;
    return invokeMethod('show');
  }

  @override
  Future<void> destroy() {
    contentCallback = null;
    impressionListener = null;
    _onRewardEarnedListener = null;
    _contentInfo = null;
    _contentInfoId = null;
    return invokeMethod('destroy');
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
