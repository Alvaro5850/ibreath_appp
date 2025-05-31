import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ibreath_appp/db_helper.dart';
import 'db/session.dart';

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    final mensaje = Session.getMensajeTemporal();
    if (mensaje != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool tieneHijoLogueado = Session.hijoId != null;

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: WavePainter(_controller.value),
              child: Container(),
            );
          },
        ),
        SafeArea(
          child: Stack(
            children: [
              const Positioned(
                top: 20,
                left: 20,
                child: Icon(Icons.home, color: Colors.white, size: 28),
              ),

              // 👤 Perfil niño (continuar o cambiar)
              Positioned(
                top: 12,
                right: 16,
                child: GestureDetector(
                  onTap: () async {
                    if (tieneHijoLogueado) {
                      final elegido = await showDialog<_OpcionPerfil>(
                        context: context,
                        builder: (context) => _DialogoPerfilActual(),
                      );

                      if (elegido == _OpcionPerfil.continuar) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/menu',
                          (route) => false,
                        );
                      } else if (elegido == _OpcionPerfil.cambiar) {
                        Session.clearHijo();
                        Navigator.pushReplacementNamed(context, '/login_padres');
                      }
                    } else {
                      Navigator.pushNamed(context, '/seleccion_perfil');
                    }
                  },
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.teal, size: 22),
                  ),
                ),
              ),

              // 💙 Imagen + título iBreath
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'assets/images/pulmones.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 25),
                      const Text(
                        'iBreath',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'ABeeZee',
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black45,
                              offset: Offset(1, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tu rincón tranquilo del día',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 🧘 ¡Vamos allá!
              Positioned(
                bottom: 120,
                left: MediaQuery.of(context).size.width * 0.2,
                right: MediaQuery.of(context).size.width * 0.2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/menu');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EC8B6),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.spa_rounded),
                  label: const Text(
                    '¡Vamos allá!',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),

              // 👨‍👧 Botón padres (consulta emociones)
              Positioned(
                bottom: 20,
                left: 10,
                child: Column(
                  children: [
                    GestureDetector(
  onTap: () {
    Navigator.pushNamed(
      context,
      '/login_padres',
      arguments: {'modoConsulta': true},
    );
  },

                      child: const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('assets/images/parental.jpg'),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Padres',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // 🚨 Urgencia
              Positioned(
                bottom: 20,
                right: 10,
                child: Column(
                  children: [
                    const Text(
                      'Urgencia',
                      style: TextStyle(
                        color: Color.fromARGB(255, 240, 165, 165),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () async {
                        final hijoId = Session.hijoId;
                        if (hijoId != null) {
                          await AppDatabase.instance.guardarEmocion(
                            hijoId: hijoId,
                            emocion: 'Emergencia',
                          );
                        }
                        Navigator.pushNamed(context, '/help');
                      },
                      child: const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('assets/images/emergency_boton.jpg'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

enum _OpcionPerfil { continuar, cambiar }

class _DialogoPerfilActual extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Perfil ya seleccionado'),
      content: const Text('¿Deseas continuar o cambiar de perfil?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(_OpcionPerfil.continuar),
          child: const Text('Continuar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_OpcionPerfil.cambiar),
          child: const Text('Cambiar perfil'),
        ),
      ],
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

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
      final y = sin((i / size.width * 2 * pi) + waveSpeed) * waveHeight +
          size.height * 0.9;
      path.lineTo(i, y);
    }
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawPath(path, Paint()..color = Colors.white.withOpacity(0.2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
