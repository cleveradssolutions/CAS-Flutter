package com.cleveradssolutions.plugin.flutter;

import com.cleversolutions.ads.AdStatusHandler;

public interface CASCallback {
    void onLoaded();

    void onFailed(int error);

    void onShown();

    void onImpression(AdStatusHandler impression);

    void onShowFailed(String message);

    void onClicked();

    void onComplete();

    void onClosed();

    void onRect( int x, int y, int width, int height );

}
