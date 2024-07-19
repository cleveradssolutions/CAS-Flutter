import 'dart:async';

import 'package:clever_ads_solutions/internal/internal_listener_container.dart';
import 'package:clever_ads_solutions/public/consent_flow.dart';
import 'package:clever_ads_solutions/public/on_dismiss_listener.dart';
import 'package:flutter/services.dart';

class InternalCASConsentFlow extends ConsentFlow {
  final MethodChannel _channel;
  final InternalListenerContainer _listenerContainer;

  InternalCASConsentFlow(this._channel, this._listenerContainer);

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
      if (privacyPolicy.isNotEmpty) {
        _channel.invokeMethod('withPrivacyUrl', {'privacyUrl': privacyPolicy});
      }

      _channel.invokeMethod('showConsentFlow');
    }
  }
}
