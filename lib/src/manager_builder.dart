import 'consent_flow.dart';
import 'init_config.dart';
import 'initialization_listener.dart';
import 'mediation_manager.dart';

abstract class ManagerBuilder {
  ManagerBuilder withTestMode(final bool isTestBuild);

  ManagerBuilder withCasId(final String casId);

  ManagerBuilder withAdTypes(final int enableTypes);

  ManagerBuilder withUserId(final String userId);

  ManagerBuilder withConsentFlow(ConsentFlow consentFlow);

  ManagerBuilder addExtras(String key, String value);

  @Deprecated(
      "Use withCompletionListener(Function(InitConfig config) onCASInitialized) instead")
  ManagerBuilder withInitializationListener(InitializationListener listener) {
    withCompletionListener(listener.onCASInitialized);
    return this;
  }

  ManagerBuilder withCompletionListener(
      Function(InitConfig config) onCASInitialized);

  MediationManager initialize();
}
