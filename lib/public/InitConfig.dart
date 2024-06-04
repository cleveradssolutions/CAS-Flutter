class InitConfig {
  String error;
  String countryCode;
  bool isConsentRequired;
  bool isTestMode;

  InitConfig(
      String error,
      String countryCode,
      bool isConsentRequired,
      bool isTestMode
      ) : this.error = error,
          this.countryCode = countryCode,
          this.isConsentRequired = isConsentRequired,
          this.isTestMode = isTestMode;
}

enum PriceAccuracy { FLOOR, BID, UNDISCLOSED }
