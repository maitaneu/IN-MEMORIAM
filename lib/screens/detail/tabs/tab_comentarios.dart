import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/models.dart';
import '../../../services/app_state.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/widgets.dart';

class TabComentarios extends StatefulWidget {
  final String fallecidoId;

  const TabComentarios({super.key, required this.fallecidoId});

  @override
  State<TabComentarios> createState() => _TabComentariosState();
}

class _TabComentariosState extends State<TabComentarios>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<List<Comentario>> _future;
  late Future<List<FlorVirtual>> _futureFlores;

  @override
  void initState() {
    super.initState();
    final svc = context.read<AppState>().fallecidosService;
    _future = svc.getComentarios(widget.fallecidoId);
    _futureFlores = svc.getFlores(widget.fallecidoId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = context.read<AppState>();

    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        const SizedBox(height: AppSpacing.sm),

        // ── Flores virtuales ─────────────────────────────────
        _buildFloresSection(state),

        const IMSectionDivider(texto: 'Condolencias'),

        // ── Formulario nuevo comentario ───────────────────────
        LoginWall(
          accion: 'dejar una condolencia',
          estaLogueado: state.estaLogueado,
          child: _FormComentario(
            fallecidoId: widget.fallecidoId,
            onEnviado: _recargar,
          ),
        ),

        const SizedBox(height: AppSpacing.md),

        // ── Lista de comentarios ──────────────────────────────
        FutureBuilder<List<Comentario>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.xl),
                child: Center(child: CircularProgressIndicator(color: AppColors.gold)),
              );
            }
            final lista = snap.data ?? [];
            if (lista.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 48, color: AppColors.textHint),
                      const SizedBox(height: AppSpacing.md),
                      Text('Sé el primero en dejar una condolencia',
                          style: AppTextStyles.bodyLarge, textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }
            return Column(
              children: lista.map((c) => _ComentarioTile(comentario: c)).toList(),
            );
          },
        ),

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  Widget _buildFloresSection(AppState state) {
    return FutureBuilder<List<FlorVirtual>>(
      future: _futureFlores,
      builder: (ctx, snap) {
        final flores = snap.data ?? [];

        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('💐', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text('Flores virtuales'.toUpperCase(), style: AppTextStyles.caption),
                  const Spacer(),
                  if (flores.isNotEmpty)
                    Text('${flores.length}', style: AppTextStyles.bodySmall),
                ],
              ),

              if (flores.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: flores.length > 8 ? 8 : flores.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final f = flores[i];
                      return Tooltip(
                        message: '${f.tipo.emoji} ${f.tipo.nombre} de ${f.usuarioNombre}',
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColors.goldLight.withOpacity(0.3),
                          child: Text(f.tipo.emoji, style: const TextStyle(fontSize: 18)),
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: AppSpacing.sm),

              LoginWall(
                accion: 'enviar flores virtuales',
                estaLogueado: state.estaLogueado,
                child: TextButton.icon(
                  icon: const Text('🌹', style: TextStyle(fontSize: 16)),
                  label: const Text('Enviar flores'),
                  onPressed: state.estaLogueado
                      ? () => _mostrarDialogoFlores(ctx, state)
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _mostrarDialogoFlores(BuildContext context, AppState state) {
    TipoFlor? seleccionada;
    final mensajeCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLarge)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border, borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Enviar flores virtuales', style: AppTextStyles.headlineMedium),
              const SizedBox(height: AppSpacing.md),

              // Selector de flor
              Wrap(
                spacing: 8, runSpacing: 8,
                children: TipoFlor.values.map((tipo) {
                  final sel = seleccionada == tipo;
                  return GestureDetector(
                    onTap: () => setModalState(() => seleccionada = tipo),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.goldLight.withOpacity(0.4) : AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                        border: Border.all(
                          color: sel ? AppColors.gold : AppColors.border,
                          width: sel ? 1.5 : 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(tipo.emoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 6),
                          Text(tipo.nombre, style: AppTextStyles.labelMedium),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: mensajeCtrl,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Mensaje opcional...'),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: seleccionada == null
                      ? null
                      : () async {
                          await state.fallecidosService.enviarFlor(
                            fallecidoId: widget.fallecidoId,
                            usuario: state.usuarioActual!,
                            tipo: seleccionada!,
                            mensaje: mensajeCtrl.text.trim().isEmpty
                                ? null
                                : mensajeCtrl.text.trim(),
                          );
                          if (ctx.mounted) Navigator.pop(ctx);
                          setState(() {
                            _futureFlores = state.fallecidosService.getFlores(widget.fallecidoId);
                          });
                        },
                  child: const Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _recargar() {
    setState(() {
      _future = context.read<AppState>().fallecidosService.getComentarios(widget.fallecidoId);
    });
  }
}

// ── Formulario de comentario ────────────────────────────────────────
class _FormComentario extends StatefulWidget {
  final String fallecidoId;
  final VoidCallback onEnviado;

  const _FormComentario({required this.fallecidoId, required this.onEnviado});

  @override
  State<_FormComentario> createState() => _FormComentarioState();
}

class _FormComentarioState extends State<_FormComentario> {
  final _controller = TextEditingController();
  bool _enviando = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<AppState>();

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
          Row(
            children: [
              IMAvatarWidget(
                imageUrl: state.usuarioActual?.avatarUrl,
                nombre: state.usuarioActual?.nombreCompleto ?? 'U',
                size: AppSpacing.avatarMd,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                state.usuarioActual?.nombreCompleto ?? 'Invitado',
                style: AppTextStyles.labelLarge,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Escribe tu condolencia o mensaje de apoyo...',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Los comentarios son revisados antes de publicarse.',
                  style: AppTextStyles.bodySmall,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              ElevatedButton(
                onPressed: _enviando ? null : () => _enviar(context, state),
                child: _enviando
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Enviar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _enviar(BuildContext context, AppState state) async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    setState(() => _enviando = true);
    await state.fallecidosService.enviarComentario(
      fallecidoId: widget.fallecidoId,
      autor: state.usuarioActual!,
      texto: texto,
    );
    _controller.clear();
    setState(() => _enviando = false);
    widget.onEnviado();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Condolencia enviada — pendiente de revisión'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}

// ── Tile de comentario ──────────────────────────────────────────────
class _ComentarioTile extends StatelessWidget {
  final Comentario comentario;

  const _ComentarioTile({required this.comentario});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.divider, width: 0.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IMAvatarWidget(
            imageUrl: comentario.autorAvatarUrl,
            nombre: comentario.autorNombre,
            size: AppSpacing.avatarSm,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(comentario.autorNombre, style: AppTextStyles.labelLarge),
                    const Spacer(),
                    Text(
                      IMDateUtils.fechaCorta(comentario.fechaCreacion),
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comentario.texto,
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
