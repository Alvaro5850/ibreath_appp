// lib/db/session.dart

class Session {
  static int? hijoId;
  static String? mensajeTemporal;

  static void setHijoId(int? id) {
    hijoId = id;
  }

  static int? getHijoId() {
    return hijoId;
  }

  static void setMensajeTemporal(String? mensaje) {
    mensajeTemporal = mensaje;
  }

  static String? getMensajeTemporal() {
    final mensaje = mensajeTemporal;
    mensajeTemporal = null; // se limpia después de usarse
    return mensaje;
  }

  static void clearHijo() {}
}
