package com.cleveradssolutions.plugin.flutter;

import android.app.Activity;
import android.util.Log;

import androidx.annotation.NonNull;

import com.cleversolutions.ads.ConsentFlow;
import com.cleversolutions.ads.android.CAS;

public final class CASBridgeBuilder {
    final CAS.ManagerBuilder builder;
    final Activity activity;
    CASInitCallback initCallback;
    CASCallback interListener;
    CASCallback rewardListener;

    public CASBridgeBuilder(Activity activity) {
        this.activity = activity;
        builder = CAS.buildManager();
    }

    public void withTestMode(boolean enable) {
        builder.withTestAdMode(enable);
    }

    public void setUserId(String id) {
        builder.withUserID(id);
    }

    public void disableConsentFlow() {
        builder.withConsentFlow(new ConsentFlow(false));
    }

    public void enableConsentFlow(String url) {
        builder.withConsentFlow(new ConsentFlow().withPrivacyPolicy(url));
    }

    public void addExtras(String key, String value) {
        builder.withMediationExtras(key, value);
    }

    public void setCallbacks(CASInitCallback initCallback,
                             CASCallback interListener,
                             CASCallback rewardListener) {
        this.initCallback = initCallback;
        this.interListener = interListener;
        this.rewardListener = rewardListener;
    }

    public CASBridge build(@NonNull String id, @NonNull String flutterVersion, int formats, ConsentFlow flow) {
        try {
            return buildInternal(id, flutterVersion, formats, flow);
        } catch (Throwable e) {
            Log.e("CAS.dart", "Initialize Flutter Bridge failed", e);
            return null;
        }
    }

    public CASBridge buildInternal(@NonNull String id, @NonNull String flutterVersion, int formats, ConsentFlow flow) {
        builder.withEnabledAdTypes(formats)
                .withCasId(id)
                .withFramework("Flutter", flutterVersion)
//                .withUIContext(activity)
                .withConsentFlow(flow);
        return new CASBridge(activity, this);
    }
}
