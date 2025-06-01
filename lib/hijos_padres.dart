// lib/hijos_padres.dart

import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'db/session.dart';

class HijosPadresScreen extends StatefulWidget {
  final bool modoConsulta;

  const HijosPadresScreen({Key? key, this.modoConsulta = false}) : super(key: key);

  @override
  _HijosPadresScreenState createState() => _HijosPadresScreenState();
}

class _HijosPadresScreenState extends State<HijosPadresScreen> {
  List<Map<String, dynamic>> hijos = [];
  int? padreId;

  @override
  void initState() {
    super.initState();
    padreId = Session.getParentId();
    _cargarHijos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Aquí podrías leer arguments si viene desde Login, pero como ya lo pasamos en el constructor,
    // no es estrictamente necesario volver a leerlos.
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
      backgroundColor: const Color(0xFF14749A),
      appBar: AppBar(
        title: const Text('Tus Hijos', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF14749A),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Solo si NO estamos en modoConsulta Y sí hay un padre logueado, mostramos “+”:
          if (!widget.modoConsulta && padreId != null)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Añadir nuevo hijo',
              onPressed: () {
                Navigator.pushNamed(context, '/registro_hijo').then((_) {
                  _cargarHijos();
                });
              },
            ),
        ],
      ),
      body: hijoIdNullOrEmpty(padreId, hijos),
    );
  }

  Widget hijoIdNullOrEmpty(int? padre, List<Map<String, dynamic>> listaHijos) {
    // Si no hay padre logueado, mostramos mensaje:
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

    // Si el padre está logueado pero no tiene hijos (lista vacía),
    // en modoConsulta == false dejamos ver botón de “Añadir hijo”:
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

    // Si hay hijos, los listamos:
    return ListView.builder(
      itemCount: listaHijos.length,
      itemBuilder: (context, index) {
        final hijo = listaHijos[index];
        final id = hijo[AppDatabase.columnId] as int;
        final nombre = hijo[AppDatabase.columnNombre] as String;
        final edad = hijo[AppDatabase.columnEdad] as int;

        return Card(
          color: const Color(0xFF2EC8B9),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
              Session.setHijoId(id);

              if (widget.modoConsulta) {
                // 🔍 Estamos en modo consulta → vamos a ver emociones
                Navigator.pushReplacementNamed(context, '/ver_emociones');
              } else {
                // 🔀 Modo cambio de perfil → volvemos al Splash con mensaje
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
