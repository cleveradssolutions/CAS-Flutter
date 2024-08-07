import 'package:flutter/services.dart';

import 'gender.dart';

class TargetingOptions {
  final MethodChannel _channel;

  TargetingOptions(this._channel);

  /// Set targeting to user’s gender
  ///
  /// Default: [Gender.unknown]
  /// See [Gender]
  Future<Gender> getGender() async {
    final int? index = await _channel.invokeMethod<int>("getGender");
    return index == null ? Gender.unknown : Gender.values[index];
  }

  /// See [getGender]
  Future<void> setGender(Gender gender) async {
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

  /// The user’s age
  ///
  /// Limitation: 1-99 and 0 is 'unknown'
  Future<int> getAge() async {
    return await _channel.invokeMethod<int>("getAge") ?? 0;
  }

  /// See [getAge]
  Future<void> setAge(int age) async {
    return _channel.invokeMethod("setAge", {"age": age});
  }

  /// The user's current location.
  /// Location data is not used to CAS; however, it may be used by 3rd party ad networks.
  /// Do not use Location just for advertising.
  /// Your app should have a valid use case for it as well.
  Future<double?> getLocationLatitude() async {
    return await _channel.invokeMethod<double>("getLocationLatitude");
  }

  /// See [getLocationLatitude]
  Future<void> setLocationLatitude(double latitude) async {
    return _channel.invokeMethod(
      "setLocationLatitude",
      {"latitude": latitude},
    );
  }

  /// See [getLocationLatitude]
  Future<double?> getLocationLongitude() async {
    return await _channel.invokeMethod<double>("getLocationLongitude");
  }

  /// See [getLocationLatitude]
  Future<void> setLocationLongitude(double longitude) async {
    return _channel.invokeMethod(
      "setLocationLongitude",
      {"longitude": longitude},
    );
  }

  /// Collect from the device the latitude and longitude coordinated truncated to the
  /// hundredths decimal place.
  /// Collect only if your application already has the relevant end-user permissions.
  /// Does not collect if the target audience is children.
  ///
  /// Disabled by default.
  Future<bool> isLocationCollectionEnabled() async {
    final bool? isEnabled =
        await _channel.invokeMethod<bool>("isLocationCollectionEnabled");
    return isEnabled ?? false;
  }

  /// See [isLocationCollectionEnabled]
  Future<void> setLocationCollectionEnabled(bool isEnabled) async {
    return _channel.invokeMethod(
      "setLocationCollectionEnabled",
      {"isEnabled": isEnabled},
    );
  }

  /// A list of keywords, interests, or intents related to your application.
  /// Words or phrase describing the current activity of the user for targeting purposes.
  Future<Set<String>?> getKeywords() async {
    return _channel.invokeMethod<Set<String>>("getKeywords");
  }

  /// See [getKeywords]
  Future<void> setKeywords(Set<String>? keywords) async {
    return _channel.invokeMethod("setKeywords", {"keywords": keywords});
  }

  /// Sets the content URL for a web site whose content matches the app's primary content.
  /// This web site content is used for targeting and brand safety purposes.
  ///
  /// Limitation: max URL length 512
  Future<String?> getContentUrl() async {
    return _channel.invokeMethod<String>("getContentUrl");
  }

  /// See [getAge]
  Future<void> setContentUrl(String? contentUrl) async {
    return _channel.invokeMethod("setContentUrl", {"contentUrl": contentUrl});
  }
}
