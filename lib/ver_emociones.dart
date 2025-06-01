// lib/ver_emociones.dart

import 'package:flutter/material.dart';

import '../db_helper.dart';
import '../db/session.dart';

class VerEmocionesScreen extends StatefulWidget {
  const VerEmocionesScreen({Key? key}) : super(key: key);

  @override
  State<VerEmocionesScreen> createState() => _VerEmocionesScreenState();
}

class _VerEmocionesScreenState extends State<VerEmocionesScreen> {
  List<Map<String, dynamic>> emociones = [];
  int? hijoId;
  int? padreId;

  @override
  void initState() {
    super.initState();
    hijoId = Session.getHijoId();
    padreId = Session.getParentId();
    if (hijoId != null) {
      _cargarEmociones(hijoId!);
    }
  }

  Future<void> _cargarEmociones(int idHijo) async {
    final datos = await AppDatabase.instance.obtenerEmocionesPorHijo(idHijo);
    setState(() {
      emociones = datos;
    });
  }

  Future<void> _abrirCalendario() async {
    final hoy = DateTime.now();
    final fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: DateTime(hoy.year - 2),
      lastDate: DateTime(hoy.year + 2),
    );
    if (fechaSeleccionada != null) {
      // Aquí podrías filtrar emociones por fechaSeleccionada.
      // Por ahora, solo mostramos un SnackBar como ejemplo:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fecha elegida: ${DateFormat('dd/MM/yyyy').format(fechaSeleccionada)}')),
      );
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

  @override
  Widget build(BuildContext context) {
    // Si no hay hijo seleccionado, mostramos pantalla de advertencia
    if (hijoId == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF14749A),
        body: Center(
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
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14749A),
        title: const Text('Emociones de tu hijo', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Si el padre está logueado, añadimos un botón “+” para ir a Registrar Hijo
          if (padreId != null)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Añadir hijo',
              onPressed: () {
                Navigator.pushNamed(context, '/registro_hijo').then((_) {
                  // opcional: refrescar lista de hijos al regresar
                });
              },
            ),
        ],
      ),
      body: emociones.isEmpty
          ? const Center(
              child: Text(
                'Aún no hay emociones registradas.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: ListView.builder(
                itemCount: emociones.length,
                itemBuilder: (context, index) {
                  final emocional = emociones[index];
                  final texto = emocional[AppDatabase.columnEmocion] as String;
                  final fechaIso = emocional[AppDatabase.columnTimestamp] as String;
                  final fechaTexto = _formatearFechaISO(fechaIso);
                  final iconColor = _colorIcono(texto);
                  final iconData = _iconoEmocion(texto);

                  return Card(
                    color: const Color(0xFF2EC8B9),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(iconData, size: 32, color: iconColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  texto,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  fechaTexto,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      // 📅 Botón “Calendario” fijo en la parte inferior
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ElevatedButton.icon(
          onPressed: _abrirCalendario,
          icon: const Icon(Icons.calendar_today, color: Colors.white),
          label: const Text('Abrir calendario'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2EC8B9),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
      ),
    );
  }
  
  DateFormat(String s) {}
}
