import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:pulse/core/di/injection.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/typography.dart';
import 'package:pulse/features/map/presentation/map_screen.dart';
import 'package:pulse/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/.env');

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  await initDependencies();

  String accessToken = dotenv.get('ACCESS_TOKEN');
  MapboxOptions.setAccessToken(accessToken);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Poppins", "Space Grotesk");
    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Pulse',
      debugShowCheckedModeBanner: false,
      theme: theme.dark(),
      home: const MapScreen(),
    );
  }
}
