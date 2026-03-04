import '../entities/portfolio_data_entity.dart';

abstract class PortfolioRepository {
  Future<PortfolioDataEntity> getPortfolioData();
}
