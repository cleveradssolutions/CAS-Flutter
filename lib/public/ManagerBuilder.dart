import 'package:clever_ads_solutions/public/ConsentFlow.dart';
import 'package:clever_ads_solutions/public/InitializationListener.dart';
import 'package:clever_ads_solutions/public/MediationManager.dart';

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
