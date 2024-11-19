import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract class NativeObject {
  final String id;
  late MethodChannel channel;

  static final Map<String, MethodChannel> _factoryChannels = {};
  static final Map<String, Finalizer<String>> _finalizers = {};

  NativeObject(String channelName, [String? objectId])
      : id = objectId ?? UniqueKey().hashCode.toString() {
    channel = MethodChannel('$channelName.$id');

    final factoryChannel =
        _factoryChannels[channelName] ??= MethodChannel(channelName);
    factoryChannel.invokeMethod('initObject', {'id': id});

    final finalizer = _finalizers[channelName] ??= Finalizer(
        (id) => factoryChannel.invokeMethod('disposeObject', {'id': id}));
    finalizer.attach(this, id);
  }
}
