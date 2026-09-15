import 'package:supabase_flutter/supabase_flutter.dart';

/// Acceso directo al cliente de Supabase desde cualquier parte de la app.
class SB {
  SB._();
  static SupabaseClient get client => Supabase.instance.client;
}
