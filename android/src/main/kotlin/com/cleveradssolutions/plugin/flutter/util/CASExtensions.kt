package com.cleveradssolutions.plugin.flutter.util

import com.cleversolutions.ads.AdStatusHandler

fun AdStatusHandler.toMap(): HashMap<String, Any?> {
    return hashMapOf(
            "cpm" to this.cpm,
            "priceAccuracy" to this.priceAccuracy,
            "adType" to this.adType.ordinal,
            "networkName" to this.network,
            "versionInfo" to this.versionInfo,
            "identifier" to this.identifier,
            "impressionDepth" to this.impressionDepth,
            "lifeTimeRevenue" to this.lifetimeRevenue,
            "creativeIdentifier" to this.creativeIdentifier
    )
}
