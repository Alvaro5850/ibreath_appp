import 'dart:math';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'db/session.dart';

class SentimientoScreen extends StatefulWidget {
  const SentimientoScreen({Key? key}) : super(key: key);

  @override
  State<SentimientoScreen> createState() => _SentimientoScreenState();
}

class _SentimientoScreenState extends State<SentimientoScreen>
    with SingleTickerProviderStateMixin {
  String? emocionSeleccionada;
  String? emojiMostrado;
  bool mostrarEmoji = false;
  double emojiTopOffset = 0;

  late AnimationController _controller;

  final Map<String, String> emojiMap = {
    'Contento': '😊',
    'Tranquilo': '😌',
    'Triste': '😢',
    'Enfadado': '😠',
    'Asustado': '😱',
    'Nervioso': '😬',
  };

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

  @override
  Widget build(BuildContext context) {
    final hijoId = Session.hijoId;
    if (hijoId == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF14749A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No hay perfil activo.',
                  style: TextStyle(color: Colors.white)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/hijos_padres', (route) => false);
                },
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      );
    }

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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home, color: Colors.white),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/',
                            (route) => false,
                          );
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
                    fontFamily: 'ADLaM Display',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  '¿Cómo te sientes?',
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'ABeeZee',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildEmotion('Contento', 'assets/images/contento.png'),
                    _buildEmotion('Tranquilo', 'assets/images/tranquilo.png'),
                    _buildEmotion('Triste', 'assets/images/triste.png'),
                    _buildEmotion('Enfadado', 'assets/images/enfadado.png'),
                    _buildEmotion('Asustado', 'assets/images/asustado.png'),
                    _buildEmotion('Nervioso', 'assets/images/nervioso.png'),
                  ],
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      emocionSeleccionada = 'No lo sé';
                    });
                    await AppDatabase.instance.guardarEmocion(
                      hijoId: hijoId,
                      emocion: 'No lo sé',
                    );
                    Navigator.pushNamed(context, '/mensaje_enviado');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7489A0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('No lo sé'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (emocionSeleccionada != null) {
                      await AppDatabase.instance.guardarEmocion(
                        hijoId: hijoId,
                        emocion: emocionSeleccionada!,
                      );
                      Navigator.pushNamed(context, '/mensaje_enviado');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Por favor, selecciona una emoción')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2EC8B9),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: const Text('Enviar'),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotion(String label, String imagePath) {
    final isSelected = emocionSeleccionada == label;
    return GestureDetector(
      onTap: () async {
        setState(() {
          emocionSeleccionada = label;
          emojiMostrado = emojiMap[label];
          mostrarEmoji = true;
          emojiTopOffset = -40;
        });

        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          setState(() {
            mostrarEmoji = false;
          });
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: isSelected ? 1.2 : 1.0,
            curve: Curves.elasticOut,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(imagePath),
                  radius: isSelected ? 42 : 36,
                  backgroundColor:
                      isSelected ? Colors.white : Colors.transparent,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (isSelected)
            AnimatedPositioned(
              top: mostrarEmoji ? emojiTopOffset : 0,
              duration: const Duration(milliseconds: 300),
              child: AnimatedOpacity(
                opacity: mostrarEmoji ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  emojiMostrado ?? '',
                  style: const TextStyle(fontSize: 30),
                ),
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
      final y =
          sin((i / size.width * 2 * pi) + waveSpeed) * waveHeight + size.height * 0.9;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.white.withOpacity(0.2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
