import 'package:flutter/material.dart';
import 'ver_emociones.dart';

class LoginPadresScreen extends StatefulWidget {
  const LoginPadresScreen({super.key});

  @override
  State<LoginPadresScreen> createState() => _LoginPadresScreenState();
}

class _LoginPadresScreenState extends State<LoginPadresScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String error = '';

  void _login() {
    final usuario = _usuarioController.text;
    final password = _passwordController.text;

    if (usuario == 'padre' && password == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerEmocionesScreen()),
      );
    } else {
      setState(() {
        error = 'Usuario o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14749A),
        title: const Text('Acceso Padres', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _usuarioController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Entrar'),
            ),
            if (error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(error, style: const TextStyle(color: Colors.red)),
              )
          ],
        ),
      ),
    );
  }
}
