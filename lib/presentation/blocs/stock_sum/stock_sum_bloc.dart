import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/stock_sum/get_stock_sum_usecase.dart';
import 'stock_sum_event.dart';
import 'stock_sum_state.dart';

class StockSumBloc extends Bloc<StockSumEvent, StockSumState> {
  final GetStockSumUseCase getStockSumUseCase;

  StockSumBloc({required this.getStockSumUseCase}) : super(StockSumInitial()) {
    on<GetStockSum>(_onGetStockSum);
  }

  Future<void> _onGetStockSum(
      GetStockSum event, Emitter<StockSumState> emit) async {
    emit(StockSumLoading());

    final result = await getStockSumUseCase(event.symbol, event.year);

    result.fold(
      (failure) => emit(StockSumError(failure.message)),
      (stockSum) => emit(StockSumLoaded(stockSum)),
    );
  }
}
