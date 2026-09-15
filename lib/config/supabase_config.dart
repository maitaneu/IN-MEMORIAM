/// Credenciales de Supabase inyectadas en tiempo de compilación
/// via --dart-define. No hardcodeadas, no en .gitignore.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://qsinfunbphxzqhvesnge.supabase.co',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFzaW5mdW5icGh4enFodmVzbmdlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODkyMzQyMzYsImV4cCI6MjEwNDgxMDIzNn0.ZWxQ_DM1XQTmZgKDsZbdqfQexPCj92g5QasY0hmtmTw',
  );
}
