import 'dart:async';

import 'package:flutter/services.dart';

import '../consent_flow.dart';
import '../init_config.dart';
import '../internal/internal_mediation_manager.dart';
import '../manager_builder.dart';
import '../mediation_manager.dart';

class InternalManagerBuilder extends ManagerBuilder {
  static const MethodChannel _channel =
      MethodChannel("cleveradssolutions/manager_builder");

  Function(InitConfig config)? onCASInitialized;

  String _casId = "demo";

  InternalManagerBuilder(String pluginVersion) {
    _channel.setMethodCallHandler(handleMethodCall);
    _channel.invokeMethod('withFramework', {'pluginVersion': pluginVersion});
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onCASInitialized':
        {
          String? error = call.arguments["error"];
          String? countryCode = call.arguments["countryCode"];
          bool isConsentRequired = call.arguments["isConsentRequired"] ?? false;
          bool isTestMode = call.arguments["testMode"] ?? false;

          onCASInitialized?.call(
              InitConfig(error, countryCode, isConsentRequired, isTestMode));
        }
        break;
    }
  }

  @override
  ManagerBuilder withCasId(final String casId) {
    _casId = casId;
    return this;
  }

  @override
  ManagerBuilder withCompletionListener(Function(InitConfig config) listener) {
    onCASInitialized = listener;
    return this;
  }

  @override
  ManagerBuilder withTestMode(final bool isEnabled) {
    _channel.invokeMethod('withTestAdMode', {'isEnabled': isEnabled});
    return this;
  }

  @override
  ManagerBuilder withAdTypes(int adTypes) {
    _channel.invokeMethod('withAdTypes', {'formats': adTypes});
    return this;
  }

  @override
  ManagerBuilder withUserId(String userId) {
    _channel.invokeMethod('setUserId', {'userId': userId});
    return this;
  }

  @override
  ManagerBuilder withConsentFlow(ConsentFlow consentFlow) {
    return this;
  }

  @override
  ManagerBuilder withMediationExtras(String key, String value) {
    _channel.invokeMethod('withMediationExtras', {'key': key, 'value': value});
    return this;
  }

  @override
  MediationManager build() {
    _channel.invokeMethod('build', {'id': _casId});
    return InternalMediationManager();
  }

  @override
  MediationManager initialize() {
    return build();
  }
}
