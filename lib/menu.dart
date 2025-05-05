import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      body: SafeArea(
        child: Stack(
          children: [
            // 🔹 Home
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

            // 🔹 Dots derecha arriba
            Positioned(
              top: 22,
              right: 20,
              child: Row(
                children: [
                  _buildDot(Colors.purple),
                  const SizedBox(width: 6),
                  _buildDot(Colors.yellow),
                ],
              ),
            ),

            // 🔹 Contenido principal
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'iBreath',
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: 'ADLaM Display',
                        color: Colors.white,
                      ),
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
                          Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            color: Color(0x40000000),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 🔹 Opciones con GridView
                  Expanded(
  child: GridView.count(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    crossAxisCount: 2,
    mainAxisSpacing: 1, // 🔽 MENOS ESPACIO ENTRE FILAS
    crossAxisSpacing: 2,
    childAspectRatio: 0.85, // 🔄 HACE CADA ELEMENTO MÁS ALTO
    children: [
      _buildMenuOption(context, 'assets/images/relax.jpg', 'Relajación', () {}),
      _buildMenuOption(context, 'assets/images/ayuda.jpg', '¡Ayuda!', () {
        Navigator.pushNamed(context, '/help');
      }),
      _buildMenuOption(context, 'assets/images/cuento.jpg', 'Cuenta Cuentos', () {}),
      _buildMenuOption(context, 'assets/images/puzzle.jpg', 'Juega!', () {}),
    ],
  ),
),

                ],
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
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: AssetImage(img),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontFamily: 'ABeeZee',
          ),
        ),
      ],
    );
  }
}
