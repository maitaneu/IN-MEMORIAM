import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/models.dart';
import '../../services/app_state.dart';
import '../../services/mock_data.dart';
import '../../theme/theme.dart';
import '../../utils/date_utils.dart';
import '../../widgets/widgets.dart';
import 'tabs/tab_info.dart';
import 'tabs/tab_esquelas.dart';
import 'tabs/tab_recuerdos.dart';
import 'tabs/tab_comentarios.dart';
import 'tabs/tab_funeral.dart';

class DetailScreen extends StatefulWidget {
  final String fallecidoId;

  const DetailScreen({super.key, required this.fallecidoId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Fallecido? _fallecido;
  bool _cargando = true;

  final List<_TabDef> _tabs = const [
    _TabDef(icon: Icons.info_outline, label: 'Info'),
    _TabDef(icon: Icons.article_outlined, label: 'Esquelas'),
    _TabDef(icon: Icons.photo_library_outlined, label: 'Recuerdos'),
    _TabDef(icon: Icons.chat_bubble_outline, label: 'Condolencias'),
    _TabDef(icon: Icons.church_outlined, label: 'Funeral'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _cargar();
  }

  Future<void> _cargar() async {
    final service = context.read<AppState>().fallecidosService;
    final f = await service.getDetalle(widget.fallecidoId);
    if (mounted) {
      setState(() {
        _fallecido = f;
        _cargando = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) return _buildLoading();
    if (_fallecido == null) return _buildNotFound();

    final f = _fallecido!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          _buildHeroAppBar(f),
          _buildTabBar(),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            TabInfo(fallecido: f),
            TabEsquelas(fallecidoId: f.id),
            TabRecuerdos(fallecidoId: f.id),
            TabComentarios(fallecidoId: f.id),
            TabFuneral(fallecido: f),
          ],
        ),
      ),
    );
  }

  // ── Hero con foto de portada ────────────────────────────────────
  SliverAppBar _buildHeroAppBar(Fallecido f) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.surface,
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: Container(
          decoration: const BoxDecoration(
            color: Colors.black38,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(6),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
        onPressed: () => context.pop(),
      ),
      actions: [
        // Botón seguir en la barra cuando está colapsada
        Consumer<AppState>(
          builder: (context, state, _) {
            if (!state.estaLogueado) return const SizedBox.shrink();
            final sigue = state.sigueA(f.id);
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                tooltip: sigue ? 'Dejar de seguir' : 'Seguir',
                icon: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    sigue ? Icons.notifications_active : Icons.notifications_none,
                    color: sigue ? AppColors.goldLight : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () => _toggleSeguir(context, f, state),
              ),
            );
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Foto
            IMNetworkImage(url: f.fotoPrincipalUrl),

            // Gradiente
            Container(
              decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            ),

            // Datos sobre la foto
            Positioned(
              left: AppSpacing.md,
              right: AppSpacing.md,
              bottom: AppSpacing.md,
              child: _buildHeroInfo(f),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleSeguir(BuildContext context, Fallecido f, AppState state) {
    final ahoraSigue = state.toggleSeguir(f.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ahoraSigue
              ? 'Siguiendo a ${f.nombreCompleto}'
              : 'Has dejado de seguir a ${f.nombreCompleto}',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildHeroInfo(Fallecido f) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(f.nombreCompleto, style: AppTextStyles.displayMedium.copyWith(color: Colors.white)),
        const SizedBox(height: 4),
        Text(
          IMDateUtils.rangoAnios(f.fechaNacimiento, f.fechaFallecimiento),
          style: AppTextStyles.headlineSmall.copyWith(color: AppColors.goldLight),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(Icons.location_on, size: 14, color: Colors.white60),
            const SizedBox(width: 4),
            Text(f.ubicacion, style: AppTextStyles.cardSubtitle),
            const SizedBox(width: 16),
            const Icon(Icons.person_outline, size: 14, color: Colors.white60),
            const SizedBox(width: 4),
            Text('${f.edad} años', style: AppTextStyles.cardSubtitle),
            const Spacer(),
            // Botón seguir en el hero expandido
            Consumer<AppState>(
              builder: (context, state, _) {
                if (!state.estaLogueado) return const SizedBox.shrink();
                final sigue = state.sigueA(f.id);
                return GestureDetector(
                  onTap: () => _toggleSeguir(context, f, state),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: sigue
                          ? AppColors.gold.withOpacity(0.85)
                          : Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sigue ? AppColors.goldLight : Colors.white38,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          sigue ? Icons.notifications_active : Icons.notifications_none,
                          size: 13,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          sigue ? 'Siguiendo' : 'Seguir',
                          style: AppTextStyles.cardSubtitle.copyWith(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        // Tanatorio clicable si existe
        if (f.tanatorioId != null)
          _TanatorioBadgeHero(tanatorioId: f.tanatorioId!),
      ],
    );
  }

  // ── TabBar pegado ───────────────────────────────────────────────
  SliverPersistentHeader _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _TabBarDelegate(
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: _tabs
              .map((t) => Tab(
                    icon: Icon(t.icon, size: 18),
                    text: t.label,
                    iconMargin: const EdgeInsets.only(bottom: 2),
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.surface),
      body: const Center(
        child: CircularProgressIndicator(color: AppColors.gold),
      ),
    );
  }

  Widget _buildNotFound() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('No encontrado'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 64, color: AppColors.textHint),
            const SizedBox(height: AppSpacing.md),
            Text('No se encontró la publicación', style: AppTextStyles.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _TabDef {
  final IconData icon;
  final String label;
  const _TabDef({required this.icon, required this.label});
}

/// Delegate para mantener el TabBar pegado al hacer scroll.
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.surface,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  bool shouldRebuild(covariant _TabBarDelegate old) => false;
}

// ── Badge de tanatorio clicable en el hero ────────────────────────
class _TanatorioBadgeHero extends StatelessWidget {
  final String tanatorioId;

  const _TanatorioBadgeHero({required this.tanatorioId});

  @override
  Widget build(BuildContext context) {
    final tanatorio = MockData.tanatorioPorId(tanatorioId);
    if (tanatorio == null) return const SizedBox.shrink();
    final nombre = tanatorio.datosTanatorio?.razonSocial ??
        tanatorio.nombreCompleto;

    return GestureDetector(
      onTap: () => context.push('/tanatorio/$tanatorioId'),
      child: Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.verified, size: 13, color: AppColors.goldLight),
            const SizedBox(width: 5),
            Text(
              nombre,
              style: AppTextStyles.cardSubtitle.copyWith(
                color: AppColors.goldLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.goldLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
