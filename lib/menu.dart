import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF14749A),
        child: Stack(
          children: [
            // Cabecera común
            const Positioned(
              top: 40,
              left: 20,
              child: Icon(Icons.home, color: Colors.white, size: 32),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: Row(
                children: [
                  _buildDot(Colors.purple),
                  const SizedBox(width: 6),
                  _buildDot(Colors.yellow),
                ],
              ),
            ),
            const Positioned(
              top: 90,
              left: 160,
              child: Text(
                'iBreath',
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'ADLaM Display',
                  color: Colors.white,
                ),
              ),
            ),
            const Positioned(
              top: 140,
              left: 50,
              child: Text(
                '¿Qué te apetece?',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'ABeeZee',
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      color: Color(0x40000000),
                    ),
                  ],
                ),
              ),
            ),

            // Botones de opciones con imágenes
            Positioned(
              top: 200,
              left: 30,
              child: _buildMenuOption(
                context,
                'assets/images/relax.png',
                'Relajación',
                () {}, // Acción
              ),
            ),
            Positioned(
              top: 200,
              right: 30,
              child: _buildMenuOption(
                context,
                'assets/images/help.png',
                '¡Ayuda!',
                () {},
              ),
            ),
            Positioned(
              top: 400,
              left: 30,
              child: _buildMenuOption(
                context,
                'assets/images/story.png',
                'Cuenta Cuentos',
                () {},
              ),
            ),
            Positioned(
              top: 400,
              right: 30,
              child: _buildMenuOption(
                context,
                'assets/images/play.png',
                'Juega!',
                () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDot(Color color) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, String img, String label, VoidCallback onTap) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: AssetImage(img),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'ABeeZee',
          ),
        ),
      ],
    );
  }
}
