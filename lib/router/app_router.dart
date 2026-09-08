import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/feed/feed_screen.dart';
import '../screens/detail/detail_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/registro_screen.dart';
import '../screens/auth/perfil_screen.dart';
import '../screens/filters/filtros_screen.dart';
import '../screens/legal/ayuda_screen.dart';
import '../screens/legal/legal_screen.dart';
import '../screens/legal/sobre_screen.dart';
import '../screens/tanatorio/tanatorio_screen.dart';
import '../theme/theme.dart';

/// Shell con BottomNavigationBar compartido para las rutas principales.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // ── Shell con bottom nav ────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => _MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: '/perfil',
            builder: (context, state) => const PerfilScreen(),
          ),
        ],
      ),

      // ── Pantallas sin bottom nav ────────────────────────────
      GoRoute(
        path: '/fallecido/:id',
        builder: (context, state) => DetailScreen(
          fallecidoId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/registro',
        builder: (context, state) => const RegistroScreen(),
      ),
      GoRoute(
        path: '/filtros',
        builder: (context, state) => const FiltrosScreen(),
      ),
      GoRoute(
        path: '/ayuda',
        builder: (context, state) => const AyudaScreen(),
      ),
      GoRoute(
        path: '/legal',
        builder: (context, state) => const LegalScreen(),
      ),
      GoRoute(
        path: '/sobre',
        builder: (context, state) => const SobreScreen(),
      ),
      GoRoute(
        path: '/tanatorio/:id',
        builder: (context, state) => TanatorioScreen(
          tanatorioId: state.pathParameters['id']!,
        ),
      ),
    ],

    // Página de error 404 elegante
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Página no encontrada'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.search_off, size: 72, color: AppColors.textHint),
            const SizedBox(height: 24),
            Text('404 — Página no encontrada',
                style: AppTextStyles.headlineMedium),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}

// ── Shell con bottom navigation ─────────────────────────────────────
class _MainShell extends StatelessWidget {
  final Widget child;

  const _MainShell({required this.child});

  static const _items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Inicio',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Mi perfil',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = location.startsWith('/perfil') ? 1 : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: _items,
        onTap: (i) {
          switch (i) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/perfil');
              break;
          }
        },
      ),
    );
  }
}
