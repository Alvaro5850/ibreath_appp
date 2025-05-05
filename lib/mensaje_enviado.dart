import 'package:flutter/material.dart';

class MensajeEnviadoScreen extends StatelessWidget {
  const MensajeEnviadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      body: Stack(
        children: [
          // 🔹 Icono home
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ),

          // 🔹 Iconos color arriba derecha
          Positioned(
            top: 42,
            right: 20,
            child: Row(
              children: [
                _buildDot(Colors.purple),
                const SizedBox(width: 6),
                _buildDot(Colors.yellow),
              ],
            ),
          ),

          // 🔹 Texto central
          const Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'iBreath',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'ADLaM Display',
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  '¡Mensaje enviado!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'ABeeZee',
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Mantén la calma',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'ABeeZee',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Imagen
          Positioned(
            bottom: 130,
            left: 40,
            right: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/images/calma.png', // reemplaza por el nombre real
                fit: BoxFit.cover,
                height: 250,
              ),
            ),
          ),

          // 🔹 Flecha atrás
          Positioned(
            bottom: 30,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
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
