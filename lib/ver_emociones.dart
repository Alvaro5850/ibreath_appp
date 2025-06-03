import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db_helper.dart';
import '../db/session.dart';

class VerEmocionesScreen extends StatefulWidget {
  const VerEmocionesScreen({Key? key}) : super(key: key);

  @override
  State<VerEmocionesScreen> createState() => _VerEmocionesScreenState();
}

class _VerEmocionesScreenState extends State<VerEmocionesScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> emociones = [];
  int? hijoId;
  int? padreId;
  DateTime? fechaFiltrada;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    hijoId = Session.getHijoId();
    padreId = Session.getParentId();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    if (hijoId != null) {
      _cargarEmociones(hijoId!);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _cargarEmociones(int idHijo) async {
    final datos = await AppDatabase.instance.obtenerEmocionesPorHijo(idHijo);
    setState(() {
      emociones = datos;
    });
  }

  Future<void> _abrirCalendario() async {
    final hoy = DateTime.now();
    final seleccion = await showDatePicker(
      context: context,
      initialDate: fechaFiltrada ?? hoy,
      firstDate: DateTime(hoy.year - 2),
      lastDate: DateTime(hoy.year + 2),
    );
    if (seleccion != null) {
      setState(() {
        fechaFiltrada = seleccion;
      });
    }
  }

  String _formatearFechaISO(String isoString) {
    try {
      final fecha = DateTime.parse(isoString);
      return DateFormat('dd/MM/yyyy – HH:mm').format(fecha);
    } catch (_) {
      return isoString;
    }
  }

  Color _colorIcono(String emocion) {
    switch (emocion.toLowerCase()) {
      case 'emergencia':
        return Colors.redAccent;
      case 'triste':
        return Colors.blueAccent;
      case 'enfadado':
        return Colors.orangeAccent;
      case 'tranquilo':
        return Colors.greenAccent;
      case 'contento':
        return Colors.yellowAccent;
      case 'asustado':
        return Colors.purpleAccent;
      default:
        return Colors.white70;
    }
  }

  IconData _iconoEmocion(String emocion) {
    switch (emocion.toLowerCase()) {
      case 'emergencia':
        return Icons.warning_amber_rounded;
      case 'triste':
        return Icons.sentiment_dissatisfied;
      case 'enfadado':
        return Icons.sentiment_very_dissatisfied;
      case 'tranquilo':
        return Icons.sentiment_satisfied;
      case 'contento':
        return Icons.sentiment_very_satisfied;
      case 'asustado':
        return Icons.sentiment_neutral;
      default:
        return Icons.emoji_emotions;
    }
  }

  Widget _buildResumenEmociones(List<Map<String, dynamic>> lista) {
    final Map<String, int> conteo = {};

    for (var emocion in lista) {
      final raw = emocion[AppDatabase.columnEmocion];
      if (raw == null || raw.toString().trim().isEmpty) continue;

      final texto = raw.toString().toLowerCase();
      conteo[texto] = (conteo[texto] ?? 0) + 1;
    }

    return conteo.isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: conteo.entries.map((entry) {
                final icon = _iconoEmocion(entry.key);
                final color = _colorIcono(entry.key);
                return Chip(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  avatar: Icon(icon, size: 18, color: Colors.white),
                  label: Text(
                    '${entry.key[0].toUpperCase()}${entry.key.substring(1)}: ${entry.value}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  backgroundColor: color.withOpacity(0.9),
                  elevation: 2,
                  shadowColor: Colors.black38,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                );
              }).toList(),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    if (hijoId == null) {
      return Scaffold(
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (_, __) => CustomPaint(
                painter: WavePainter(_controller.value),
                child: Container(),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning, size: 60, color: Colors.white70),
                  const SizedBox(height: 16),
                  const Text(
                    'Debes seleccionar un perfil primero.',
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
                    child: const Text('Volver al inicio'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final listaMostrada = fechaFiltrada == null
        ? emociones
        : emociones.where((emocion) {
            final fecha = DateTime.tryParse(emocion[AppDatabase.columnTimestamp] ?? '');
            if (fecha == null) return false;
            return fecha.year == fechaFiltrada!.year &&
                fecha.month == fechaFiltrada!.month &&
                fecha.day == fechaFiltrada!.day;
          }).toList();

    return Scaffold(
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
            child: Column(
              children: [
                AppBar(
                  title: const Text('Emociones de tu hijo'),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                  titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
                  actions: [
                    if (padreId != null)
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Añadir hijo',
                        onPressed: () {
                          Navigator.pushNamed(context, '/registro_hijo');
                        },
                      ),
                  ],
                ),
                if (fechaFiltrada != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => fechaFiltrada = null),
                      icon: const Icon(Icons.clear, color: Colors.white),
                      label: Text(
                        'Ver todas (${DateFormat('dd/MM/yyyy').format(fechaFiltrada!)})',
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white24,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
                _buildResumenEmociones(listaMostrada),
                Expanded(
                  child: listaMostrada.isEmpty
                      ? const Center(
                          child: Text(
                            'Aún no hay emociones registradas.',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: listaMostrada.length,
                          itemBuilder: (context, index) {
                            final emocional = listaMostrada[index];
                            final raw = emocional[AppDatabase.columnEmocion];
                            if (raw == null || raw.toString().trim().isEmpty) return const SizedBox.shrink();

                            final texto = raw.toString();
                            final fechaIso = emocional[AppDatabase.columnTimestamp] as String;
                            final fechaTexto = _formatearFechaISO(fechaIso);
                            final iconColor = _colorIcono(texto);
                            final iconData = _iconoEmocion(texto);

                            return Card(
                              color: const Color(0xFF2EC8B9),
                              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                              child: ListTile(
                                leading: Icon(iconData, color: iconColor, size: 32),
                                title: Text(
                                  texto,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  fechaTexto,
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.black.withOpacity(0.05),
                  child: ElevatedButton.icon(
                    onPressed: _abrirCalendario,
                    icon: const Icon(Icons.calendar_today, color: Colors.white),
                    label: const Text('Abrir calendario'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EC8B9),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 6,
                      shadowColor: Colors.black45,
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
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
    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF0B486B), Color(0xFF3B8686)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

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
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    canvas.drawPath(path, Paint()..color = Colors.white.withOpacity(0.2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
