import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swype/features/authentication/providers/onboarding_provider.dart';
import 'package:swype/features/settings/providers/user_options_provider.dart';
import 'package:swype/localizations/translation_service.dart';
import 'package:swype/real-tilme-communication/ably_service.dart';
import 'package:swype/routes/route_generate.dart';
import 'package:swype/utils/preferences/preferences_provider.dart';
import 'package:swype/utils/theme/theme.dart';

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late AblyService ablyService;

  @override
  void initState() {
    super.initState();

    ablyService = AblyService(ref);
    ablyService.initialize();
    ablyService.subscribeToOnlineUsers();

    fetchInitialData();
  }

  void fetchInitialData() {
    TranslationService().fetchTranslationData(ref);
    ref.read(profileOptionsProvider.notifier).fetchProfileOptions();
    ref.read(onboardingProvider.notifier).fetchOnBoardingData(ref);
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(preferencesProvider).preferredLanguage;
    final isRtl = language != 'en';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swype',
      initialRoute: '/',
      theme: CAppTheme.appTheme,
      onGenerateRoute: generateRoute,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: Directionality(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: child!,
          ),
        );
      },
    );
  }
}
