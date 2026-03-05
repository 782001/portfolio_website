import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'core/config/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;

import 'package:go_router/go_router.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use URL strategy to remove # from web URLs
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // Configure fine-grained breakpoints for production
  ResponsiveSizingConfig.instance.setCustomBreakpoints(
    const ScreenBreakpoints(desktop: 950, tablet: 600, watch: 250),
  );

  await SupabaseConfig.initialize();
  await di.init();

  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Abdullah El-Awadi - Flutter Developer Portfolio',
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
