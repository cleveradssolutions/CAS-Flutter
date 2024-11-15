import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract class NativeObject {
  final String id = UniqueKey().toString();
  static MethodChannel? _factoryChannel;
  late MethodChannel channel;

  static final Finalizer<String> _finalizer = Finalizer(
      (id) => _factoryChannel!.invokeMethod('disposeObject', {'id': id}));

  NativeObject(String channelName) {
    channel = MethodChannel('$channelName.$id');
    final factoryChannel = _factoryChannel ??= MethodChannel(channelName);
    factoryChannel.invokeMethod('initObject', {'id': id});
    _finalizer.attach(this, id);
  }
}
