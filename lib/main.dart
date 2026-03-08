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
  // Preserva el splash nativo mientras completamos la inicialización asíncrona.
  // Sin esto, el splash desaparece en cuanto el engine de Flutter está listo,
  // antes de que Firebase y las dependencias terminen de cargar.
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initDependencies();

  // Libera el splash — a partir de aquí se renderiza el primer frame de Flutter.
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
      theme: theme.dark(),
      routerConfig: AppRouter.router,
      // i18n: Flutter delega la resolución del idioma al OS del dispositivo.
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Resuelve el idioma del dispositivo a uno de los locales soportados.
      // Cubre variantes regionales (en_US, es_419, en_GB) que el algoritmo
      // por defecto de Flutter no siempre mapea correctamente.
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null) {
          for (final supported in supportedLocales) {
            if (supported.languageCode == locale.languageCode) {
              return supported;
            }
          }
        }
        // El OS está en un idioma no soportado → fallback a inglés.
        return const Locale('en');
      },
    );
  }
}
