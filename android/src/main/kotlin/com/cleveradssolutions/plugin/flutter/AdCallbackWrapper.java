package com.cleveradssolutions.plugin.flutter;

import androidx.annotation.NonNull;

import com.cleversolutions.ads.AdError;
import com.cleversolutions.ads.AdPaidCallback;
import com.cleversolutions.ads.AdStatusHandler;
import com.cleversolutions.ads.LoadAdCallback;

final class AdCallbackWrapper implements AdPaidCallback, LoadAdCallback {
    final CASCallback flutterCallback;
    final boolean withComplete;

    AdCallbackWrapper(CASCallback unityCallback, boolean withComplete) {
        this.flutterCallback = unityCallback;
        this.withComplete = withComplete;
    }

    @Override
    public void onShown(@NonNull AdStatusHandler ad) {
        flutterCallback.onShown();
    }

    @Override
    public void onShowFailed(@NonNull String message) {
        flutterCallback.onShowFailed(message);
    }

    @Override
    public void onClicked() {
        flutterCallback.onClicked();
    }

    @Override
    public void onComplete() {
        if (withComplete)
            flutterCallback.onComplete();
    }

    @Override
    public void onClosed() {
        flutterCallback.onClosed();
    }

    @Override
    public void onAdLoaded() {
        flutterCallback.onLoaded();
    }

    @Override
    public void onAdFailedToLoad(@NonNull AdError error) {
        onAdFailed(error.getCode());
    }

    public void onAdFailed(int errorCode) {
        flutterCallback.onFailed(errorCode);
    }

    @Override
    public void onAdRevenuePaid(@NonNull AdStatusHandler ad) {
        flutterCallback.onImpression(ad);
    }
}