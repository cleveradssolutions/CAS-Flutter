package com.cleveradssolutions.plugin.flutter;

import com.cleversolutions.ads.AdStatusHandler;

@Deprecated
public interface CASViewWrapperListener {
    void onLoaded();

    void onFailed(int error);

    void onShown();

    void onImpression(AdStatusHandler impression);

    void onClicked();

    void onRect( int x, int y, int width, int height );

}
