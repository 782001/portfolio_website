import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';

import 'features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'features/portfolio/domain/repositories/portfolio_repository.dart';
import 'features/portfolio/domain/usecases/get_portfolio_data_usecase.dart';
import 'features/portfolio/presentation/cubit/portfolio_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<SupabaseClient>(() => SupabaseConfig.client);

  // Features - Portfolio
  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton(() => GetPortfolioDataUseCase(sl()));

  sl.registerFactory(() => PortfolioCubit(getPortfolioDataUseCase: sl()));
}
