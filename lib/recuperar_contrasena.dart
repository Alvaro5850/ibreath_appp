// lib/screens/recuperar_contrasena.dart

import 'package:flutter/material.dart';
import '../db/padres_db.dart';

class RecuperarContrasenaScreen extends StatefulWidget {
  const RecuperarContrasenaScreen({Key? key}) : super(key: key);

  @override
  _RecuperarContrasenaScreenState createState() => _RecuperarContrasenaScreenState();
}

class _RecuperarContrasenaScreenState extends State<RecuperarContrasenaScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nuevaContrasenaController = TextEditingController();
  String mensaje = '';

  void _recuperarContrasena() async {
    final email = _emailController.text.trim();
    final nuevaContrasena = _nuevaContrasenaController.text;

    final padre = await PadresDB.instance.getPadreByEmail(email);
    if (padre != null) {
      await PadresDB.instance.updatePassword(email, nuevaContrasena);
      setState(() {
        mensaje = 'Contraseña actualizada correctamente.';
      });
    } else {
      setState(() {
        mensaje = 'Email no encontrado.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14749A),
        title: const Text('Recuperar Contraseña', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Introduce tu email y nueva contraseña:',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nuevaContrasenaController,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                fillColor: Colors.white,
                filled: true,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _recuperarContrasena,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2EC8B9),
              ),
              child: const Text('Actualizar contraseña'),
            ),
            const SizedBox(height: 20),
            Text(
              mensaje,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
