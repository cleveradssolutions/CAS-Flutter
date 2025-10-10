import 'internal_bridge.dart';

/// User gender values.
enum Gender {
  /// Unknown gender.
  unknown,

  /// Male
  male,

  /// Female
  female
}

/// The App/user targeting options.
class TargetingOptions {
  /// The userID is a unique identifier supplied by your application
  /// and must be static for each user across sessions.
  ///
  /// Your userID should not contain any personally identifiable information such as
  /// an email address, screen name, Android ID (AID), or Google Advertising ID (GAID).
  Future<void> setUserId(String? userId) {
    return casInternalBridge.channel.invokeMethod("setUserId", userId);
  }

  /// Set targeting to user’s [Gender].
  ///
  /// Default: [Gender.unknown]
  Future<void> setGender(Gender gender) {
    return casInternalBridge.channel.invokeMethod("setGender", gender.index);
  }

  /// The user’s age
  ///
  /// Limitation: 1-99 and 0 is 'unknown'
  Future<void> setAge(int age) {
    return casInternalBridge.channel.invokeMethod("setAge", age);
  }

  /// The user's current location.
  ///
  /// Location data is not used to CAS; however, it may be used by 3rd party ad networks.
  /// Do not use Location just for advertising.
  /// Your app should have a valid use case for it as well.
  Future<void> setLocation({
    required double latitude,
    required double longitude,
  }) {
    return casInternalBridge.channel
        .invokeMethod("setLocation", {'lat': latitude, 'lon': longitude});
  }

  /// Collect from the device the latitude and longitude coordinated truncated to the
  /// hundredths decimal place.
  /// Collect only if your application already has the relevant end-user permissions.
  /// Does not collect if the target audience is children.
  ///
  /// Disabled by default.
  Future<void> setLocationCollectionEnabled(bool enabled) {
    return casInternalBridge.channel
        .invokeMethod("setLocationCollectionEnabled", enabled);
  }

  /// A list of keywords, interests, or intents related to your application.
  ///
  /// Words or phrase describing the current activity of the user for targeting purposes.
  Future<void> setKeywords(Set<String>? keywords) {
    return casInternalBridge.channel
        .invokeMethod("setKeywords", keywords?.toList());
  }

  /// Sets the content URL for a web site whose content matches the app's primary content.
  /// This web site content is used for targeting and brand safety purposes.
  ///
  /// Limitation: max URL length 512
  Future<void> setContentUrl(String? contentUrl) {
    return casInternalBridge.channel.invokeMethod("setContentUrl", contentUrl);
  }
}
