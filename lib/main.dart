import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'router/app_router.dart';
import 'services/app_state.dart';
import 'theme/theme.dart';
import 'utils/date_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IMDateUtils.init(); // inicializa locale español
  runApp(const InMemoriamApp());
}

class InMemoriamApp extends StatelessWidget {
  const InMemoriamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp.router(
        title: 'IN MEMORIAM',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
