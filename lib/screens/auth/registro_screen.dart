import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/provincias_data.dart';
import '../../services/app_state.dart';
import '../../theme/theme.dart';

// ── Tipo de cuenta ────────────────────────────────────────────────
enum _TipoCuenta { usuario, particular, funeraria }

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  _TipoCuenta _tipo = _TipoCuenta.usuario;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.sm),
            _buildCabecera(),
            const SizedBox(height: AppSpacing.lg),
            _buildSelectorTipo(),
            const SizedBox(height: AppSpacing.lg),
            // Formulario específico según tipo
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: KeyedSubtree(
                key: ValueKey(_tipo),
                child: switch (_tipo) {
                  _TipoCuenta.usuario   => _FormUsuario(),
                  _TipoCuenta.particular => _FormParticular(),
                  _TipoCuenta.funeraria  => _FormFuneraria(),
                },
              ),
            ),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Únete a IN MEMORIAM', style: AppTextStyles.headlineLarge),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Selecciona el tipo de cuenta que mejor describe tu perfil.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildSelectorTipo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TIPO DE CUENTA', style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(child: _TipoCard(
              tipo: _TipoCuenta.usuario,
              seleccionado: _tipo == _TipoCuenta.usuario,
              icono: Icons.person_outline,
              titulo: 'Usuario',
              descripcion: 'Ver y compartir recuerdos',
              onTap: () => setState(() => _tipo = _TipoCuenta.usuario),
            )),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _TipoCard(
              tipo: _TipoCuenta.particular,
              seleccionado: _tipo == _TipoCuenta.particular,
              icono: Icons.person_pin_outlined,
              titulo: 'Particular',
              descripcion: 'Publicar un fallecimiento',
              onTap: () => setState(() => _tipo = _TipoCuenta.particular),
            )),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: _TipoCard(
              tipo: _TipoCuenta.funeraria,
              seleccionado: _tipo == _TipoCuenta.funeraria,
              icono: Icons.business_outlined,
              titulo: 'Funeraria',
              descripcion: 'Gestionar esquelas',
              onTap: () => setState(() => _tipo = _TipoCuenta.funeraria),
            )),
          ],
        ),
      ],
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
}

// ── Card selector de tipo ─────────────────────────────────────────
class _TipoCard extends StatelessWidget {
  final _TipoCuenta tipo;
  final bool seleccionado;
  final IconData icono;
  final String titulo;
  final String descripcion;
  final VoidCallback onTap;

  const _TipoCard({
    required this.tipo,
    required this.seleccionado,
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: seleccionado
              ? AppColors.gold.withOpacity(0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(
            color: seleccionado ? AppColors.gold : AppColors.border,
            width: seleccionado ? 1.5 : 0.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icono,
                size: 24,
                color: seleccionado ? AppColors.gold : AppColors.textHint),
            const SizedBox(height: 6),
            Text(titulo,
                style: AppTextStyles.labelMedium.copyWith(
                    color: seleccionado
                        ? AppColors.gold
                        : AppColors.textPrimary),
                textAlign: TextAlign.center),
            const SizedBox(height: 2),
            Text(descripcion,
                style: AppTextStyles.labelSmall,
                textAlign: TextAlign.center,
                maxLines: 2),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════
// FORM 1 — Usuario normal
// ════════════════════════════════════════════════════════════════
class _FormUsuario extends StatefulWidget {
  const _FormUsuario();

  @override
  State<_FormUsuario> createState() => _FormUsuarioState();
}

class _FormUsuarioState extends State<_FormUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  final _localidadCtrl = TextEditingController();
  bool _verPass = false;
  bool _aceptaTerminos = false;
  String? _provincia;

  @override
  void dispose() {
    for (final c in [_nombreCtrl, _apellidosCtrl, _emailCtrl, _passCtrl, _pass2Ctrl, _localidadCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSeccion('DATOS PERSONALES', [
              _buildNombreRow(),
              const SizedBox(height: AppSpacing.md),
              _buildUbicacionRow(),
            ]),
            const SizedBox(height: AppSpacing.md),
            _buildSeccion('CUENTA', [
              _buildEmail(),
              const SizedBox(height: AppSpacing.md),
              _buildPass(),
              const SizedBox(height: AppSpacing.md),
              _buildPass2(),
            ]),
            if (state.errorAuth != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _ErrorBanner(mensaje: state.errorAuth!),
            ],
            const SizedBox(height: AppSpacing.md),
            _buildTerminos(context),
            const SizedBox(height: AppSpacing.md),
            _buildBoton(context, state),
          ],
        ),
      );
    });
  }

  Widget _buildNombreRow() => Row(children: [
    Expanded(child: TextFormField(
      controller: _nombreCtrl,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(labelText: 'Nombre *'),
      validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
    )),
    const SizedBox(width: AppSpacing.sm),
    Expanded(child: TextFormField(
      controller: _apellidosCtrl,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(labelText: 'Apellidos *'),
      validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
    )),
  ]);

  Widget _buildUbicacionRow() => Row(children: [
    Expanded(child: TextFormField(
      controller: _localidadCtrl,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(labelText: 'Localidad'),
    )),
    const SizedBox(width: AppSpacing.sm),
    Expanded(child: DropdownButtonFormField<String>(
      value: _provincia,
      decoration: const InputDecoration(labelText: 'Provincia'),
      items: ProvinciasData.todas
          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
          .toList(),
      onChanged: (v) => setState(() => _provincia = v),
      style: AppTextStyles.bodyMedium,
      isExpanded: true,
    )),
  ]);

  Widget _buildEmail() => TextFormField(
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
  );

  Widget _buildPass() => TextFormField(
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
  );

  Widget _buildPass2() => TextFormField(
    controller: _pass2Ctrl,
    obscureText: !_verPass,
    decoration: const InputDecoration(
      labelText: 'Confirmar contraseña *',
      prefixIcon: Icon(Icons.lock_outlined),
    ),
    validator: (v) =>
        v != _passCtrl.text ? 'Las contraseñas no coinciden' : null,
  );

  Widget _buildTerminos(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Checkbox(
        value: _aceptaTerminos,
        onChanged: (v) => setState(() => _aceptaTerminos = v ?? false),
        activeColor: AppColors.gold,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      Expanded(
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
                    decorationColor: AppColors.gold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => context.push('/legal'),
                ),
                const TextSpan(text: ' y la '),
                TextSpan(
                  text: 'Política de Privacidad',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.gold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.gold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => context.push('/legal'),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildBoton(BuildContext context, AppState state) => SizedBox(
    width: double.infinity,
    height: AppSpacing.buttonHeight,
    child: ElevatedButton(
      onPressed: (state.cargandoAuth || !_aceptaTerminos)
          ? null
          : () => _registrar(context, state),
      child: state.cargandoAuth
          ? const SizedBox(
              width: 20, height: 20,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white))
          : const Text('Crear cuenta'),
    ),
  );

  Future<void> _registrar(BuildContext context, AppState state) async {
    state.limpiarErrorAuth();
    if (!_formKey.currentState!.validate()) return;
    final ok = await state.registrar(
      nombre: _nombreCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      localidad: _localidadCtrl.text.trim().isEmpty ? null : _localidadCtrl.text.trim(),
      provincia: _provincia,
    );
    if (ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('¡Bienvenido, ${state.usuarioActual?.nombre}!'),
        backgroundColor: AppColors.success,
      ));
      context.go('/');
    }
  }
}

// ════════════════════════════════════════════════════════════════
// FORM 2 — Particular que publica un fallecimiento
// ════════════════════════════════════════════════════════════════
class _FormParticular extends StatefulWidget {
  const _FormParticular();

  @override
  State<_FormParticular> createState() => _FormParticularState();
}

class _FormParticularState extends State<_FormParticular> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  final _relacionCtrl = TextEditingController();
  final _dniCtrl = TextEditingController();
  bool _verPass = false;
  bool _aceptaTerminos = false;

  static const _relaciones = [
    'Hijo/a', 'Cónyuge o pareja', 'Padre/Madre', 'Hermano/a',
    'Nieto/a', 'Amigo/a íntimo/a', 'Otro familiar', 'Otro',
  ];
  String? _relacionSeleccionada;

  @override
  void dispose() {
    for (final c in [_nombreCtrl, _apellidosCtrl, _emailCtrl, _passCtrl, _pass2Ctrl, _relacionCtrl, _dniCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nota de acompañamiento
            _InfoBanner(
              icono: Icons.favorite_outline,
              texto:
                  'Sabemos que este momento es difícil. Estamos aquí para '
                  'ayudarte a honrar su memoria de la mejor manera posible.',
              color: AppColors.gold,
            ),
            const SizedBox(height: AppSpacing.md),

            _buildSeccion('DATOS PERSONALES', [
              Row(children: [
                Expanded(child: TextFormField(
                  controller: _nombreCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Nombre *'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                )),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: TextFormField(
                  controller: _apellidosCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Apellidos *'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                )),
              ]),
            ]),
            const SizedBox(height: AppSpacing.md),

            _buildSeccion('RELACIÓN CON EL FALLECIDO', [
              DropdownButtonFormField<String>(
                value: _relacionSeleccionada,
                decoration: const InputDecoration(
                  labelText: 'Relación *',
                  prefixIcon: Icon(Icons.people_outline),
                ),
                items: _relaciones
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) => setState(() => _relacionSeleccionada = v),
                validator: (v) => v == null ? 'Selecciona tu relación' : null,
                isExpanded: true,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _dniCtrl,
                decoration: const InputDecoration(
                  labelText: 'DNI / NIE / Pasaporte',
                  prefixIcon: Icon(Icons.badge_outlined),
                  helperText: 'Necesario para verificar tu identidad',
                ),
              ),
            ]),
            const SizedBox(height: AppSpacing.md),

            _buildSeccion('CUENTA', [
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
                validator: (v) =>
                    v != _passCtrl.text ? 'Las contraseñas no coinciden' : null,
              ),
            ]),

            if (state.errorAuth != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _ErrorBanner(mensaje: state.errorAuth!),
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
                              decorationColor: AppColors.gold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.push('/legal'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

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
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Crear cuenta'),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _registrar(BuildContext context, AppState state) async {
    state.limpiarErrorAuth();
    if (!_formKey.currentState!.validate()) return;
    final ok = await state.registrarParticular(
      nombre: _nombreCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      relacionFallecido: _relacionSeleccionada!,
      documentoIdentidad: _dniCtrl.text.trim().isEmpty ? null : _dniCtrl.text.trim(),
    );
    if (ok && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium)),
          title: Row(children: [
            const Icon(Icons.favorite, color: AppColors.gold),
            const SizedBox(width: 8),
            Text('Cuenta creada', style: AppTextStyles.headlineMedium),
          ]),
          content: Text(
            'Tu cuenta ha sido creada. Nuestro equipo revisará tu solicitud '
            'y se pondrá en contacto contigo para guiarte en los siguientes pasos.',
            style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
          ),
          actions: [
            ElevatedButton(
              onPressed: () { Navigator.pop(context); context.go('/'); },
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    }
  }
}

// ════════════════════════════════════════════════════════════════
// FORM 3 — Funeraria / Tanatorio
// ════════════════════════════════════════════════════════════════
class _FormFuneraria extends StatefulWidget {
  const _FormFuneraria();

  @override
  State<_FormFuneraria> createState() => _FormFunerariaState();
}

class _FormFunerariaState extends State<_FormFuneraria> {
  final _formKey = GlobalKey<FormState>();
  // Responsable
  final _nombreCtrl = TextEditingController();
  final _apellidosCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  // Empresa
  final _razonSocialCtrl = TextEditingController();
  final _cifCtrl = TextEditingController();
  final _direccionCtrl = TextEditingController();
  final _telefonoCtrl = TextEditingController();
  final _webCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  bool _verPass = false;
  bool _aceptaTerminos = false;
  String? _provincia;

  @override
  void dispose() {
    for (final c in [
      _nombreCtrl, _apellidosCtrl, _emailCtrl, _passCtrl, _pass2Ctrl,
      _razonSocialCtrl, _cifCtrl, _direccionCtrl, _telefonoCtrl,
      _webCtrl, _descripcionCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, state, _) {
      return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoBanner(
              icono: Icons.verified_outlined,
              texto:
                  'Las cuentas de funeraria son verificadas por el equipo de '
                  'IN MEMORIAM antes de poder publicar esquelas.',
              color: AppColors.success,
            ),
            const SizedBox(height: AppSpacing.md),

            _buildSeccion('DATOS DE LA EMPRESA', [
              TextFormField(
                controller: _razonSocialCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Razón social *',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(children: [
                Expanded(child: TextFormField(
                  controller: _cifCtrl,
                  decoration: const InputDecoration(labelText: 'CIF *'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                )),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: TextFormField(
                  controller: _telefonoCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Teléfono'),
                )),
              ]),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _direccionCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Dirección *',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(children: [
                Expanded(child: DropdownButtonFormField<String>(
                  value: _provincia,
                  decoration: const InputDecoration(labelText: 'Provincia *'),
                  items: ProvinciasData.todas
                      .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                      .toList(),
                  onChanged: (v) => setState(() => _provincia = v),
                  validator: (v) => v == null ? 'Requerido' : null,
                  isExpanded: true,
                )),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: TextFormField(
                  controller: _webCtrl,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Web',
                    prefixIcon: Icon(Icons.language_outlined),
                  ),
                )),
              ]),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _descripcionCtrl,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Descripción de servicios',
                  hintText: 'Servicios que ofrece el tanatorio...',
                ),
              ),
            ]),
            const SizedBox(height: AppSpacing.md),

            _buildSeccion('RESPONSABLE', [
              Row(children: [
                Expanded(child: TextFormField(
                  controller: _nombreCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Nombre *'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                )),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: TextFormField(
                  controller: _apellidosCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: 'Apellidos *'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                )),
              ]),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'Email de contacto *',
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
                validator: (v) =>
                    v != _passCtrl.text ? 'Las contraseñas no coinciden' : null,
              ),
            ]),

            if (state.errorAuth != null) ...[
              const SizedBox(height: AppSpacing.sm),
              _ErrorBanner(mensaje: state.errorAuth!),
            ],
            const SizedBox(height: AppSpacing.md),

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
                              decorationColor: AppColors.gold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.push('/legal'),
                          ),
                          const TextSpan(text: ' y la '),
                          TextSpan(
                            text: 'Política de Privacidad',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.gold,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.gold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.push('/legal'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

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
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Solicitar alta como funeraria'),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _registrar(BuildContext context, AppState state) async {
    state.limpiarErrorAuth();
    if (!_formKey.currentState!.validate()) return;
    final ok = await state.registrarTanatorio(
      nombre: _nombreCtrl.text.trim(),
      apellidos: _apellidosCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      razonSocial: _razonSocialCtrl.text.trim(),
      cif: _cifCtrl.text.trim(),
      direccion: _direccionCtrl.text.trim(),
      telefono: _telefonoCtrl.text.trim().isEmpty ? null : _telefonoCtrl.text.trim(),
      web: _webCtrl.text.trim().isEmpty ? null : _webCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim().isEmpty ? null : _descripcionCtrl.text.trim(),
      provincia: _provincia,
    );
    if (ok && context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium)),
          title: Row(children: [
            const Icon(Icons.verified, color: AppColors.gold),
            const SizedBox(width: 8),
            Text('Solicitud recibida', style: AppTextStyles.headlineMedium),
          ]),
          content: Text(
            'Hemos recibido tu solicitud de alta como funeraria. '
            'Nuestro equipo la revisará en un plazo de 24–48 horas y '
            'te notificará por email.',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            ElevatedButton(
              onPressed: () { Navigator.pop(context); context.go('/'); },
              child: const Text('Entendido'),
            ),
          ],
        ),
      );
    }
  }
}

// ── Widgets auxiliares compartidos ───────────────────────────────
Widget _buildSeccion(String titulo, List<Widget> children) {
  return Container(
    padding: AppSpacing.cardPadding,
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      border: Border.all(color: AppColors.border, width: 0.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.sm),
        ...children,
      ],
    ),
  );
}

class _ErrorBanner extends StatelessWidget {
  final String mensaje;
  const _ErrorBanner({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Text(mensaje,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final IconData icono;
  final String texto;
  final Color color;
  const _InfoBanner({required this.icono, required this.texto, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 18, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(texto,
                style: AppTextStyles.bodySmall.copyWith(height: 1.5)),
          ),
        ],
      ),
    );
  }
}
