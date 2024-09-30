import Foundation
import CleverAdsSolutions

extension CASImpression {
    func toDict() -> [String: Any?] {
        var dict = [String: Any?]()
        
        dict["cpm"] = self.cpm
        dict["priceAccuracy"] = self.priceAccuracy.rawValue
        dict["adType"] = self.adType.rawValue
        dict["networkName"] = self.network
        dict["versionInfo"] = self.versionInfo
        dict["identifier"] = self.identifier
        dict["impressionDepth"] = self.impressionDepth
        dict["lifetimeRevenue"] = self.lifetimeRevenue
        dict["creativeIdentifier"] = self.creativeIdentifier
        
        return dict
    }
}
