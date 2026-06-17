import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pulse/l10n/app_localizations.dart';
import 'package:pulse/core/di/injection.dart';
import 'package:pulse/core/navigation/router.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/typography.dart';
import 'package:pulse/firebase_options.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initDependencies();

  FlutterNativeSplash.remove();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Poppins", "Space Grotesk");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'Pulse',
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      routerConfig: AppRouter.router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (final supported in supportedLocales) {
            if (supported.languageCode == locale.languageCode) {
              return supported;
            }
          }
        }
        return const Locale('en');
      },
    );
  }
}
