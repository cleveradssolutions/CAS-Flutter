import 'package:clever_ads_solutions/src/internal/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract class MappedObject with MappedObjectImpl {
  MappedObject(String channelName,
      [String? id, bool isManagedByNative = false]) {
    init(channelName, id, isManagedByNative);
  }
}

typedef _ChannelEntry = MapEntry<MethodChannel, Map<String, MappedObjectImpl>>;

mixin MappedObjectImpl {
  static final Map<String, _ChannelEntry> _channels = {};
  static final Map<String, Finalizer<String>> _finalizers = {};

  late final MethodChannel channel;
  late final String id;

  void init(String channelName, [String? id, bool isManagedByNative = false]) {
    this.id = id ??= UniqueKey().toString();

    final _ChannelEntry entry =
        _channels[channelName] ??= _initChannel(channelName);
    final channel = entry.key;
    this.channel = channel;
    final objects = entry.value;
    objects[id] = this;

    if (!isManagedByNative) {
      final finalizer = _finalizers[channelName] ??= Finalizer((id) {
        channel.invokeMethod('dispose', {'id': id});
        objects.remove(id);
        if (objects.isEmpty) {
          _channels.remove(channelName);
          _finalizers.remove(channelName);
        }
      });
      finalizer.attach(this, id);
      invokeMethod('init');
    }
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {}

  Future<T?> invokeMethod<T>(String method, [Map<String, dynamic>? arguments]) {
    if (arguments == null) {
      arguments = {'id': id};
    } else {
      arguments['id'] = id;
    }
    return channel.invokeMethod<T>(method, arguments);
  }

  static _ChannelEntry _initChannel(String channelName) {
    final channel = MethodChannel(channelName);
    final Map<String, MappedObjectImpl> objects = {};
    final entry = MapEntry(channel, objects);
    channel.setMethodCallHandler((call) async {
      final id = call.arguments['id'];
      if (id == null) {
        logDebug(
            'Handle method \'${call.method}\' call on channel \'${channel.name}\', error: id == null');
        return;
      }
      final object = objects[id];
      if (object == null) {
        logDebug(
            'Handle method \'${call.method}\' call on channel \'${channel.name}\', error: object not found in map');
        return;
      }
      return object.handleMethodCall(call);
    });
    return entry;
  }
}
