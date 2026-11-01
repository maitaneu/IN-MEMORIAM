import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/models.dart';
import '../../../services/app_state.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_utils.dart';
import '../../../widgets/widgets.dart';

class TabCronologia extends StatefulWidget {
  final Fallecido fallecido;

  const TabCronologia({super.key, required this.fallecido});

  @override
  State<TabCronologia> createState() => _TabCronologiaState();
}

class _TabCronologiaState extends State<TabCronologia>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<List<EventoCronologia>> _future;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _future = context
        .read<AppState>()
        .fallecidosService
        .getCronologia(widget.fallecido.id);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = context.read<AppState>();

    return FutureBuilder<List<EventoCronologia>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.gold),
          );
        }

        // Siempre mostramos al menos nacimiento y fallecimiento
        final eventos = _construirEventos(snap.data ?? []);

        return ListView(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: AppSpacing.xxl,
          ),
          children: [
            // Encabezado
            _CronologiaHeader(fallecido: widget.fallecido),
            const SizedBox(height: AppSpacing.lg),

            // Línea de tiempo
            _LineaTiempo(eventos: eventos),

            // Botón añadir evento (solo logueados)
            const SizedBox(height: AppSpacing.lg),
            LoginWall(
              accion: 'añadir un evento a la cronología',
              estaLogueado: state.estaLogueado,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Añadir un acontecimiento'),
                onPressed: state.estaLogueado
                    ? () => _mostrarDialogoEvento(context, state)
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Combina los eventos de BD con los fijos de nacimiento/fallecimiento.
  List<EventoCronologia> _construirEventos(List<EventoCronologia> base) {
    final f = widget.fallecido;
    final fijos = <EventoCronologia>[
      EventoCronologia(
        id: '__nacimiento__',
        fallecidoId: f.id,
        anio: f.fechaNacimiento.year,
        mes: f.fechaNacimiento.month,
        titulo: 'Nacimiento',
        descripcion: f.lugarNacimiento != null
            ? 'Nació en ${f.lugarNacimiento}'
            : null,
        categoria: CategoriaEvento.nacimiento,
        fechaCreacion: DateTime.now(),
      ),
      EventoCronologia(
        id: '__fallecimiento__',
        fallecidoId: f.id,
        anio: f.fechaFallecimiento.year,
        mes: f.fechaFallecimiento.month,
        titulo: 'Fallecimiento',
        descripcion: 'Descansa en paz · ${f.ubicacion}',
        categoria: CategoriaEvento.fallecimiento,
        fechaCreacion: DateTime.now(),
      ),
    ];

    // Mezclamos y ordenamos por año (y mes si existe)
    final todos = [...fijos, ...base];
    todos.sort((a, b) {
      final cmpAnio = a.anio.compareTo(b.anio);
      if (cmpAnio != 0) return cmpAnio;
      final ma = a.mes ?? 0;
      final mb = b.mes ?? 0;
      return ma.compareTo(mb);
    });
    return todos;
  }

  void _mostrarDialogoEvento(BuildContext context, AppState state) {
    final tituloCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    int? anioSel;
    CategoriaEvento categoriaSel = CategoriaEvento.otro;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + AppSpacing.md,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
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
                Text('Añadir acontecimiento',
                    style: AppTextStyles.headlineMedium),
                const SizedBox(height: AppSpacing.md),

                // Título
                TextField(
                  controller: tituloCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Título *',
                    hintText: 'Ej: Se graduó en Medicina',
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Año
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Año *',
                    hintText: 'Ej: 1975',
                  ),
                  onChanged: (v) => anioSel = int.tryParse(v),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Descripción
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Categoría
                Text('Categoría', style: AppTextStyles.labelLarge),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: CategoriaEvento.values
                      .where((c) =>
                          c != CategoriaEvento.nacimiento &&
                          c != CategoriaEvento.fallecimiento)
                      .map((c) {
                    final sel = categoriaSel == c;
                    return GestureDetector(
                      onTap: () => setModal(() => categoriaSel = c),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: sel
                              ? AppColors.goldLight.withOpacity(0.35)
                              : AppColors.surfaceVariant,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusMedium),
                          border: Border.all(
                            color: sel ? AppColors.gold : AppColors.border,
                            width: sel ? 1.5 : 0.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(c.emoji,
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(c.etiqueta,
                                style: AppTextStyles.labelMedium),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.md),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final titulo = tituloCtrl.text.trim();
                      if (titulo.isEmpty || anioSel == null) return;
                      await state.fallecidosService.publicarEvento(
                        fallecidoId: widget.fallecido.id,
                        anio: anioSel!,
                        titulo: titulo,
                        descripcion: descCtrl.text.trim().isEmpty
                            ? null
                            : descCtrl.text.trim(),
                        categoria: categoriaSel,
                      );
                      if (ctx.mounted) Navigator.pop(ctx);
                      setState(() => _cargar());
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Acontecimiento añadido'),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    child: const Text('Añadir'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Encabezado con rango de vida ──────────────────────────────────────

class _CronologiaHeader extends StatelessWidget {
  final Fallecido fallecido;

  const _CronologiaHeader({required this.fallecido});

  @override
  Widget build(BuildContext context) {
    final f = fallecido;
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Row(
        children: [
          // Año nacimiento
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nacimiento'.toUpperCase(), style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(
                  IMDateUtils.fechaLarga(f.fechaNacimiento),
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: Colors.white, height: 1.4),
                ),
                if (f.lugarNacimiento != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    f.lugarNacimiento!,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: Colors.white54),
                  ),
                ],
              ],
            ),
          ),
          // Separador con años vividos
          Column(
            children: [
              Text(
                '${f.edad}',
                style: AppTextStyles.displayLarge
                    .copyWith(color: AppColors.goldLight),
              ),
              Text(
                'años',
                style: AppTextStyles.labelMedium
                    .copyWith(color: Colors.white54),
              ),
            ],
          ),
          // Año fallecimiento
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Fallecimiento'.toUpperCase(),
                    style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(
                  IMDateUtils.fechaLarga(f.fechaFallecimiento),
                  style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white, height: 1.4),
                  textAlign: TextAlign.end,
                ),
                if (f.lugarResidencia != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    f.lugarResidencia!,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: Colors.white54),
                    textAlign: TextAlign.end,
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

// ── Línea de tiempo vertical ──────────────────────────────────────────

class _LineaTiempo extends StatelessWidget {
  final List<EventoCronologia> eventos;

  const _LineaTiempo({required this.eventos});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(eventos.length, (i) {
        final e = eventos[i];
        final esUltimo = i == eventos.length - 1;
        final esPrimero = i == 0;
        return _EventoTile(
          evento: e,
          esPrimero: esPrimero,
          esUltimo: esUltimo,
          alternar: i.isEven,
        );
      }),
    );
  }
}

class _EventoTile extends StatelessWidget {
  final EventoCronologia evento;
  final bool esPrimero;
  final bool esUltimo;
  final bool alternar;

  const _EventoTile({
    required this.evento,
    required this.esPrimero,
    required this.esUltimo,
    required this.alternar,
  });

  @override
  Widget build(BuildContext context) {
    final esNacOFall = evento.id == '__nacimiento__' ||
        evento.id == '__fallecimiento__';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Columna izquierda (año + tarjeta cuando !alternar)
          Expanded(
            child: alternar
                ? _TarjetaEvento(evento: evento, alineaDerecha: true)
                : _AnioLabel(anio: evento.anio, alineaDerecha: true),
          ),

          // Línea central con nodo
          _NodoCentral(
            esPrimero: esPrimero,
            esUltimo: esUltimo,
            esNacOFall: esNacOFall,
            emoji: evento.categoria.emoji,
          ),

          // Columna derecha
          Expanded(
            child: alternar
                ? _AnioLabel(anio: evento.anio, alineaDerecha: false)
                : _TarjetaEvento(evento: evento, alineaDerecha: false),
          ),
        ],
      ),
    );
  }
}

class _NodoCentral extends StatelessWidget {
  final bool esPrimero;
  final bool esUltimo;
  final bool esNacOFall;
  final String emoji;

  const _NodoCentral({
    required this.esPrimero,
    required this.esUltimo,
    required this.esNacOFall,
    required this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      child: Column(
        children: [
          // Línea superior
          Expanded(
            child: esPrimero
                ? const SizedBox.shrink()
                : Container(width: 2, color: AppColors.border),
          ),
          // Nodo
          Container(
            width: esNacOFall ? 38 : 32,
            height: esNacOFall ? 38 : 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: esNacOFall
                  ? AppColors.textPrimary
                  : AppColors.goldLight.withOpacity(0.3),
              border: Border.all(
                color: esNacOFall ? AppColors.goldLight : AppColors.gold,
                width: esNacOFall ? 2 : 1.5,
              ),
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: esNacOFall ? 18 : 15),
              ),
            ),
          ),
          // Línea inferior
          Expanded(
            child: esUltimo
                ? const SizedBox.shrink()
                : Container(width: 2, color: AppColors.border),
          ),
        ],
      ),
    );
  }
}

class _AnioLabel extends StatelessWidget {
  final int anio;
  final bool alineaDerecha;

  const _AnioLabel({required this.anio, required this.alineaDerecha});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: alineaDerecha ? 8 : 0,
        left: alineaDerecha ? 0 : 8,
        top: 12,
        bottom: 12,
      ),
      child: Align(
        alignment:
            alineaDerecha ? Alignment.centerRight : Alignment.centerLeft,
        child: Text(
          '$anio',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.gold,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TarjetaEvento extends StatelessWidget {
  final EventoCronologia evento;
  final bool alineaDerecha;

  const _TarjetaEvento({required this.evento, required this.alineaDerecha});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: alineaDerecha ? 0 : 8,
        right: alineaDerecha ? 8 : 0,
        top: 6,
        bottom: 6,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(color: AppColors.border, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: alineaDerecha
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              evento.titulo,
              style: AppTextStyles.labelLarge,
              textAlign: alineaDerecha ? TextAlign.end : TextAlign.start,
            ),
            if (evento.descripcion != null) ...[
              const SizedBox(height: 3),
              Text(
                evento.descripcion!,
                style: AppTextStyles.bodySmall,
                textAlign: alineaDerecha ? TextAlign.end : TextAlign.start,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            // Foto miniatura si existe
            if (evento.imagenUrl != null) ...[
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                child: IMNetworkImage(
                  url: evento.imagenUrl!,
                  width: double.infinity,
                  height: 80,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
