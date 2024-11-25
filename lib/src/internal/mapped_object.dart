import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract class MappedObject {
  static final Map<String, MethodChannel> _channels = {};
  static final Map<String, Finalizer<String>> _finalizers = {};
  late final MethodChannel channel;

  final String id;

  MappedObject(String channelName, [String? id])
      : id = id ??= UniqueKey().hashCode.toString() {
    channel = _channels[channelName] ??= MethodChannel(channelName);
    final finalizer = _finalizers[channelName] ??=
        Finalizer((id) => channel.invokeMethod('dispose', {'id': id}));
    finalizer.attach(this, id);
    invokeMethod('init');
  }

  Future<T?> invokeMethod<T>(String method, [Map<String, dynamic>? arguments]) {
    if (arguments == null) {
      arguments = {'id': id};
    } else {
      arguments['id'] = id;
    }
    return channel.invokeMethod<T>(method, arguments);
  }
}
