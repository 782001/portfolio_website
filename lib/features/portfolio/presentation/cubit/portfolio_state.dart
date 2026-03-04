import 'package:equatable/equatable.dart';
import '../../domain/entities/portfolio_data_entity.dart';

abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  final PortfolioDataEntity data;
  const PortfolioLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class PortfolioError extends PortfolioState {
  final String message;
  const PortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
