import '../entities/portfolio_data_entity.dart';
import '../repositories/portfolio_repository.dart';

class GetPortfolioDataUseCase {
  final PortfolioRepository repository;
  GetPortfolioDataUseCase(this.repository);

  Future<PortfolioDataEntity> call() => repository.getPortfolioData();
}
