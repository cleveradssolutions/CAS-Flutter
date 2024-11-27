import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract class MappedObject with MappedObjectImpl {
  MappedObject(String channelName, [String? id, bool isWidget = false]) {
    init(channelName, id, isWidget);
  }
}

mixin MappedObjectImpl {
  static final Map<String, MethodChannel> _channels = {};
  static final Map<String, Finalizer<String>> _finalizers = {};

  late final MethodChannel channel;
  late final String id;

  void init(String channelName, [String? id, bool isWidget = false]) {
    this.id = id ??= UniqueKey().toString();
    channel = _channels[channelName] ??= MethodChannel(channelName);
    if (!isWidget) {
      final finalizer = _finalizers[channelName] ??=
          Finalizer((id) => channel.invokeMethod('dispose', {'id': id}));
      finalizer.attach(this, id);
      invokeMethod('init');
    }
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
