import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/theme.dart';

/// Widget que muestra un bloqueo elegante cuando se requiere login.
/// Se usa para envolver acciones que requieren autenticación.
class LoginWall extends StatelessWidget {
  final String accion;
  final Widget child;
  final bool estaLogueado;

  const LoginWall({
    super.key,
    required this.accion,
    required this.child,
    required this.estaLogueado,
  });

  @override
  Widget build(BuildContext context) {
    if (estaLogueado) return child;

    return GestureDetector(
      onTap: () => _mostrarDialogo(context),
      child: AbsorbPointer(child: Opacity(opacity: 0.5, child: child)),
    );
  }

  void _mostrarDialogo(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        title: Text('Acceso requerido', style: AppTextStyles.headlineMedium),
        content: Text(
          'Para $accion es necesario tener una cuenta en IN MEMORIAM.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.push('/login');
            },
            child: const Text('Iniciar sesión'),
          ),
        ],
      ),
    );
  }
}
