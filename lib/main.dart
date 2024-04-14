import 'package:flutter/material.dart';
import 'package:home_dashboard/globals.dart';
import 'package:home_dashboard/presentation/home/home_page.dart';
import 'package:home_dashboard/presentation/settings/settings_page.dart';

void main() {
  Globals.secureStorage;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      routes: {
        '/home': (context) => const HomePage(),
        '/settings': (context) => const SettingsPage(),
      },
      initialRoute: '/home',
    );
  }
}
