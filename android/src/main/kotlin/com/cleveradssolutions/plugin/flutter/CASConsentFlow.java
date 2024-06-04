package com.cleveradssolutions.plugin.flutter;

import android.app.Activity;

import com.cleversolutions.ads.ConsentFlow;

public final class CASConsentFlow {
    final ConsentFlow flow = new ConsentFlow();

    public CASConsentFlow() {

    }

    public void disable() {
        flow.setEnabled(false);
    }

    public void withPrivacyPolicy(String privacyPolicy) {
        flow.withPrivacyPolicy(privacyPolicy);
    }

    public void withDismissListener(CASConsentFlowDismissListener listener) {
        flow.withDismissListener(listener::onConsentFlowDismissed);
    }

    public void withActivity(Activity activity) {
        flow.withUIContext(activity);
    }

    public void show() {
        flow.show();
    }
}
