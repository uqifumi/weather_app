import 'package:flutter/material.dart';

import 'services/weather_service.dart';
import 'screens/weather_page.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Prakiraan Cauaca",
      home: WeatherPage(),
    );
  }
}
