import 'dart:async';

import 'package:flutter/services.dart';

import '../consent_flow.dart';
import '../initialization_listener.dart';
import '../internal/internal_listener_container.dart';
import '../internal/internal_mediation_manager.dart';
import '../manager_builder.dart';
import '../mediation_manager.dart';

class InternalManagerBuilder extends ManagerBuilder {
  String _casId = "demo";
  int _enableAdTypes = 0;
  final String _flutterVersion;

  final MethodChannel _channel;
  final InternalListenerContainer _listenerContainer;

  InternalManagerBuilder(
      this._channel, this._listenerContainer, this._flutterVersion);

  Future<void> _setTestMode(final bool isTestBuild) async {
    return _channel.invokeMethod('withTestAdMode', {'enabled': isTestBuild});
  }

  Future<void> _setPrivacyPolicy(final String url) async {
    return _channel.invokeMethod('withPrivacyUrl', {'privacyUrl': url});
  }

  Future<void> _disableConsentFlow() async {
    return _channel.invokeMethod('disableConsentFlow');
  }

  Future<void> _setUserId(final String userId) async {
    return _channel.invokeMethod('setUserId', {'userId': userId});
  }

  Future<void> _initialize() async {
    return _channel.invokeMethod('initialize',
        {'id': _casId, "formats": _enableAdTypes, "version": _flutterVersion});
  }

  Future<void> _addExtras(final String key, final String value) async {
    return _channel.invokeMethod("addExtras", {'key': key, "value": value});
  }

  @override
  ManagerBuilder withTestMode(final bool isTestBuild) {
    _setTestMode(isTestBuild);
    return this;
  }

  @override
  ManagerBuilder withCasId(final String casId) {
    _casId = casId;
    return this;
  }

  @override
  ManagerBuilder addExtras(String key, String value) {
    _addExtras(key, value);
    return this;
  }

  @override
  ManagerBuilder withConsentFlow(ConsentFlow consentFlow) {
    if (!consentFlow.isEnable) {
      _disableConsentFlow();
      return this;
    }

    if (!consentFlow.privacyPolicy.isNotEmpty) {
      _setPrivacyPolicy(consentFlow.privacyPolicy);
      return this;
    }

    return this;
  }

  @override
  ManagerBuilder withUserId(String userId) {
    _setUserId(userId);
    return this;
  }

  @override
  ManagerBuilder withAdTypes(int enableTypes) {
    _enableAdTypes |= enableTypes;
    return this;
  }

  @override
  ManagerBuilder withInitializationListener(InitializationListener listener) {
    _listenerContainer.initializationListener = listener;
    return this;
  }

  @override
  MediationManager initialize() {
    _initialize();
    return InternalMediationManager(_channel, _listenerContainer);
  }
}
