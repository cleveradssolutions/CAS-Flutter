import 'dart:async';

import 'package:flutter/services.dart';

import '../consent_flow.dart';
import '../on_dismiss_listener.dart';

class InternalCASConsentFlow extends ConsentFlow {
  final MethodChannel _channel =
      const MethodChannel("com.cleveradssolutions.plugin.flutter/consent_flow");
  OnDismissListener? onDismissListener;

  InternalCASConsentFlow() {
    _channel.setMethodCallHandler(handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case "OnDismissListener":
        {
          int status = call.arguments["status"];
          onDismissListener?.onConsentFlowDismissed(status);
          break;
        }
    }
  }

  @override
  ConsentFlow disableFlow() {
    isEnable = false;
    return this;
  }

  @override
  ConsentFlow withDismissListener(OnDismissListener listener) {
    onDismissListener = listener;
    return this;
  }

  @override
  ConsentFlow withPrivacyPolicy(String? privacyPolicy) {
    this.privacyPolicy = privacyPolicy;
    return this;
  }

  @override
  Future<void> show() async {
    if (!isEnable) {
      _channel.invokeMethod('disable');
    } else {
      if (privacyPolicy != null) {
        _channel.invokeMethod('withPrivacyUrl', {'url': privacyPolicy});
      }

      _channel.invokeMethod('show');
    }
  }
}
