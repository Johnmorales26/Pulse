import 'package:flutter/material.dart';
import 'package:pulse/core/theme/colors.dart';
import 'package:pulse/core/theme/typography.dart';
import 'package:pulse/features/map/presentation/map_screen.dart';

void main() {
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
