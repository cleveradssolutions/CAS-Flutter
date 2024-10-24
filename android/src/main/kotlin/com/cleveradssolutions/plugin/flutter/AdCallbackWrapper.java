package com.cleveradssolutions.plugin.flutter;

import androidx.annotation.NonNull;

import com.cleversolutions.ads.AdError;
import com.cleversolutions.ads.AdPaidCallback;
import com.cleversolutions.ads.AdStatusHandler;
import com.cleversolutions.ads.LoadAdCallback;

public abstract class AdCallbackWrapper implements AdPaidCallback, LoadAdCallback {

    @Override
    public abstract void onShown(@NonNull AdStatusHandler ad);

    @Override
    public abstract void onShowFailed(@NonNull String message);

    @Override
    public abstract void onClicked();

    @Override
    public void onComplete() {
    }

    @Override
    public abstract void onClosed();

    @Override
    public abstract void onAdLoaded();

    @Override
    public void onAdFailedToLoad(@NonNull AdError error) {
        onAdFailed(error.getCode());
    }

    public abstract void onAdFailed(int errorCode);

    @Override
    public abstract void onAdRevenuePaid(@NonNull AdStatusHandler ad);

}