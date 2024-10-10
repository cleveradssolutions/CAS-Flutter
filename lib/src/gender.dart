enum Gender {
  unknown,
  male,
  female,
  @Deprecated("Use Gender.unknown instead")
  UNKNOWN,
  @Deprecated("Use Gender.male instead")
  MALE,
  @Deprecated("Use Gender.female instead")
  FEMALE
}
