import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
              icon: const Icon(Icons.home, color: Colors.white, size: 28),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
            ),
          ),

          // 🔹 Título "iBreath"
          const Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'iBreath',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // 🔹 Emergencia
          const Positioned(
            top: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '¿Necesitas ayuda?',
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'ABeeZee',
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // 🔹 Botón SI
          Positioned(
            top: 230,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
  Navigator.pushNamed(context, '/sentimiento');
},

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EC8C6),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(120, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('SI', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),

          // 🔹 Botón NO
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.3),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(120, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('NO', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),

          // 🔹 Botón emergencia rojo
          Positioned(
            bottom: 20,
            left: MediaQuery.of(context).size.width / 2 - 28,
            child: CircleAvatar(
              radius: 28,
              backgroundImage: const AssetImage('assets/images/emergency boton.jpg'),
            ),
          ),

          // 🔹 Flecha volver
          Positioned(
            bottom: 20,
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
}
