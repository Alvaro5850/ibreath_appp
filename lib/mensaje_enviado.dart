import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

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
      ..play(AssetSource('sounds/relax.mp3')); // 🟡 Asegúrate de tener el audio
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
                // 🔹 CABECERA
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
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'ADLaM Display',
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '¡Mensaje enviado!',
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'ABeeZee',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mantén la calma',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'ABeeZee',
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 30),

                // 🖼 Imagen de calma
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset(
                      'assets/images/calma.png',
                      height: 230,
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
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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

// 🌊 Fondo animado
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
      final y = sin((i / size.width * 2 * pi) + waveSpeed) * waveHeight + size.height * 0.9;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.white.withOpacity(0.2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
