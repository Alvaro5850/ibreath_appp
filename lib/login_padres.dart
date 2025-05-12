// lib/screens/login_padres.dart

import 'package:flutter/material.dart';
import '../db/padres_db.dart';
import 'registro_padres.dart';
import 'recuperar_contrasena.dart';

class LoginPadresScreen extends StatefulWidget {
  const LoginPadresScreen({Key? key}) : super(key: key);

  @override
  _LoginPadresScreenState createState() => _LoginPadresScreenState();
}

class _LoginPadresScreenState extends State<LoginPadresScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String error = '';

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final padre = await PadresDB.instance.getPadre(email, password);
    if (padre != null) {
      // Navegar a la pantalla principal o de emociones
      Navigator.pushReplacementNamed(context, '/ver_emociones');
    } else {
      setState(() {
        error = 'Email o contraseña incorrectos';
      });
    }
  }

  void _navigateToRegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegistroPadresScreen()),
    );
  }

  void _navigateToRecuperarContrasena() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecuperarContrasenaScreen()),
    );
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
              onPressed: _login,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Iniciar sesión'),
            ),
            TextButton(
              onPressed: _navigateToRegistro,
              child: const Text('¿No tienes cuenta? Regístrate'),
            ),
            TextButton(
              onPressed: _navigateToRecuperarContrasena,
              child: const Text('¿Olvidaste tu contraseña?'),
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
