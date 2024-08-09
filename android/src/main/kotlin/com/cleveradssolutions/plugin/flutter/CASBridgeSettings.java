package com.cleveradssolutions.plugin.flutter;

import android.util.Log;

import com.cleversolutions.ads.AdNetwork;

public final class CASBridgeSettings {

    public static String getActiveMediationPattern() {
        return AdNetwork.getActiveNetworkPattern();
    }

    public static boolean isActiveMediationNetwork(int network) {
        try {
            return AdNetwork.isActiveNetwork(AdNetwork.values()[network]);
        } catch (Throwable e) {
            Log.e("CAS.dart", "isActiveMediationNetwork call wrong Network with index " + network);
            return false;
        }
    }
}
