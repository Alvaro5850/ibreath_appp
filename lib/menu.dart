import 'dart:math';
import 'package:flutter/material.dart';
import 'help_screen.dart';
import 'relajacion.dart';
import 'cuentos.dart'; 

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with SingleTickerProviderStateMixin {
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

  void _navigateWithTransition(BuildContext context, Widget page) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const beginOffset = Offset(1.0, 0.0);
        const endOffset = Offset.zero;
        final tween = Tween(begin: beginOffset, end: endOffset).chain(CurveTween(curve: Curves.easeInOut));
        final fade = Tween<double>(begin: 0.0, end: 1.0);
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation.drive(fade),
            child: child,
          ),
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                Positioned(
                  top: 20,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.home, color: Colors.white, size: 32),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    },
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          'iBreath',
                          style: TextStyle(fontSize: 28, fontFamily: 'ADLaM Display', color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Center(
                        child: Text(
                          '¿Qué te apetece?',
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: 'ABeeZee',
                            color: Colors.white,
                            shadows: [
                              Shadow(offset: Offset(0, 4), blurRadius: 4, color: Color(0x40000000)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          crossAxisCount: 2,
                          mainAxisSpacing: 1,
                          crossAxisSpacing: 2,
                          childAspectRatio: 0.85,
                          children: [
                            _buildAnimatedOption('assets/images/relax.jpg', 'Relajación', () {
                              _navigateWithTransition(context, const RelajacionScreen());
                            }),
                            _buildAnimatedOption('assets/images/ayuda.jpg', '¡Ayuda!', () {
                              _navigateWithTransition(context, const HelpScreen());
                            }),
                            _buildAnimatedOption('assets/images/cuento.jpg', 'Cuenta Cuentos', () {
                              _navigateWithTransition(context, const CuentoScreen());
                            }),
                            _buildAnimatedOption('assets/images/puzzle.jpg', 'Juega!', () {
                              Navigator.pushNamed(context, '/jugar_puzzle');
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedOption(String img, String label, VoidCallback onTap) {
    return _AnimatedMenuButton(img: img, label: label, onTap: onTap);
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

class _AnimatedMenuButton extends StatefulWidget {
  final String img;
  final String label;
  final VoidCallback onTap;

  const _AnimatedMenuButton({
    required this.img,
    required this.label,
    required this.onTap,
  });

  @override
  State<_AnimatedMenuButton> createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<_AnimatedMenuButton> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.92);
  void _onTapUp(_) {
    setState(() => _scale = 1.0);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))],
                image: DecorationImage(image: AssetImage(widget.img), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'ABeeZee',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
