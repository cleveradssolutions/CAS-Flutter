import 'init_config.dart';

abstract class InitializationListener {
  void onCASInitialized(InitConfig config);
}
