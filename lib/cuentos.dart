import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class CuentoScreen extends StatefulWidget {
  const CuentoScreen({super.key});

  @override
  State<CuentoScreen> createState() => _CuentoScreenState();
}

class _CuentoScreenState extends State<CuentoScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AudioPlayer _player;

  final List<Map<String, String>> _cuentos = [
    {
      'titulo': 'El León y el Ratón',
      'archivo': 'sounds/05100087.mp3',
      'imagen': 'assets/images/cuento.jpg',
    },
    {
      'titulo': 'La Bella Durmiente',
      'archivo': 'sounds/1 LA BELLA DURMIENTE.mp3',
      'imagen': 'assets/images/bella1.jpg',
    },
    {
      'titulo': 'Peter Pan y el Gran Jefe',
      'archivo': 'sounds/5 PETER PAN Y EL GRAN JEFE.mp3',
      'imagen': 'assets/images/peterpan.jpg',
    },
    {
      'titulo': 'Los 2 Conejos',
      'archivo': 'sounds/4 LOS 2 CONEJOS.mp3',
      'imagen': 'assets/images/conejos.jpg',
    },
  ];

  int _cuentoSeleccionado = 0;
  bool _isPlaying = false;
  double _volume = 0.5;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = const Duration(minutes: 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5))..repeat();
    _player = AudioPlayer();
    _player.setReleaseMode(ReleaseMode.loop);
    _player.setVolume(_volume);

    _player.onDurationChanged.listen((d) => setState(() => _totalDuration = d));
    _player.onPositionChanged.listen((p) => setState(() => _currentPosition = p));
  }

  @override
  void dispose() {
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play(AssetSource(_cuentos[_cuentoSeleccionado]['archivo']!));
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  Future<void> _seekBy(Duration offset) async {
    final newPosition = _currentPosition + offset;
    await _player.seek(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  Future<void> _restartPlayback() async {
    await _player.seek(Duration.zero);
  }

  void _changeVolume(double value) {
    setState(() => _volume = value);
    _player.setVolume(_volume);
  }

  void _seleccionarCuento(int index) async {
    if (_isPlaying) await _player.stop();
    setState(() {
      _cuentoSeleccionado = index;
      _isPlaying = false;
      _currentPosition = Duration.zero;
    });
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final cuento = _cuentos[_cuentoSeleccionado];

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => CustomPaint(
              painter: _WavePainter(_controller.value),
              child: Container(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  'iBreath',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ADLaM Display',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Elige y escucha tu cuento',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontFamily: 'ABeeZee',
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _cuentos.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        onTap: () => _seleccionarCuento(i),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(_cuentos[i]['imagen']!),
                              backgroundColor: i == _cuentoSeleccionado ? Colors.white : Colors.white30,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _cuentos[i]['titulo']!,
                              style: TextStyle(
                                fontSize: 12,
                                color: i == _cuentoSeleccionado ? Colors.white : Colors.white70,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),

                Center(
                  child: AnimatedScale(
                    scale: _isPlaying ? 1.0 : 0.95,
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(cuento['imagen']!),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _AnimatedIconButton(icon: Icons.replay_10, onPressed: () => _seekBy(const Duration(seconds: -10))),
                    const SizedBox(width: 8),
                    _AnimatedIconButton(icon: Icons.restart_alt, onPressed: _restartPlayback),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _togglePlayback,
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text(_isPlaying ? 'Pausar' : 'Escuchar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2EC8B9),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _AnimatedIconButton(icon: Icons.forward_10, onPressed: () => _seekBy(const Duration(seconds: 10))),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  child: Column(
                    children: [
                      Slider(
                        value: _currentPosition.inMilliseconds.clamp(0, _totalDuration.inMilliseconds).toDouble(),
                        min: 0,
                        max: _totalDuration.inMilliseconds.toDouble(),
                        onChanged: (value) async {
                          final newPosition = Duration(milliseconds: value.toInt());
                          await _player.seek(newPosition);
                          setState(() => _currentPosition = newPosition);
                        },
                        activeColor: Colors.tealAccent,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(_currentPosition), style: const TextStyle(color: Colors.white70)),
                          Text(_formatDuration(_totalDuration), style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      const Text('Volumen', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      Slider(
                        value: _volume,
                        min: 0,
                        max: 1,
                        divisions: 10,
                        onChanged: _changeVolume,
                        activeColor: Colors.tealAccent,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _player.stop();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white24,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
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

    canvas.drawPath(path, Paint()..color = Colors.white.withOpacity(0.2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _AnimatedIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _AnimatedIconButton({required this.icon, required this.onPressed});

  @override
  State<_AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<_AnimatedIconButton> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.9);
  void _onTapUp(_) {
    setState(() => _scale = 1.0);
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        child: Icon(widget.icon, color: Colors.white, size: 32),
      ),
    );
  }
}
