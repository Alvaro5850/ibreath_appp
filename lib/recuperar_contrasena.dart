// lib/recuperar_contrasena.dart

import 'dart:math';
import 'package:flutter/material.dart';
import '../db/padres_db.dart';

class RecuperarContrasenaScreen extends StatefulWidget {
  const RecuperarContrasenaScreen({Key? key}) : super(key: key);

  @override
  _RecuperarContrasenaScreenState createState() =>
      _RecuperarContrasenaScreenState();
}

class _RecuperarContrasenaScreenState
    extends State<RecuperarContrasenaScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nuevaContrasenaController =
      TextEditingController();
  String mensaje = '';

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _recuperarContrasena() async {
    final email = _emailController.text.trim();
    final nuevaContrasena = _nuevaContrasenaController.text;

    if (email.isEmpty || nuevaContrasena.isEmpty) {
      setState(() {
        mensaje = '⚠️ Completa todos los campos.';
      });
      return;
    }

    // 1) Buscamos si existe un padre con ese email
    final padre = await PadresDB.instance.getPadreByEmail(email);
    if (padre != null) {
      // 2) Si existe, actualizamos la password
      await PadresDB.instance.updatePassword(email, nuevaContrasena);
      setState(() {
        mensaje = '✅ Contraseña actualizada correctamente.';
      });
    } else {
      setState(() {
        mensaje = '⚠️ Email no encontrado.';
      });
    }
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
                  // Encabezado con iconos
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
                  const SizedBox(height: 20),
                  const Text(
                    'Recuperar Contraseña',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontFamily: 'ABeeZee',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Introduce tu email y nueva contraseña:',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 30),

                  _buildInputField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    controller: _nuevaContrasenaController,
                    label: 'Nueva contraseña',
                    icon: Icons.lock,
                    obscure: true,
                  ),
                  const SizedBox(height: 30),

                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _recuperarContrasena,
                      icon: const Icon(Icons.update),
                      label: const Text('Actualizar contraseña'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2EC8B9),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),

                  if (mensaje.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          mensaje,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'ABeeZee',
                          ),
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

// 🌊 Fondo animado
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
