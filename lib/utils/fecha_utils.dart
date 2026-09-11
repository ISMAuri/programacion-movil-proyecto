class FechaUtils {
  static String formatearFechaHora(DateTime fecha) {
    final fechaLocal = fecha.toLocal();

    final dia = fechaLocal.day.toString().padLeft(2, '0');
    final mes = fechaLocal.month.toString().padLeft(2, '0');
    final hora = fechaLocal.hour.toString().padLeft(2, '0');
    final minuto = fechaLocal.minute.toString().padLeft(2, '0');

    return '$dia/$mes/${fechaLocal.year} $hora:$minuto';
  }
}