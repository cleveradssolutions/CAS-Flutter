import 'package:clever_ads_solutions/public/InitConfig.dart';

abstract class InitializationListener {
    void onCASInitialized(InitConfig config);
}