import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/portfolio/presentation/pages/home_page.dart';
import '../../features/portfolio/presentation/widgets/project_detail_dialog.dart';
import '../../features/portfolio/presentation/cubit/portfolio_cubit.dart';
import '../../features/portfolio/presentation/cubit/portfolio_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart' as di;

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/project/:id',
        builder: (context, state) {
          final projectId = state.pathParameters['id'];
          return BlocBuilder<PortfolioCubit, PortfolioState>(
            bloc: di.sl<PortfolioCubit>()..loadData(),
            builder: (context, portfolioState) {
              if (portfolioState is PortfolioLoaded) {
                try {
                  final project = portfolioState.data.projects.firstWhere(
                    (p) => p.id == projectId,
                  );
                  return ProjectDetailDialog(project: project);
                } catch (e) {
                  return const Scaffold(
                    body: Center(child: Text('Project not found')),
                  );
                }
              }
              if (portfolioState is PortfolioError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${portfolioState.message}')),
                );
              }
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            },
          );
        },
      ),
    ],
  );
}
