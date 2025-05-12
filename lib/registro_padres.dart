// lib/screens/registro_padres.dart

import 'package:flutter/material.dart';
import '../db/padres_db.dart';

class RegistroPadresScreen extends StatefulWidget {
  const RegistroPadresScreen({Key? key}) : super(key: key);

  @override
  _RegistroPadresScreenState createState() => _RegistroPadresScreenState();
}

class _RegistroPadresScreenState extends State<RegistroPadresScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String mensaje = '';

  void _registrar() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      await PadresDB.instance.createPadre(email, password);
      setState(() {
        mensaje = 'Registro exitoso. Ahora puedes iniciar sesión.';
      });
    } catch (e) {
      setState(() {
        mensaje = 'Error: El email ya está registrado.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14749A),
        title: const Text('Registro Padres', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registrar,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Registrarse'),
            ),
            if (mensaje.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(mensaje, style: const TextStyle(color: Colors.white)),
              )
          ],
        ),
      ),
    );
  }
}
