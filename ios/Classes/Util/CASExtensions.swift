import CleverAdsSolutions
import Foundation

extension AdError {
    func toDict() -> [String: Any?] {
        return [
            "code": code,
            "message": description,
        ]
    }
}

extension CASImpression {
    func toDict() -> [String: Any?] {
        return [
            "cpm": cpm,
            "priceAccuracy": priceAccuracy.rawValue,
            "adType": adType.rawValue,
            "networkName": network,
            "versionInfo": versionInfo,
            "identifier": identifier,
            "impressionDepth": impressionDepth,
            "lifetimeRevenue": lifetimeRevenue,
            "creativeIdentifier": creativeIdentifier,
        ]
    }
}
