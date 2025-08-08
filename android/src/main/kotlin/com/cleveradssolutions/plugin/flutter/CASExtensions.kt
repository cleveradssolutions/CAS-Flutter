package com.cleveradssolutions.plugin.flutter

import com.cleversolutions.ads.AdError
import com.cleversolutions.ads.AdImpression

fun AdError.toMap(): HashMap<String, Any?> {
    return hashMapOf(
        "code" to code,
        "message" to message
    )
}

fun AdImpression.toMap(): HashMap<String, Any?> {
    return hashMapOf(
        "cpm" to this.cpm,
        "priceAccuracy" to this.priceAccuracy,
        "adType" to this.adType.ordinal,
        "networkName" to this.network,
        "versionInfo" to this.versionInfo,
        "identifier" to this.identifier,
        "impressionDepth" to this.impressionDepth,
        "lifetimeRevenue" to this.lifetimeRevenue,
        "creativeIdentifier" to this.creativeIdentifier
    )
}
