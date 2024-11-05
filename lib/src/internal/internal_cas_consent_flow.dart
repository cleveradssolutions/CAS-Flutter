import 'dart:async';

import 'package:flutter/services.dart';

import '../consent_flow.dart';
import '../on_dismiss_listener.dart';

class InternalCASConsentFlow extends ConsentFlow {
  static const MethodChannel _channel =
      MethodChannel("cleveradssolutions/consent_flow");
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
    _channel.invokeMethod('disable');
    return this;
  }

  @override
  ConsentFlow withDismissListener(OnDismissListener listener) {
    onDismissListener = listener;
    return this;
  }

  @override
  ConsentFlow withPrivacyPolicy(String? privacyPolicy) {
    _channel.invokeMethod('withPrivacyPolicy', {'url': privacyPolicy});
    return this;
  }

  @override
  Future<void> showIfRequired() async {
    _channel.invokeMethod('show', {'force': false});
  }

  @override
  Future<void> show() async {
    _channel.invokeMethod('show', {'force': true});
  }
}
