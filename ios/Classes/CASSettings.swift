import Foundation
import CleverAdsSolutions

public class CASSettings {
    
    public static func getSDKVersion() -> String {
        return CAS.getSDKVersion()
    }
    
    public static func setUserConsent(cosent: Int) {
        let val = CASConsentStatus(rawValue: cosent)
        if (val != nil) {
            CAS.settings.userConsent = val!
        }
    }
    
    public static func getUserConsent() -> Int {
        return CAS.settings.userConsent.rawValue
    }
    
    public static func setCcpaStatus(cppa: Int) {
        let val = CASCCPAStatus(rawValue: cppa)
        if (val != nil) {
            CAS.settings.userCCPAStatus = val!
        }
    }
    
    public static func getCcpaStatus() -> Int {
        return CAS.settings.userCCPAStatus.rawValue
    }
    
    public static func setTaggedAudience(audienc: Int) {
        let val = CASAudience(rawValue: audienc)
        if (val != nil) {
            CAS.settings.taggedAudience = val!
        }
    }
    
    public static func getTaggedAudience() -> Int {
        return CAS.settings.taggedAudience.rawValue
    }
    
    public static func setDebugMode(debug: Bool) {
        CAS.settings.setDebugMode(debug)
    }
    
    public static func setMutedAdSounds(muted: Bool) {
        CAS.settings.mutedAdSounds = muted
    }
    
    public static func setLoadingMode(value: Int) {
        let val = CASLoadingManagerMode(rawValue: value)
        if (val != nil) {
            CAS.settings.setLoading(mode: val!)
        }
    }
    
    public static func setRefreshBannerDelay(delay: Int) {
        CAS.settings.bannerRefreshInterval = delay
    }
    
    public static func getBannerRefreshDelay() -> Int {
        return CAS.settings.bannerRefreshInterval
    }
    
    public static func setInterstitialInterval(interval: Int) {
        CAS.settings.interstitialInterval = interval
    }
    
    public static func getInterstitialInterval() -> Int {
        return CAS.settings.interstitialInterval
    }
    
    public static func restartInterstitialInterval() {
        CAS.settings.restartInterstitialInterval()
    }
    
    public static func setAnalyticsCollectionEnabled(enabled: Bool) {
        CAS.settings.setAnalyticsCollection(enabled: enabled)
    }
    
    public static func clearTestDeviceIds() {
        CAS.settings.setTestDevice(ids: [])
    }
    
    public static func addTestDeviceId(deviceId: String) {
        CAS.settings.setTestDevice(ids: [deviceId])
    }
    
    public static func setTestDeviceIds(testDeviceIds: [String]) {
        CAS.settings.setTestDevice(ids: testDeviceIds)
    }
    
    public static func allowInterInsteadOfRewarded(allow: Bool) {
        CAS.settings.setInterstitialAdsWhenVideoCostAreLower(allow: allow)
    }
    
    public static func setUserGender(gender: Int) {
        let val = Gender(rawValue: gender)
        if (val != nil) {
            CAS.targetingOptions.setGender(val!)
        }
    }
    
    public static func setUserAge(age: Int) {
        CAS.targetingOptions.setAge(age)
    }
    
    public static func validateIntegration() {
        CAS.validateIntegration()
    }
    
    public static func getActiveMediationPattern() -> String {
        return "Not implemented feature yet"
    }
    
    public static func isActiveMediationNetwork(network: Int) -> Bool {
        return false
    }
}
