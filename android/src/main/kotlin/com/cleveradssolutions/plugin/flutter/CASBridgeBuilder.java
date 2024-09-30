package com.cleveradssolutions.plugin.flutter;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.cleversolutions.ads.ConsentFlow;
import com.cleversolutions.ads.android.CAS;

import org.jetbrains.annotations.Contract;

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

    @NonNull
    @Contract("_, _, _, _ -> new")
    public CASBridge build(@NonNull String id, @NonNull String flutterVersion, int formats, ConsentFlow flow) {
        return buildInternal(id, flutterVersion, formats, flow);
    }

    @NonNull
    @Contract("_, _, _, _ -> new")
    public CASBridge buildInternal(@NonNull String id, @NonNull String flutterVersion, int formats, ConsentFlow flow) {
        builder.withEnabledAdTypes(formats)
                .withCasId(id)
                .withFramework("Flutter", flutterVersion)
//                .withUIContext(activity)
                .withConsentFlow(flow);
        return new CASBridge(activity, this);
    }
}
