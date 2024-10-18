// import 'dart:async';
//
// import 'package:flutter/services.dart';
//
// import '../consent_flow.dart';
// import '../internal/internal_listener_container.dart';
//
// class InternalCASConsentFlow extends ConsentFlow {
//   final MethodChannel _channel;
//   final InternalListenerContainer _listenerContainer;
//
//   InternalCASConsentFlow(this._channel, this._listenerContainer);
//
//   @override
//   ConsentFlow disableFlow() {
//     isEnabled = false;
//     return this;
//   }
//
//   @override
//   ConsentFlow withDismissListener(OnDismissListener? listener) {
//     _listenerContainer.onDismissListener = listener;
//     return this;
//   }
//
//   @override
//   ConsentFlow withPrivacyPolicy(String? url) {
//     privacyPolicyUrl = url;
//     return this;
//   }
//
//   @override
//   Future<void> show() async {
//     if (!isEnable) {
//       _channel.invokeMethod('disableConsentFlow');
//     } else {
//       if (privacyPolicy.isNotEmpty) {
//         _channel.invokeMethod('withPrivacyPolicy', {'url': privacyPolicy});
//       }
//
//       _channel.invokeMethod('showConsentFlow');
//     }
//   }
// }
