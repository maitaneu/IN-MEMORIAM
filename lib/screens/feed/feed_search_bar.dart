import 'package:flutter/material.dart';
import '../../theme/theme.dart';

/// SearchDelegate para el buscador del feed.
class FeedSearchDelegate extends SearchDelegate<String> {
  final void Function(String texto) onBuscar;

  FeedSearchDelegate({required this.onBuscar});

  @override
  String get searchFieldLabel => 'Buscar por nombre, localidad...';

  @override
  TextStyle get searchFieldStyle => AppTextStyles.bodyMedium;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      onBuscar(query);
    }
    close(context, query);
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final sugerencias = ['Madrid', 'Sevilla', 'Barcelona', 'Valencia', 'Zaragoza']
        .where((s) => s.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    return ListView(
      children: [
        ...sugerencias.map(
          (s) => ListTile(
            leading: const Icon(Icons.location_on_outlined, color: AppColors.gold),
            title: Text(s, style: AppTextStyles.bodyMedium),
            onTap: () {
              query = s;
              showResults(context);
            },
          ),
        ),
        if (query.isNotEmpty)
          ListTile(
            leading: const Icon(Icons.search, color: AppColors.textSecondary),
            title: Text(
              'Buscar "$query"',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            onTap: () => showResults(context),
          ),
      ],
    );
  }
}
