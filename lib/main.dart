import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'splash.dart';
import 'menu.dart';
import 'help_screen.dart';
import 'SentimientosScreen.dart';
import 'mensaje_enviado.dart';
import 'db_initializer.dart';
import 'ver_emociones.dart';
import 'login_padres.dart';
import 'registro_padres.dart';
import 'seleccion_perfil.dart';
import 'registro_hijo.dart';
import 'hijos_padres.dart';
import 'puzzle_game_screen.dart'; // importa la pantalla
void main() {
  // Solo inicializa esto si estás en Windows
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    initDatabaseForWindows();
  }

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
        '/help': (context) => const HelpScreen(),
        '/sentimiento': (context) => const SentimientoScreen(),
        '/mensaje_enviado': (context) => const MensajeEnviadoScreen(),
        '/ver_emociones': (context) => const VerEmocionesScreen(),
        '/login_padres': (context) => const LoginPadresScreen(), 
         '/registro_padres': (context) => const RegistroPadresScreen(),
        '/seleccion_perfil': (context) => const SeleccionPerfilScreen(),
        '/hijos_padres': (context) => const HijosPadresScreen(),
        '/registro_hijo': (context) => const RegistroHijoScreen(),
        '/jugar_puzzle': (context) => const PuzzleGameScreen(imagePath: '',),
      },
    );
  }
}
