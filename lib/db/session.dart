// lib/db/session.dart

class Session {
  static int? parentId;        // ID del padre logueado
  static int? hijoId;          // ID del hijo seleccionado
  static String? mensajeTemporal;

  /// Guarda el ID del padre que ha iniciado sesión.
  static void setParentId(int? id) {
    parentId = id;
  }

  /// Devuelve el ID del padre que está en sesión (o null si no hay ninguno).
  static int? getParentId() {
    return parentId;
  }

  /// Elimina el padre actual de la sesión (cierra sesión).
  static void clearParent() {
    parentId = null;
    // También podemos limpiar el hijo seleccionado si se prefiere:
    hijoId = null;
  }

  /// Guarda el ID del hijo que se ha seleccionado (para ver emociones, cambios de perfil…).
  static void setHijoId(int? id) {
    hijoId = id;
  }

  /// Devuelve el ID del hijo seleccionado (o null si no hay ninguno).
  static int? getHijoId() {
    return hijoId;
  }

  /// Elimina el hijo actual de la sesión (por ejemplo, al cambiar de perfil).
  static void clearHijo() {
    hijoId = null;
  }

  /// Establece un mensaje temporal que se mostrará en el siguiente rebuild (por ejemplo, "Perfil cambiado correctamente").
  static void setMensajeTemporal(String? mensaje) {
    mensajeTemporal = mensaje;
  }

  /// Devuelve el mensaje temporal y lo limpia. Útil para mostrar SnackBar solo una vez.
  static String? getMensajeTemporal() {
    final m = mensajeTemporal;
    mensajeTemporal = null;
    return m;
  }
}
