package com.cleveradssolutions.plugin.flutter;

public interface CASInitCallback {
    void onCASInitialized(String error, String countryCode, boolean isConsentRequired, boolean isTestMode);
}
