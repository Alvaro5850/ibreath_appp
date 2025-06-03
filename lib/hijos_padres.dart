import 'dart:math';
import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'db/session.dart';

class HijosPadresScreen extends StatefulWidget {
  final bool modoConsulta;

  const HijosPadresScreen({Key? key, this.modoConsulta = false}) : super(key: key);

  @override
  _HijosPadresScreenState createState() => _HijosPadresScreenState();
}

class _HijosPadresScreenState extends State<HijosPadresScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> hijos = [];
  int? padreId;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    padreId = Session.getParentId();
    _cargarHijos();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _cargarHijos() async {
    if (padreId != null) {
      final lista = await AppDatabase.instance.getChildrenByParent(padreId!);
      setState(() {
        hijos = lista;
      });
    } else {
      setState(() {
        hijos = [];
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
        title: const Text('Tus Hijos', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: hijoIdNullOrEmpty(padreId, hijos),
            ),
          ),
        ],
      ),
      floatingActionButton: (!widget.modoConsulta && padreId != null)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registro_hijo').then((_) {
                  _cargarHijos();
                });
              },
              backgroundColor: const Color(0xFF2EC8B9),
              child: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Añadir nuevo hijo',
            )
          : null,
    );
  }

  Widget hijoIdNullOrEmpty(int? padre, List<Map<String, dynamic>> listaHijos) {
    if (padre == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock, size: 60, color: Colors.white70),
            const SizedBox(height: 16),
            const Text(
              'Primero debes iniciar sesión como padre.',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2EC8B9),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text('Ir al inicio'),
            ),
          ],
        ),
      );
    }

    if (listaHijos.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'No tienes hijos registrados.',
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 20),
            if (!widget.modoConsulta)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/registro_hijo').then((_) {
                    _cargarHijos();
                  });
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Añadir hijo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2EC8B9),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 80),
      itemCount: listaHijos.length,
      itemBuilder: (context, index) {
        final hijo = listaHijos[index];
        final id = hijo[AppDatabase.columnId] as int;
        final nombre = hijo[AppDatabase.columnNombre] as String;
        final edad = hijo[AppDatabase.columnEdad] as int;

        return Card(
          color: Colors.white.withOpacity(0.15),
          margin: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF2EC8B9),
              radius: 24,
              child: Icon(Icons.emoji_emotions, color: Colors.white),
            ),
            title: Text(
              nombre,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Edad: $edad',
              style: const TextStyle(color: Colors.white70),
            ),
            onTap: () {
              Session.setHijoId(id);
              if (widget.modoConsulta) {
                Navigator.pushReplacementNamed(context, '/ver_emociones');
              } else {
                Session.setMensajeTemporal('Perfil cambiado correctamente');
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              }
            },
          ),
        );
      },
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
