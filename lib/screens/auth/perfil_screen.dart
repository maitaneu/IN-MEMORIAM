import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../theme/theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/widgets.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        if (!state.estaLogueado) {
          return _buildNoLogueado(context);
        }
        return _buildPerfil(context, state);
      },
    );
  }

  // ── Estado sin sesión ─────────────────────────────────────────
  Widget _buildNoLogueado(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi perfil'),
        backgroundColor: AppColors.surface,
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80, height: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.surfaceVariant,
                ),
                child: const Icon(Icons.person_outline, size: 40, color: AppColors.textHint),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('No has iniciado sesión', style: AppTextStyles.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Inicia sesión o regístrate para acceder a tu perfil y poder interactuar con la comunidad.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: ElevatedButton(
                  onPressed: () => context.push('/login'),
                  child: const Text('Iniciar sesión'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                width: double.infinity,
                height: AppSpacing.buttonHeight,
                child: OutlinedButton(
                  onPressed: () => context.push('/registro'),
                  child: const Text('Crear cuenta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Perfil con sesión ─────────────────────────────────────────
  Widget _buildPerfil(BuildContext context, AppState state) {
    final usuario = state.usuarioActual!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mi perfil'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _confirmarLogout(context, state),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.lg),

            // ── Avatar + nombre ───────────────────────────────
            Center(
              child: Column(
                children: [
                  IMAvatarWidget(
                    imageUrl: usuario.avatarUrl,
                    nombre: usuario.nombreCompleto,
                    size: AppSpacing.avatarXL,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(usuario.nombreCompleto, style: AppTextStyles.headlineLarge),
                  const SizedBox(height: 4),
                  _RolBadge(rol: usuario.rol),
                  if (usuario.localidad != null || usuario.provincia != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(
                          [usuario.localidad, usuario.provincia]
                              .where((s) => s != null)
                              .join(', '),
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── Datos de cuenta ───────────────────────────────
            _SectionCard(
              titulo: 'Datos de cuenta',
              children: [
                _InfoTile(
                  icono: Icons.email_outlined,
                  etiqueta: 'Email',
                  valor: usuario.email,
                ),
                _InfoTile(
                  icono: Icons.calendar_today_outlined,
                  etiqueta: 'Miembro desde',
                  valor: IMDateUtils.fechaLarga(usuario.fechaRegistro),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Accesos rápidos ───────────────────────────────
            _SectionCard(
              titulo: 'Más opciones',
              children: [
                _MenuTile(
                  icono: Icons.help_outline,
                  label: 'Ayuda y preguntas frecuentes',
                  onTap: () => context.push('/ayuda'),
                ),
                _MenuTile(
                  icono: Icons.gavel_outlined,
                  label: 'Aviso legal y privacidad',
                  onTap: () => context.push('/legal'),
                ),
                _MenuTile(
                  icono: Icons.info_outline,
                  label: 'Sobre IN MEMORIAM',
                  onTap: () => context.push('/sobre'),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            // ── Zona peligrosa ────────────────────────────────
            _SectionCard(
              titulo: 'Sesión',
              children: [
                _MenuTile(
                  icono: Icons.logout,
                  label: 'Cerrar sesión',
                  color: AppColors.error,
                  onTap: () => _confirmarLogout(context, state),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _confirmarLogout(BuildContext context, AppState state) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        title: Text('Cerrar sesión', style: AppTextStyles.headlineMedium),
        content: Text(
          '¿Seguro que quieres cerrar sesión?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              state.logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}

class _RolBadge extends StatelessWidget {
  final RolUsuario rol;
  const _RolBadge({required this.rol});

  String get _label {
    switch (rol) {
      case RolUsuario.tanatorio:
        return 'Tanatorio verificado';
      case RolUsuario.administrador:
        return 'Administrador';
      default:
        return 'Miembro';
    }
  }

  IconData get _icon {
    switch (rol) {
      case RolUsuario.tanatorio:
        return Icons.verified;
      case RolUsuario.administrador:
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.goldLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: AppColors.gold),
          const SizedBox(width: 4),
          Text(_label, style: AppTextStyles.caption.copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String titulo;
  final List<Widget> children;
  const _SectionCard({required this.titulo, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
            child: Text(titulo.toUpperCase(), style: AppTextStyles.caption),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...children,
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;
  const _InfoTile({required this.icono, required this.etiqueta, required this.valor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
      child: Row(
        children: [
          Icon(icono, size: 16, color: AppColors.textHint),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(etiqueta, style: AppTextStyles.labelSmall),
                Text(valor, style: AppTextStyles.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icono;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _MenuTile({
    required this.icono,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.textPrimary;
    return ListTile(
      leading: Icon(icono, size: 20, color: c),
      title: Text(label, style: AppTextStyles.bodyMedium.copyWith(color: c)),
      trailing: Icon(Icons.chevron_right, size: 18, color: AppColors.textHint),
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
    );
  }
}


