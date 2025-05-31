// lib/seleccion_perfil.dart

import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'db/session.dart';

class SeleccionPerfilScreen extends StatefulWidget {
  const SeleccionPerfilScreen({Key? key}) : super(key: key);

  @override
  _SeleccionPerfilScreenState createState() => _SeleccionPerfilScreenState();
}

class _SeleccionPerfilScreenState extends State<SeleccionPerfilScreen> {
  List<Map<String, dynamic>> hijos = [];

  @override
  void initState() {
    super.initState();
    _cargarHijos();
  }

  Future<void> _cargarHijos() async {
    final lista = await AppDatabase.instance.getAllChildren();
    setState(() {
      hijos = lista;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF14749A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF14749A),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Seleccionar Perfil de Niño', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: hijos.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No hay hijos registrados aún.',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registro_hijo');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EC8B9),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      'Añadir nuevo hijo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: hijos.length,
                itemBuilder: (context, index) {
                  final hijo = hijos[index];
                  final id = hijo[AppDatabase.columnId] as int;
                  final nombre = hijo[AppDatabase.columnNombre] as String;
                  final edad = hijo[AppDatabase.columnEdad] as int;

                  return Card(
                    color: const Color(0xFF2EC8B9),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.child_care, color: Colors.white),
                      title: Text(
                        nombre,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Edad: $edad',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
  final hijoActivo = Session.hijoId;
  Session.setHijoId(id);

  if (hijoActivo == null || hijoActivo != id) {
    Session.setMensajeTemporal('Perfil cambiado correctamente');
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Este perfil ya está activo')),
    );
  }
},

                    ),
                  );
                },
              ),
      ),
    );
  }
}
