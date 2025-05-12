import 'package:flutter/material.dart';
import 'db_helper.dart'; // Asegúrate de importar tu helper

class SentimientoScreen extends StatefulWidget {
  const SentimientoScreen({super.key});

  @override
  State<SentimientoScreen> createState() => _SentimientoScreenState();
}

class _SentimientoScreenState extends State<SentimientoScreen> {
  String? emocionSeleccionada;

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
            onPressed: () {
              setState(() {
                emocionSeleccionada = 'No lo sé';
              });
              DBHelper.guardarEmocion('No lo sé');
              Navigator.pushNamed(context, '/mensaje_enviado');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7489A0),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: const Text('No lo sé'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              if (emocionSeleccionada != null) {
                DBHelper.guardarEmocion(emocionSeleccionada!);
                Navigator.pushNamed(context, '/mensaje_enviado');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Por favor, selecciona una emoción')),
                );
              }
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
    final isSelected = emocionSeleccionada == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          emocionSeleccionada = label;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: isSelected ? 40 : 35,
            backgroundColor: isSelected ? Colors.white : Colors.transparent,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
