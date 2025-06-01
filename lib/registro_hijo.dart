// lib/registro_hijo.dart

import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'db/session.dart';

class RegistroHijoScreen extends StatefulWidget {
  const RegistroHijoScreen({Key? key}) : super(key: key);

  @override
  _RegistroHijoScreenState createState() => _RegistroHijoScreenState();
}

class _RegistroHijoScreenState extends State<RegistroHijoScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  String mensaje = '';

  @override
  void dispose() {
    _nombreController.dispose();
    _edadController.dispose();
    super.dispose();
  }

  Future<void> _registrarHijo() async {
    final nombre = _nombreController.text.trim();
    final edadText = _edadController.text.trim();

    if (nombre.isEmpty || edadText.isEmpty) {
      setState(() {
        mensaje = '⚠️ Completa todos los campos.';
      });
      return;
    }

    final edad = int.tryParse(edadText);
    if (edad == null) {
      setState(() {
        mensaje = '⚠️ Ingresa una edad válida.';
      });
      return;
    }

    // 1) Obtenemos el padre logueado:
    final padreId = Session.getParentId();
    print('▷ [DEBUG] padreId=' + (padreId?.toString() ?? 'null'));

    if (padreId == null) {
      setState(() {
        mensaje = '⚠️ Debes iniciar sesión como padre primero.';
      });
      return;
    }

    try {
      // 2) Intentamos insertar en la tabla hijos:
      final nuevoId = await AppDatabase.instance.createChild(
        nombre: nombre,
        edad: edad,
        parentId: padreId,
      );
      print('▷ [DEBUG] createChild retornó ID=$nuevoId');

      setState(() {
        mensaje = '✅ Hijo registrado correctamente.';
      });

      // Opcional: limpiar los campos
      _nombreController.clear();
      _edadController.clear();
    } catch (e, stack) {
      // 3) Si hay excepción, imprimimos detalle para entender qué falla:
      print('▷ [ERROR] Al insertar hijo: $e');
      print(stack);
      setState(() {
        mensaje = '⚠️ Ocurrió un error al registrar el hijo.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14749A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Registrar Nuevo Hijo',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nombre',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.child_care, color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _edadController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Edad',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.calendar_today, color: Colors.white54),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _registrarHijo,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2EC8B9),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Guardar Hijo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'ABeeZee',
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (mensaje.isNotEmpty)
              Text(
                mensaje,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'ABeeZee',
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
