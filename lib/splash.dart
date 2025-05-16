import 'dart:math';
import 'package:flutter/material.dart';

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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              // Icono Home
              const Positioned(
                top: 20,
                left: 20,
                child: Icon(Icons.home, color: Colors.white, size: 28),
              ),

              // Ícono de usuario blanco en la esquina superior derecha
              Positioned(
                top: 12,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login_nino');
                  },
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.teal, size: 22),
                  ),
                ),
              ),

              // Contenido central
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'assets/images/logo4.png',
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
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

              // Botón principal
              Positioned(
                bottom: 120,
                left: MediaQuery.of(context).size.width * 0.2,
                right: MediaQuery.of(context).size.width * 0.2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/menu');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EC8C6),
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

              // 🔹 PADRES: Abajo izquierda con etiqueta
              Positioned(
                bottom: 20,
                left: 10,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/login_padres');
                      },
                      child: const CircleAvatar(
                        radius: 28,
                        backgroundImage:
                            AssetImage('assets/images/user_icon.png'),
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

              // 🔹 URGENCIA: Abajo derecha con etiqueta encima
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
                      onTap: () {
                        Navigator.pushNamed(context, '/help');
                      },
                      child: const CircleAvatar(
                        radius: 28,
                        backgroundImage:
                            AssetImage('assets/images/emergency boton.jpg'),
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

  Widget _buildDot(Color color) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

// 🌊 Fondo animado de olas
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
    final double waveHeight = 30;
    final double waveSpeed = animationValue * 2 * pi;

    path.moveTo(0, size.height);

    for (double i = 0; i <= size.width; i++) {
      double y = sin((i / size.width * 2 * pi) + waveSpeed) * waveHeight +
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
