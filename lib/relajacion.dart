import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class RelajacionScreen extends StatefulWidget {
  const RelajacionScreen({super.key});

  @override
  State<RelajacionScreen> createState() => _RelajacionScreenState();
}

class _RelajacionScreenState extends State<RelajacionScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;
  late AudioPlayer _dingPlayer;

  bool _isPlaying = true;
  double _volume = 0.5;

  int totalBreaths = 5; // 🧘‍♂️ respiraciones por sesión
  int remainingBreaths = 5;

  @override
  void initState() {
    super.initState();

    // 🎵 Audio setup
    _audioPlayer = AudioPlayer();
    _dingPlayer = AudioPlayer();

    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.setVolume(_volume);
    _audioPlayer.play(AssetSource('sounds/inner-peace-339640.mp3'));

    // 🌀 Animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // ⏱️ Disminuir contador de respiraciones
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted && remainingBreaths > 0) {
          setState(() {
            remainingBreaths--;
          });
          if (remainingBreaths == 0) {
            _playDing();
            _controller.stop();
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    _dingPlayer.dispose();
    super.dispose();
  }

  void _playDing() {
    _dingPlayer.play(AssetSource('sounds/ding.mp3'));
  }

  void _toggleMusic() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _changeVolume(double value) {
    setState(() {
      _volume = value;
    });
    _audioPlayer.setVolume(_volume);
  }

  void _resetSession() {
    setState(() {
      remainingBreaths = totalBreaths;
    });
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌊 Fondo
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
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  'iBreath',
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: 'ADLaM Display',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  remainingBreaths > 0
                      ? 'Respira conmigo\n($remainingBreaths restantes)'
                      : '¡Sesión completada!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontFamily: 'ABeeZee',
                  ),
                ),
                const SizedBox(height: 30),

                // 🌀 Animación
                Expanded(
                  child: Center(
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.6, end: 1.0).animate(
                        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
                      ),
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 6,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'Inhala\nExhala',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontFamily: 'ABeeZee',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // 🔈 Volumen
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const Text(
                        'Volumen',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Slider(
                        value: _volume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: (_volume * 100).toInt().toString(),
                        activeColor: Colors.tealAccent,
                        onChanged: _changeVolume,
                      ),
                    ],
                  ),
                ),

                // 🎯 Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _audioPlayer.stop();
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Estoy mejor'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2EC8B9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                    if (remainingBreaths == 0)
                      ElevatedButton.icon(
                        onPressed: _resetSession,
                        icon: const Icon(Icons.replay),
                        label: const Text('Otra vez'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white24,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                  ],
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

// 🎨 Olas suaves
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
      double y = sin((i / size.width * 2 * pi) + waveSpeed) * waveHeight + size.height * 0.9;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawPath(path, Paint()..color = Colors.white.withOpacity(0.2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
