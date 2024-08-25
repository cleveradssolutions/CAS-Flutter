import 'init_config.dart';

@Deprecated(
    "Use ManagerBuilder.withCompletionListener(Function(InitConfig config) onCASInitialized) instead")
abstract class InitializationListener {
  void onCASInitialized(InitConfig config);
}
