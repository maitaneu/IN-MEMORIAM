import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _verPass = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xxl),
              _buildLogo(),
              const SizedBox(height: AppSpacing.xl),
              _buildForm(),
              const SizedBox(height: AppSpacing.md),
              _buildRegistroLink(),
              const SizedBox(height: AppSpacing.xl),
              _buildDemoHint(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Logo ──────────────────────────────────────────────────────
  Widget _buildLogo() {
    return Column(
      children: [
        IMLogo(size: 80, conTexto: false),
        const SizedBox(height: AppSpacing.md),
        Text('IN MEMORIAM', style: AppTextStyles.displayMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'El lugar donde los recuerdos perviven',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── Formulario ────────────────────────────────────────────────
  Widget _buildForm() {
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
                Text('Iniciar sesión', style: AppTextStyles.headlineMedium),
                const SizedBox(height: AppSpacing.md),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Introduce tu email';
                    if (!v.contains('@')) return 'Email no válido';
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Contraseña
                TextFormField(
                  controller: _passCtrl,
                  obscureText: !_verPass,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_verPass ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _verPass = !_verPass),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Introduce tu contraseña';
                    if (v.length < 4) return 'Mínimo 4 caracteres';
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

                const SizedBox(height: AppSpacing.lg),

                // Botón
                SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeight,
                  child: ElevatedButton(
                    onPressed: state.cargandoAuth ? null : () => _login(context, state),
                    child: state.cargandoAuth
                        ? const SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Entrar'),
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Olvidé la contraseña (decorativo en demo)
                Center(
                  child: TextButton(
                    onPressed: () => _mostrarMsgDemo(context),
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegistroLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('¿No tienes cuenta?', style: AppTextStyles.bodyMedium),
        TextButton(
          onPressed: () => context.push('/registro'),
          child: const Text('Regístrate'),
        ),
      ],
    );
  }

  Widget _buildDemoHint() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.goldLight.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        border: Border.all(color: AppColors.goldLight.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, size: 14, color: AppColors.gold),
              const SizedBox(width: 6),
              Text('Cuentas de demostración', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Email: maria.lopez@email.com\nContraseña: 1234',
            style: AppTextStyles.bodySmall.copyWith(fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  Future<void> _login(BuildContext context, AppState state) async {
    state.limpiarErrorAuth();
    if (!_formKey.currentState!.validate()) return;

    final ok = await state.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (ok && context.mounted) {
      context.go('/');
    }
  }

  void _mostrarMsgDemo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función no disponible en la versión demo')),
    );
  }
}
