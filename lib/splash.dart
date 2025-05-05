import 'package:flutter/material.dart';

class SplashScreenWrapper extends StatelessWidget {
  const SplashScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFF14749A),
      child: Stack(
        children: [
          // 🔹 Elementos flotantes (home, puntos, íconos)
          const Positioned(
            top: 40,
            left: 20,
            child: Icon(Icons.home, color: Colors.white, size: 28),
          ),

          Positioned(
            top: 38,
            right: 20,
            child: Row(
              children: [
                _buildDot(Colors.purple),
                const SizedBox(width: 6),
                _buildDot(Colors.yellow),
              ],
            ),
          ),

          // 🔹 Contenido central: logo + título + subtítulo
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo2.jpg',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                const Text(
                  'iBreath',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ABeeZee',
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'EL RINCÓN TRANQUILO DE TU DÍA',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    letterSpacing: 1.3,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Botón ¡Vamos allá!
          Positioned(
            bottom: 100,
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/menu');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2EC8C6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  '¡Vamos allá!',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

          // 🔹 Icono de usuario abajo izquierda
          Positioned(
            bottom: 20,
            left: 20,
            child: CircleAvatar(
              radius: 28,
              backgroundImage: AssetImage('assets/images/user_icon.png'),
            ),
          ),

          // 🔹 Botón de emergencia abajo derecha
          // 🔹 Botón de emergencia abajo derecha
Positioned(
  bottom: 20,
  right: 20,
  child: GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, '/help');
    },
    child: CircleAvatar(
      radius: 26,
      backgroundImage: AssetImage('assets/images/emergency boton.jpg'),
    ),
  ),
),

        ],
      ),
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
