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

  @override
  void initState() {
    super.initState();
    _cargarHijos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Si quisiéramos leer argumentos vía ModalRoute, lo haríamos aquí.
    // Sin embargo, en esta versión se asume que el constructor ya recibe 'modoConsulta'.
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
        title: const Text('Tus Hijos', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF14749A),
        iconTheme: const IconThemeData(color: Colors.white),
        // Si NO estamos en modoConsulta (es decir, estamos cambiando perfil), mostramos el botón "+":
        actions: [
          if (!widget.modoConsulta)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              tooltip: 'Añadir nuevo hijo',
              onPressed: () {
                Navigator.pushNamed(context, '/registro_hijo').then((_) {
                  // Después de volver de registro, recargamos la lista:
                  _cargarHijos();
                });
              },
            ),
        ],
      ),
      body: hijos.isEmpty
          ? Center(
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
                        // 🔍 Modo consulta: ir a ver emociones (sin cambiar perfil global)
                        Navigator.pushReplacementNamed(context, '/ver_emociones');
                      } else {
                        // 🔀 Cambio de perfil: guardamos mensaje y volvemos al Splash
                        Session.setMensajeTemporal('Perfil cambiado correctamente');
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      }
                    },
                  ),
                );
              },
            ),
    );
  }
}
