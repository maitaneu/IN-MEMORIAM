import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/models.dart';
import '../../../services/app_state.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/widgets.dart';

class TabEsquelas extends StatefulWidget {
  final String fallecidoId;

  const TabEsquelas({super.key, required this.fallecidoId});

  @override
  State<TabEsquelas> createState() => _TabEsquelasState();
}

class _TabEsquelasState extends State<TabEsquelas>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<List<Esquela>> _future;

  @override
  void initState() {
    super.initState();
    _future = context
        .read<AppState>()
        .fallecidosService
        .getEsquelas(widget.fallecidoId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = context.read<AppState>();

    return FutureBuilder<List<Esquela>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: AppColors.gold));
        }
        final lista = snap.data ?? [];
        return ListView(
          padding: AppSpacing.screenPadding,
          children: [
            const SizedBox(height: AppSpacing.sm),
            LoginWall(
              accion: 'publicar una esquela',
              estaLogueado: state.estaLogueado,
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Publicar una esquela'),
                  onPressed: state.estaLogueado
                      ? () => _mostrarFormulario(context, state)
                      : null,
                ),
              ),
            ),
            const IMSectionDivider(texto: 'Esquelas publicadas'),
            if (snap.hasError)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(
                  'No se han podido cargar las esquelas. Inténtalo de nuevo.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              )
            else if (lista.isEmpty)
              _buildVacio()
            else
              ...lista.map((esquela) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _EsquelaCard(esquela: esquela),
                  )),
            const SizedBox(height: AppSpacing.xl),
          ],
        );
      },
    );
  }

  Widget _buildVacio() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.article_outlined,
              size: 52, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.md),
          Text('Aún no hay esquelas publicadas',
              style: AppTextStyles.bodyLarge),
        ],
      ),
    );
  }

  Future<void> _mostrarFormulario(BuildContext context, AppState state) async {
    final formKey = GlobalKey<FormState>();
    final tituloCtrl = TextEditingController();
    final textoCtrl = TextEditingController();
    final imagenCtrl = TextEditingController();
    final firmantesCtrl = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      builder: (ctx) {
        var enviando = false;
        return StatefulBuilder(
          builder: (ctx, setModalState) => SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.md,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('Publicar una esquela',
                        style: AppTextStyles.headlineMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'La publicación se revisará antes de aparecer públicamente.',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: tituloCtrl,
                      maxLength: 100,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(labelText: 'Título'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Escribe un título.'
                              : null,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: textoCtrl,
                      minLines: 4,
                      maxLines: 8,
                      maxLength: 2000,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Texto de la esquela',
                        alignLabelWithHint: true,
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Escribe el texto de la esquela.'
                              : null,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: imagenCtrl,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'URL de imagen (opcional)',
                        hintText: 'https://…',
                      ),
                      validator: (value) {
                        final url = value?.trim() ?? '';
                        if (url.isEmpty) return null;
                        final uri = Uri.tryParse(url);
                        if (uri == null ||
                            !uri.hasAuthority ||
                            (uri.scheme != 'http' && uri.scheme != 'https')) {
                          return 'Introduce una URL http o https válida.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: firmantesCtrl,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'Firmantes (opcional)',
                        hintText: 'Un firmante por línea',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: enviando
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;
                                setModalState(() => enviando = true);
                                try {
                                  await state.fallecidosService.publicarEsquela(
                                    fallecidoId: widget.fallecidoId,
                                    autor: state.usuarioActual!,
                                    titulo: tituloCtrl.text,
                                    texto: textoCtrl.text,
                                    imagenUrl: imagenCtrl.text,
                                    firmantes: firmantesCtrl.text
                                        .split('\n')
                                        .map((nombre) => nombre.trim())
                                        .where((nombre) => nombre.isNotEmpty)
                                        .toList(),
                                  );
                                  if (!ctx.mounted) return;
                                  Navigator.pop(ctx);
                                  if (mounted) {
                                    setState(() {
                                      _future = state.fallecidosService
                                          .getEsquelas(widget.fallecidoId);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Esquela enviada para revisión. Se publicará cuando sea aprobada.',
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                } catch (_) {
                                  if (!ctx.mounted) return;
                                  setModalState(() => enviando = false);
                                  ScaffoldMessenger.of(ctx).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'No se pudo enviar la esquela. Inténtalo de nuevo.',
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                        child: enviando
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Enviar para revisión'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    tituloCtrl.dispose();
    textoCtrl.dispose();
    imagenCtrl.dispose();
    firmantesCtrl.dispose();
  }
}

class _EsquelaCard extends StatelessWidget {
  final Esquela esquela;

  const _EsquelaCard({required this.esquela});

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
          // Imagen opcional
          if (esquela.imagenUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.radiusMedium)),
              child: IMNetworkImage(
                url: esquela.imagenUrl,
                height: 180,
                width: double.infinity,
              ),
            ),

          Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Autor + fecha
                Row(
                  children: [
                    if (esquela.autorEsTanatorio)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.goldLight.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.gold),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.business,
                                size: 12, color: AppColors.gold),
                            const SizedBox(width: 4),
                            Text('Tanatorio',
                                style: AppTextStyles.caption
                                    .copyWith(fontSize: 10)),
                          ],
                        ),
                      )
                    else
                      const Icon(Icons.person_outline,
                          size: 16, color: AppColors.textHint),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        esquela.autorNombre,
                        style: AppTextStyles.labelMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      IMDateUtils.fechaCorta(esquela.fechaPublicacion),
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.sm),
                const Divider(color: AppColors.divider),
                const SizedBox(height: AppSpacing.sm),

                // Título
                Text(esquela.titulo, style: AppTextStyles.headlineSmall),
                const SizedBox(height: AppSpacing.sm),

                // Texto de la esquela
                Text(
                  esquela.texto,
                  style: AppTextStyles.esquelaCita,
                ),

                // Firmantes
                if (esquela.firmantes.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Firmado por', style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  ...esquela.firmantes.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text('• $f', style: AppTextStyles.bodySmall),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
