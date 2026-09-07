import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/theme.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  final _localidadCtrl = TextEditingController();
  bool _verPass = false;
  bool _aceptaTerminos = false;

  // Lista simple de provincias para el selector
  static const _provincias = [
    'Madrid', 'Barcelona', 'Sevilla', 'Valencia', 'Zaragoza',
    'Málaga', 'Bilbao', 'Alicante', 'Córdoba', 'Valladolid',
    'Murcia', 'Palma', 'Las Palmas', 'Santander', 'Pamplona',
  ];
  String? _provinciaSeleccionada;

  @override
  void dispose() {
    for (final c in [_nombreCtrl, _apellidosCtrl, _emailCtrl, _passCtrl, _pass2Ctrl, _localidadCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Crear cuenta'),
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.md),
            _buildCabecera(),
            const SizedBox(height: AppSpacing.lg),
            _buildFormulario(),
            const SizedBox(height: AppSpacing.lg),
            _buildLoginLink(),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildCabecera() {
    return Column(
      children: [
        Text('Únete a IN MEMORIAM', style: AppTextStyles.headlineLarge),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Crea tu cuenta para dejar condolencias,\nenviar flores y compartir recuerdos.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormulario() {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Datos personales ────────────────────────────
                Text('DATOS PERSONALES', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.sm),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nombreCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(labelText: 'Nombre *'),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Requerido' : null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: TextFormField(
                        controller: _apellidosCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(labelText: 'Apellidos *'),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Requerido' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // ── Ubicación (opcional) ────────────────────────
                Text('UBICACIÓN (opcional)', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.sm),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _localidadCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(labelText: 'Localidad'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _provinciaSeleccionada,
                        decoration: const InputDecoration(labelText: 'Provincia'),
                        items: _provincias
                            .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (v) => setState(() => _provinciaSeleccionada = v),
                        style: AppTextStyles.bodyMedium,
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                const Divider(color: AppColors.divider),
                const SizedBox(height: AppSpacing.md),

                // ── Cuenta ──────────────────────────────────────
                Text('CUENTA', style: AppTextStyles.caption),
                const SizedBox(height: AppSpacing.sm),

                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico *',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Requerido';
                    if (!v.contains('@') || !v.contains('.')) return 'Email no válido';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                TextFormField(
                  controller: _passCtrl,
                  obscureText: !_verPass,
                  decoration: InputDecoration(
                    labelText: 'Contraseña *',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    helperText: 'Mínimo 6 caracteres',
                    suffixIcon: IconButton(
                      icon: Icon(_verPass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _verPass = !_verPass),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requerido';
                    if (v.length < 6) return 'Mínimo 6 caracteres';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                TextFormField(
                  controller: _pass2Ctrl,
                  obscureText: !_verPass,
                  decoration: const InputDecoration(
                    labelText: 'Confirmar contraseña *',
                    prefixIcon: Icon(Icons.lock_outlined),
                  ),
                  validator: (v) {
                    if (v != _passCtrl.text) return 'Las contraseñas no coinciden';
                    return null;
                  },
                ),

                // Error
                if (state.errorAuth != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, size: 16, color: AppColors.error),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.errorAuth!,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: AppSpacing.md),

                // Términos
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _aceptaTerminos,
                      onChanged: (v) => setState(() => _aceptaTerminos = v ?? false),
                      activeColor: AppColors.gold,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _aceptaTerminos = !_aceptaTerminos),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: RichText(
                            text: TextSpan(
                              style: AppTextStyles.bodySmall,
                              children: [
                                const TextSpan(text: 'He leído y acepto los '),
                                TextSpan(
                                  text: 'Términos y Condiciones',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.gold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                const TextSpan(text: ' y la '),
                                TextSpan(
                                  text: 'Política de Privacidad',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.gold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Botón registro
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: ElevatedButton(
                    onPressed: (state.cargandoAuth || !_aceptaTerminos)
                        ? null
                        : () => _registrar(context, state),
                    child: state.cargandoAuth
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Crear cuenta'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('¿Ya tienes cuenta?', style: AppTextStyles.bodyMedium),
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Inicia sesión'),
        ),
      ],
    );
  }

  Future<void> _registrar(BuildContext context, AppState state) async {
    state.limpiarErrorAuth();
    if (!_formKey.currentState!.validate()) return;

    final ok = await state.registrar(
      nombre: _nombreCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      localidad: _localidadCtrl.text.trim().isEmpty ? null : _localidadCtrl.text.trim(),
      provincia: _provinciaSeleccionada,
    );

    if (ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Bienvenido, ${state.usuarioActual?.nombre}!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/');
    }
  }
}
