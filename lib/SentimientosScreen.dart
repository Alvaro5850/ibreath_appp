import 'package:flutter/material.dart';

class SentimientoScreen extends StatelessWidget {
  const SentimientoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      body: Column(
        children: [
          const SizedBox(height: 40),
          // Cabecera
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
          const SizedBox(height: 20),
          const Text(
            'iBreath',
            style: TextStyle(
              fontSize: 28,
              fontFamily: 'ADLaM Display',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '¿Cómo te sientes?',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'ABeeZee',
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),
          // Emociones
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2EC8B9),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: const Text('No lo sé'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
  onPressed: () {
    Navigator.pushNamed(context, '/mensaje_enviado');
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2EC8B9),
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
  ),
  child: const Text('Enviar'),
),

        ],
      ),
    );
  }

  static Widget _buildDot(Color color) {
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

  Widget _buildEmotion(String label, String imagePath) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imagePath),
          radius: 35,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}