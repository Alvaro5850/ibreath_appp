import 'dart:math';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'db/session.dart';

class RegistroHijoScreen extends StatefulWidget {
  const RegistroHijoScreen({Key? key}) : super(key: key);

  @override
  _RegistroHijoScreenState createState() => _RegistroHijoScreenState();
}

class _RegistroHijoScreenState extends State<RegistroHijoScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  String mensaje = '';
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
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

    final padreId = Session.getParentId();

    if (padreId == null) {
      setState(() {
        mensaje = '⚠️ Debes iniciar sesión como padre primero.';
      });
      return;
    }

    try {
      final nuevoId = await AppDatabase.instance.createChild(
        nombre: nombre,
        edad: edad,
        parentId: padreId,
      );

      setState(() {
        mensaje = '✅ Hijo registrado correctamente.';
      });

      _nombreController.clear();
      _edadController.clear();
    } catch (e, stack) {
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Registrar Nuevo Hijo',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => CustomPaint(
              painter: WavePainter(_controller.value),
              child: Container(),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 40),
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
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    final Paint backgroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0B486B), Color(0xFF3B8686)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(rect);

    canvas.drawRect(rect, backgroundPaint);

    final Paint wavePaint = Paint()..color = Colors.white.withOpacity(0.2);
    final path = Path();
    const double waveHeight = 30;
    final double waveSpeed = animationValue * 2 * pi;

    path.moveTo(0, size.height);
    for (double i = 0; i <= size.width; i++) {
      final y = sin((i / size.width * 2 * pi) + waveSpeed) * waveHeight + size.height * 0.9;
      path.lineTo(i, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
