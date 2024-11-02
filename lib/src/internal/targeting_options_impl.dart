import 'package:flutter/services.dart';

import '../gender.dart';
import '../targeting_options.dart';

class TargetingOptionsImpl extends TargetingOptions {
  static const MethodChannel _channel =
      MethodChannel("com.cleveradssolutions.plugin.flutter/targeting_options");

  @override
  Future<Gender> getGender() async {
    final int? index = await _channel.invokeMethod<int>("getGender");
    return index == null ? Gender.unknown : Gender.values[index];
  }

  @override
  Future<void> setGender(Gender gender) {
    switch (gender) {
      case Gender.UNKNOWN:
        gender = Gender.unknown;
        break;
      case Gender.MALE:
        gender = Gender.male;
        break;
      case Gender.FEMALE:
        gender = Gender.female;
        break;
      default:
        break;
    }
    return _channel.invokeMethod("setGender", {"gender": gender.index});
  }

  @override
  Future<int> getAge() async {
    return await _channel.invokeMethod<int>("getAge") ?? 0;
  }

  @override
  Future<void> setAge(int age) {
    return _channel.invokeMethod("setAge", {"age": age});
  }

  @override
  Future<double?> getLocationLatitude() {
    return _channel.invokeMethod<double>("getLocationLatitude");
  }

  @override
  Future<void> setLocationLatitude(double latitude) {
    return _channel.invokeMethod(
      "setLocationLatitude",
      {"latitude": latitude},
    );
  }

  @override
  Future<double?> getLocationLongitude() {
    return _channel.invokeMethod<double>("getLocationLongitude");
  }

  @override
  Future<void> setLocationLongitude(double longitude) {
    return _channel.invokeMethod(
      "setLocationLongitude",
      {"longitude": longitude},
    );
  }

  @override
  Future<bool> isLocationCollectionEnabled() async {
    final bool? isEnabled =
        await _channel.invokeMethod<bool>("isLocationCollectionEnabled");
    return isEnabled ?? false;
  }

  @override
  Future<void> setLocationCollectionEnabled(bool isEnabled) {
    return _channel.invokeMethod(
      "setLocationCollectionEnabled",
      {"isEnabled": isEnabled},
    );
  }

  @override
  Future<Set<String>?> getKeywords() async {
    return (await _channel.invokeMethod<List>("getKeywords"))
        ?.toSet()
        .cast<String>();
  }

  @override
  Future<void> setKeywords(Set<String>? keywords) {
    return _channel
        .invokeMethod("setKeywords", {"keywords": keywords?.toList()});
  }

  @override
  Future<String?> getContentUrl() {
    return _channel.invokeMethod<String>("getContentUrl");
  }

  @override
  Future<void> setContentUrl(String? contentUrl) {
    return _channel.invokeMethod("setContentUrl", {"contentUrl": contentUrl});
  }
}
