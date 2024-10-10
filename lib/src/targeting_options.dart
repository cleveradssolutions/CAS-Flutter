import 'gender.dart';

abstract class TargetingOptions {
  /// Set targeting to user’s gender
  ///
  /// Default: [Gender.unknown]
  /// See [Gender]
  Future<Gender> getGender();

  /// See [getGender]
  Future<void> setGender(Gender gender);

  /// The user’s age
  ///
  /// Limitation: 1-99 and 0 is 'unknown'
  Future<int> getAge();

  /// See [getAge]
  Future<void> setAge(int age);

  /// The user's current location.
  /// Location data is not used to CAS; however, it may be used by 3rd party ad networks.
  /// Do not use Location just for advertising.
  /// Your app should have a valid use case for it as well.
  Future<double?> getLocationLatitude();

  /// See [getLocationLatitude]
  Future<void> setLocationLatitude(double latitude);

  /// See [getLocationLatitude]
  Future<double?> getLocationLongitude();

  /// See [getLocationLatitude]
  Future<void> setLocationLongitude(double longitude);

  /// Collect from the device the latitude and longitude coordinated truncated to the
  /// hundredths decimal place.
  /// Collect only if your application already has the relevant end-user permissions.
  /// Does not collect if the target audience is children.
  ///
  /// Disabled by default.
  Future<bool> isLocationCollectionEnabled();

  /// See [isLocationCollectionEnabled]
  Future<void> setLocationCollectionEnabled(bool isEnabled);

  /// A list of keywords, interests, or intents related to your application.
  /// Words or phrase describing the current activity of the user for targeting purposes.
  Future<Set<String>?> getKeywords();

  /// See [getKeywords]
  Future<void> setKeywords(Set<String>? keywords);

  /// Sets the content URL for a web site whose content matches the app's primary content.
  /// This web site content is used for targeting and brand safety purposes.
  ///
  /// Limitation: max URL length 512
  Future<String?> getContentUrl();

  /// See [getAge]
  Future<void> setContentUrl(String? contentUrl);
}
