// lib/login_padres.dart

import 'dart:math';

import 'package:flutter/material.dart';
import '../db/padres_db.dart';
import '../db_helper.dart';
import '../db/session.dart';
import 'hijos_padres.dart';
import 'registro_padres.dart';
import 'recuperar_contrasena.dart';

class LoginPadresScreen extends StatefulWidget {
  const LoginPadresScreen({Key? key}) : super(key: key);

  @override
  _LoginPadresScreenState createState() => _LoginPadresScreenState();
}

class _LoginPadresScreenState extends State<LoginPadresScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String error = '';
  late AnimationController _controller;

  bool modoConsulta = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Leer argumento 'modoConsulta' (viene desde Splash si es para ver emociones)
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args['modoConsulta'] == true) {
      modoConsulta = true;
    }
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        error = '⚠️ Completa ambos campos.';
      });
      return;
    }

    // Debug: imprime en consola lo que se intenta
    print('Intentando login: email="$email", pass="$password"');

    final padre =
        await PadresDB.instance.getPadreByEmailPassword(email, password);

    print('Resultado consulta padre: $padre');

    if (padre != null) {
      // Credenciales correctas: guardamos parentId en sesión
      final parentId = padre[AppDatabase.columnId] as int;
      Session.setParentId(parentId);

      // Navegamos a HijosPadresScreen pasando modoConsulta
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HijosPadresScreen(modoConsulta: modoConsulta),
          settings: RouteSettings(arguments: {'modoConsulta': modoConsulta}),
        ),
      );
    } else {
      setState(() {
        error = 'Email o contraseña incorrectos';
      });
    }
  }

  void _navigateToRegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegistroPadresScreen()),
    );
  }

  void _navigateToRecuperarContrasena() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecuperarContrasenaScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌊 Fondo animado
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _WavePainter(_controller.value),
                child: Container(),
              );
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ⬅️ Botón atrás y avatar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.teal),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      'Acceso Padres',
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'ABeeZee',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  _buildInputField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                  ),

                  const SizedBox(height: 20),

                  _buildInputField(
                    controller: _passwordController,
                    label: 'Contraseña',
                    icon: Icons.lock,
                    obscure: true,
                  ),

                  const SizedBox(height: 30),

                  Center(
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2EC8B9),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'ABeeZee',
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  if (error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Center(
                        child: Text(
                          error,
                          style: const TextStyle(
                              color: Colors.redAccent, fontSize: 14),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // 🔗 Enlaces
                  Center(
                    child: TextButton(
                      onPressed: _navigateToRegistro,
                      child: const Text(
                        '¿No tienes cuenta? Regístrate',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: _navigateToRecuperarContrasena,
                      child: const Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✏️ Campo de texto personalizado
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// 🎨 Olas animadas
class _WavePainter extends CustomPainter {
  final double animationValue;
  _WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0B486B), Color(0xFF3B8686)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    const double waveHeight = 30;
    final double waveSpeed = animationValue * 2 * pi;

    path.moveTo(0, size.height);
    for (double i = 0; i <= size.width; i++) {
      final y =
          sin((i / size.width * 2 * pi) + waveSpeed) * waveHeight +
              size.height * 0.9;
      path.lineTo(i, y);
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawPath(
        path, Paint()..color = Colors.white.withOpacity(0.2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
