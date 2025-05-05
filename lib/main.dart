import 'package:flutter/material.dart';
import 'splash.dart';
import 'menu.dart'; // Asegúrate de tener este archivo creado

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iBreath',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF14749A),
        fontFamily: 'ABeeZee',
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreenWrapper(),
        '/menu': (context) => const MenuScreen(),
      },
    );
  }
}
