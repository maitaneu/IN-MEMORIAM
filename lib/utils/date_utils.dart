import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class IMDateUtils {
  IMDateUtils._();

  static bool _initialized = false;

  static Future<void> init() async {
    if (!_initialized) {
      await initializeDateFormatting('es_ES');
      _initialized = true;
    }
  }

  /// "14 de marzo de 1942"
  static String fechaLarga(DateTime d) =>
      DateFormat('d \'de\' MMMM \'de\' y', 'es_ES').format(d);

  /// "14/03/1942"
  static String fechaCorta(DateTime d) =>
      DateFormat('dd/MM/yyyy', 'es_ES').format(d);

  /// "3 sep. 2026 — 11:00 h"
  static String fechaHora(DateTime d) =>
      DateFormat('d MMM y — HH:mm \'h\'', 'es_ES').format(d);

  /// "Martes, 3 de septiembre de 2026"
  static String fechaCompleta(DateTime d) =>
      DateFormat('EEEE, d \'de\' MMMM \'de\' y', 'es_ES').format(d);

  /// "1942 – 2026"
  static String rangoAnios(DateTime nacimiento, DateTime fallecimiento) =>
      '${nacimiento.year} – ${fallecimiento.year}';
}
