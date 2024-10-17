package com.cleveradssolutions.plugin.flutter;

import android.app.Activity;

import androidx.annotation.NonNull;

import com.cleveradssolutions.plugin.flutter.bridge.MediationManagerMethodHandler;
import com.cleversolutions.ads.ConsentFlow;
import com.cleversolutions.ads.android.CAS;

import org.jetbrains.annotations.Contract;

public final class CASBridgeBuilder {
    final CAS.ManagerBuilder builder;
    final Activity activity;
    CASInitCallback initCallback;

    public CASBridgeBuilder(Activity activity, CASInitCallback initCallback) {
        this.activity = activity;
        builder = CAS.buildManager();
        this.initCallback = initCallback;
    }

    public void withTestMode(boolean isEnabled) {
        builder.withTestAdMode(isEnabled);
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

    @NonNull
    @Contract("_, _, _, _, _ -> new")
    public CASBridge build(
            @NonNull String id,
            @NonNull String flutterVersion,
            int formats,
            ConsentFlow flow,
            MediationManagerMethodHandler mediationManagerMethodHandler
    ) {
        return buildInternal(id, flutterVersion, formats, flow, mediationManagerMethodHandler);
    }

    @NonNull
    @Contract("_, _, _, _, _ -> new")
    public CASBridge buildInternal(
            @NonNull String id,
            @NonNull String flutterVersion,
            int formats,
            ConsentFlow flow,
            MediationManagerMethodHandler mediationManagerMethodHandler
    ) {
        builder.withEnabledAdTypes(formats)
                .withCasId(id)
                .withFramework("Flutter", flutterVersion)
//                .withUIContext(activity)
                .withConsentFlow(flow);
        return new CASBridge(activity, this, mediationManagerMethodHandler);
    }
}
