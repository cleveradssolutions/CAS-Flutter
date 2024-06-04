import 'dart:async';
import 'package:clever_ads_solutions/internal/InternalListenerContainer.dart';
import 'package:clever_ads_solutions/public/ConsentFlow.dart';
import 'package:clever_ads_solutions/public/OnDismissListener.dart';
import 'package:flutter/services.dart';

class InternalCASConsentFlow extends ConsentFlow {
  MethodChannel _channel;
  InternalListenerContainer _listenerContainer;

  InternalCASConsentFlow(
      MethodChannel channel, InternalListenerContainer listenerContainer)
      : _channel = channel,
        _listenerContainer = listenerContainer;

  @override
  ConsentFlow disableFlow() {
    isEnable = false;
    return this;
  }

  @override
  ConsentFlow withDismissListener(OnDismissListener listener) {
    _listenerContainer.onDismissListener = listener;
    return this;
  }

  @override
  ConsentFlow withPrivacyPolicy(String privacyPolicy) {
    this.privacyPolicy = privacyPolicy;
    return this;
  }

  @override
  Future<void> show() async {
    if (!isEnable) {
      _channel.invokeMethod('disableConsentFlow');
    } else {
      if (privacyPolicy.isNotEmpty)
        _channel.invokeMethod('withPrivacyUrl', {'privacyUrl': privacyPolicy});

      _channel.invokeMethod('showConsentFlow');
    }
  }
}
