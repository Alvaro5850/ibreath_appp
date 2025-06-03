
class Session {
  static int? parentId;
  static int? hijoId;
  static String? mensajeTemporal;

  static void setParentId(int? id) {
    parentId = id;
  }

  static int? getParentId() {
    return parentId;
  }

  static void clearParent() {
    parentId = null;
    hijoId = null;
  }

  static void setHijoId(int? id) {
    hijoId = id;
  }

  static int? getHijoId() {
    return hijoId;
  }

  static void clearHijo() {
    hijoId = null;
  }

  static void setMensajeTemporal(String? mensaje) {
    mensajeTemporal = mensaje;
  }

  static String? getMensajeTemporal() {
    final m = mensajeTemporal;
    mensajeTemporal = null;
    return m;
  }
}
