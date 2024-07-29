import 'dart:async';

import 'package:flutter/services.dart';

import '../consent_flow.dart';
import '../internal/internal_listener_container.dart';
import '../on_dismiss_listener.dart';

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
