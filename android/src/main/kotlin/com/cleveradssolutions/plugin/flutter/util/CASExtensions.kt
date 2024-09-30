package com.cleveradssolutions.plugin.flutter.util

import com.cleversolutions.ads.AdImpression

fun AdImpression.toMap(): Map<String, Any?> {
    return mapOf(
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
