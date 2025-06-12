enum Gender {
  unknown,
  male,
  female,
  @Deprecated("Use Gender.unknown instead")
  // ignore: constant_identifier_names
  UNKNOWN,
  @Deprecated("Use Gender.male instead")
  // ignore: constant_identifier_names
  MALE,
  @Deprecated("Use Gender.female instead")
  // ignore: constant_identifier_names
  FEMALE
}
