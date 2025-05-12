import 'package:flutter/material.dart';
import 'db_helper.dart';

class VerEmocionesScreen extends StatefulWidget {
  const VerEmocionesScreen({super.key});

  @override
  State<VerEmocionesScreen> createState() => _VerEmocionesScreenState();
}

class _VerEmocionesScreenState extends State<VerEmocionesScreen> {
  List<Map<String, dynamic>> emociones = [];

  @override
  void initState() {
    super.initState();
    cargarEmociones();
  }

  Future<void> cargarEmociones() async {
    final datos = await DBHelper.obtenerEmociones();
    setState(() {
      emociones = datos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14749A),
        title: const Text('Emociones del niño', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: emociones.length,
        itemBuilder: (context, index) {
          final emocion = emociones[index];
          return ListTile(
            title: Text(
              emocion['emocion'],
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              emocion['timestamp'],
              style: const TextStyle(color: Colors.white70),
            ),
          );
        },
      ),
    );
  }
}
