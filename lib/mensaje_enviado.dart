import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';

class MensajeEnviadoScreen extends StatefulWidget {
  const MensajeEnviadoScreen({super.key});

  @override
  State<MensajeEnviadoScreen> createState() => _MensajeEnviadoScreenState();
}

class _MensajeEnviadoScreenState extends State<MensajeEnviadoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat();

    _player = AudioPlayer()
      ..setReleaseMode(ReleaseMode.loop)
      ..play(AssetSource('sounds/relax.mp3'));
  }

  @override
  void dispose() {
    _controller.dispose();
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => CustomPaint(
              painter: WavePainter(_controller.value),
              child: Container(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        },
                      ),
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.teal, size: 22),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'iBreath',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'ADLaM Display',
                  ),
                ),

                const SizedBox(height: 20),

                Lottie.asset(
                  'assets/animations/beating_heart.json',
                  height: 180,
                  repeat: true,
                  animate: true,
                ),

                const SizedBox(height: 10),

                const Text(
                  '¡Mensaje enviado!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ABeeZee',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tus personas de confianza\nya fueron notificadas 💌',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'ABeeZee',
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Respira suave... todo está bien ',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'ABeeZee',
                    color: Colors.white60,
                  ),
                ),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/calma.png',
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const Spacer(),

                ElevatedButton.icon(
                  onPressed: () {
                    _player.stop();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.favorite),
                  label: const Text('Volver a respirar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 3,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final Paint backgroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0B486B), Color(0xFF3B8686)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    canvas.drawRect(rect, backgroundPaint);

    final Paint wavePaint = Paint()..color = Colors.white.withOpacity(0.2);
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
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
