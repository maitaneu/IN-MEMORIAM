import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import 'feed_card.dart';
import 'feed_search_bar.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<Fallecido>> _futureData;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cargarFeed();
  }

  void _cargarFeed() {
    final state = context.read<AppState>();
    setState(() {
      _futureData = state.fallecidosService.getFeed(state.filtro);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildAppBar(context, state),
            ],
            body: RefreshIndicator(
              color: AppColors.gold,
              onRefresh: () async {
                _cargarFeed();
              },
              child: FutureBuilder<List<Fallecido>>(
                future: _futureData,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return _buildShimmerList();
                  }
                  if (snap.hasError) {
                    return _buildError(snap.error.toString());
                  }
                  final lista = snap.data ?? [];
                  if (lista.isEmpty) {
                    return _buildEmpty(state.filtro);
                  }
                  return _buildList(lista);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // ── AppBar con logo + búsqueda ────────────────────────────────
  SliverAppBar _buildAppBar(BuildContext context, AppState state) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.border,
      title: const IMLogoHorizontal(iconSize: 26),
      actions: [
        if (state.filtro.tieneFilrosActivos)
          Container(
            margin: const EdgeInsets.only(right: 4),
            child: IconButton(
              icon: Badge(
                backgroundColor: AppColors.gold,
                child: const Icon(Icons.filter_list),
              ),
              onPressed: () => _abrirFiltros(context),
              tooltip: 'Filtros activos',
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _abrirFiltros(context),
            tooltip: 'Filtrar',
          ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _mostrarBusqueda(context, state),
          tooltip: 'Buscar',
        ),
      ],
      bottom: state.filtro.tieneFilrosActivos
          ? PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: _FilterChipsBar(
                filtro: state.filtro,
                onLimpiar: () {
                  state.limpiarFiltros();
                  _cargarFeed();
                },
              ),
            )
          : null,
    );
  }

  // ── Lista de cards ────────────────────────────────────────────
  Widget _buildList(List<Fallecido> lista) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: lista.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) => FeedCard(fallecido: lista[i]),
    );
  }

  // ── Shimmer de carga ──────────────────────────────────────────
  Widget _buildShimmerList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (_, __) => const _ShimmerCard(),
    );
  }

  Widget _buildError(String msg) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text('Error al cargar', style: AppTextStyles.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(msg, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              onPressed: _cargarFeed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(FiltroBusqueda filtro) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, color: AppColors.textHint, size: 56),
            const SizedBox(height: AppSpacing.md),
            Text(
              filtro.tieneFilrosActivos
                  ? 'No hay resultados con los filtros aplicados'
                  : 'No hay publicaciones disponibles',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (filtro.tieneFilrosActivos) ...[
              const SizedBox(height: AppSpacing.md),
              TextButton.icon(
                icon: const Icon(Icons.clear),
                label: const Text('Limpiar filtros'),
                onPressed: () {
                  context.read<AppState>().limpiarFiltros();
                  _cargarFeed();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _abrirFiltros(BuildContext context) {
    context.push('/filtros').then((_) => _cargarFeed());
  }

  void _mostrarBusqueda(BuildContext context, AppState state) {
    showSearch(
      context: context,
      delegate: FeedSearchDelegate(
        onBuscar: (texto) {
          state.actualizarFiltro(
            state.filtro.copyWith(textoBusqueda: texto),
          );
          _cargarFeed();
        },
      ),
    );
  }
}

// ── Barra de chips de filtros activos ─────────────────────────────
class _FilterChipsBar extends StatelessWidget {
  final FiltroBusqueda filtro;
  final VoidCallback onLimpiar;

  const _FilterChipsBar({required this.filtro, required this.onLimpiar});

  @override
  Widget build(BuildContext context) {
    final chips = <String>[];
    if (filtro.provincia != null) chips.add(filtro.provincia!);
    if (filtro.localidad != null) chips.add(filtro.localidad!);
    if (filtro.edadMin != null || filtro.edadMax != null) {
      final min = filtro.edadMin ?? 0;
      final max = filtro.edadMax ?? 120;
      chips.add('$min–$max años');
    }
    if (filtro.textoBusqueda != null && filtro.textoBusqueda!.isNotEmpty) {
      chips.add('"${filtro.textoBusqueda}"');
    }

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: chips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (_, i) => Chip(
                label: Text(chips[i], style: AppTextStyles.labelSmall),
                backgroundColor: AppColors.goldLight.withOpacity(0.3),
                side: const BorderSide(color: AppColors.goldLight),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          TextButton(
            onPressed: onLimpiar,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text('Limpiar', style: AppTextStyles.labelSmall.copyWith(color: AppColors.gold)),
          ),
        ],
      ),
    );
  }
}

// ── Shimmer placeholder ───────────────────────────────────────────
class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      height: AppSpacing.feedCardHeight,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
    );
  }
}
