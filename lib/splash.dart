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
          // 🔹 Título "iBreath" arriba
          Positioned(
            top: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'iBreath',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: 'ABeeZee',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // 🔹 Logo y subtítulo centrados
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 402,
                  height: 322,
                ),
                const SizedBox(height: 16),
                const Text(
                  '',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ABeeZee',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'ABeeZee',
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Botón ¡Vamos allá!
          Positioned(
            bottom: 80,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
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
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),

          // 🔹 Icono de usuario abajo izquierda
          Positioned(
            bottom: 20,
            left: 20,
            child: CircleAvatar(
              radius: 32,
              backgroundImage: AssetImage('assets/images/user_icon.png'),
            ),
          ),

          // 🔹 Botón de emergencia abajo derecha
          Positioned(
            bottom: 20,
            right: 20,
            child: CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage('assets/images/emergency boton.jpg'),
            ),
          ),

          // 🔹 Iconos de colores arriba derecha
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

          // 🔹 Icono "home" arriba izquierda
          Positioned(
            top: 40,
            left: 20,
            child: const Icon(Icons.home, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
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
}
