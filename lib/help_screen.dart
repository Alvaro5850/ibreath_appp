import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();

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
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playComfortMessage() async {
    await _audioPlayer.play(AssetSource('sounds/comfort.mp3')); // asegúrate de tener este archivo
  }

  void _handleYesPressed() async {
    _playComfortMessage();

    // Esperar un momento para que el niño perciba el mensaje
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pushNamed(context, '/sentimiento');
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

          // 📦 Contenido principal
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 🔝 Superior
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/login_nino'),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.teal, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                const Text(
                  'iBreath',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ADLaM Display',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '¿Necesitas ayuda?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'ABeeZee',
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 30),

                // 🌈 Imagen emocional amigable
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Image.asset(
                    'assets/images/relajacion_sin_fondo.png', // asegúrate de usar un nombre válido en assets
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 40),

                // 🟢 Botón Sí
                ElevatedButton.icon(
                  onPressed: _handleYesPressed,
                  icon: const Icon(Icons.favorite, size: 26),
                  label: const Text('Sí, necesito ayuda', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EC8C6),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                ),

                const SizedBox(height: 20),

                // ⚪ Botón No
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.thumb_up_alt_rounded),
                  label: const Text('No, estoy bien', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                ),

                const Spacer(),

                // 🔻 Emergencia y volver
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('assets/images/emergency_boton.jpg'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
      final y = sin((i / size.width * 2 * pi) + waveSpeed) * waveHeight + size.height * 0.9;
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
