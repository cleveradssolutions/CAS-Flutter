import 'consent_flow.dart';
import 'initialization_listener.dart';
import 'mediation_manager.dart';

abstract class ManagerBuilder {
  ManagerBuilder withTestMode(final bool isTestBuild);

  ManagerBuilder withCasId(final String casId);

  ManagerBuilder withAdTypes(final int enableTypes);

  ManagerBuilder withUserId(final String userId);

  ManagerBuilder withConsentFlow(ConsentFlow consentFlow);

  ManagerBuilder addExtras(String key, String value);

  ManagerBuilder withInitializationListener(InitializationListener listener);

  MediationManager initialize();
}
