// lib/registro_hijo.dart

import 'package:flutter/material.dart';
import 'db_helper.dart';

class RegistroHijoScreen extends StatefulWidget {
  const RegistroHijoScreen({Key? key}) : super(key: key);

  @override
  _RegistroHijoScreenState createState() => _RegistroHijoScreenState();
}

class _RegistroHijoScreenState extends State<RegistroHijoScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  String error = '';

  Future<void> _registrarHijo() async {
    final nombre = _nombreController.text.trim();
    final edadStr = _edadController.text.trim();
    if (nombre.isEmpty || edadStr.isEmpty) {
      setState(() {
        error = 'Por favor completa ambos campos';
      });
      return;
    }

    final edad = int.tryParse(edadStr);
    if (edad == null) {
      setState(() {
        error = 'La edad debe ser un número válido';
      });
      return;
    }

    // Insertamos en la tabla “hijos”
    await AppDatabase.instance.createChild(
      nombre: nombre,
      edad: edad,
    );

    // Volvemos a la pantalla de selección de perfil:
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14749A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Registrar Hijo', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del hijo',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.person, color: Colors.white54),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _edadController,
              decoration: const InputDecoration(
                labelText: 'Edad',
                labelStyle: TextStyle(color: Colors.white70),
                prefixIcon: Icon(Icons.cake, color: Colors.white54),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(30))),
              ),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrarHijo,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2EC8B9),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                'Guardar Hijo',
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
