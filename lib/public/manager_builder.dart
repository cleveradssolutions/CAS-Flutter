import 'package:clever_ads_solutions/public/consent_flow.dart';
import 'package:clever_ads_solutions/public/initialization_listener.dart';
import 'package:clever_ads_solutions/public/mediation_manager.dart';

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
