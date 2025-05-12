import 'package:flutter/material.dart';

class MensajeEnviadoScreen extends StatelessWidget {
  const MensajeEnviadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      body: SafeArea(
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
                  Row(
                    children: [
                      _buildDot(Colors.purple),
                      const SizedBox(width: 6),
                      _buildDot(Colors.yellow),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 TÍTULOS
            const Text(
              'iBreath',
              style: TextStyle(
                fontSize: 26,
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
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 IMAGEN AJUSTADA
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

            // 🔹 Botón volver
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 20),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
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
