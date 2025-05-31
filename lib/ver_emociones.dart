// lib/ver_emociones.dart

import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'db/session.dart';

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
    _cargarEmociones();
  }

  Future<void> _cargarEmociones() async {
    final hijoId = Session.hijoId;
    if (hijoId == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      return;
    }
    final datos = await AppDatabase.instance.obtenerEmocionesPorHijo(hijoId);
    setState(() {
      emociones = datos;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hijoId = Session.hijoId;
    if (hijoId == null) {
  return Scaffold(
    backgroundColor: Color(0xFF14749A),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('No hay perfil activo.', style: TextStyle(color: Colors.white)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, '/hijos_padres', (route) => false);
            },
            child: Text('Volver'),
          ),
        ],
      ),
    ),
  );
}


    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14749A),
        title: Text(
          'Emociones de tu hijo',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: emociones.isEmpty
          ? const Center(
              child: Text(
                'Aún no hay emociones registradas.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: emociones.length,
              itemBuilder: (context, index) {
                final emocional = emociones[index];
                final texto = emocional[AppDatabase.columnEmocion] as String;
                final fecha = emocional[AppDatabase.columnTimestamp] as String;
                return ListTile(
                  title: Text(
                    texto,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    fecha,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  leading: texto == 'Emergencia'
                      ? const Icon(Icons.warning, color: Colors.redAccent)
                      : const Icon(Icons.emoji_emotions, color: Colors.white70),
                );
              },
            ),
    );
  }
}
