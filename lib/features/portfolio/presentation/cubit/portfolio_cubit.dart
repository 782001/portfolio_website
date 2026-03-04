import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_portfolio_data_usecase.dart';
import 'portfolio_state.dart';

class PortfolioCubit extends Cubit<PortfolioState> {
  final GetPortfolioDataUseCase getPortfolioDataUseCase;

  PortfolioCubit({required this.getPortfolioDataUseCase})
    : super(PortfolioInitial());

  Future<void> loadData() async {
    emit(PortfolioLoading());
    try {
      final data = await getPortfolioDataUseCase();
      emit(PortfolioLoaded(data));
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }
}
