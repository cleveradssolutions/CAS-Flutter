import 'init_config.dart';

abstract class InitializationListener {
  void onCASInitialized(InitConfig config);
}

class InitializationListener {
  const InitializationListener({
    required Function(InitConfig config) onCASInitialized,
  });
}
