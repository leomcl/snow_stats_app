import 'package:flutter_bloc/flutter_bloc.dart';
import 'stock_price_event.dart';
import 'stock_price_state.dart';
import '../../../domain/usecases/financial_data/get_stock_price_data_usecase.dart';

class StockPriceBloc extends Bloc<StockPriceEvent, StockPriceState> {
  final GetStockPriceDataUsecase getStockPriceDataUsecase;

  StockPriceBloc({
    required this.getStockPriceDataUsecase,
  }) : super(StockPriceInitial()) {
    on<GetStockPriceData>(_onGetStockPriceData);
  }

  Future<void> _onGetStockPriceData(
    GetStockPriceData event,
    Emitter<StockPriceState> emit,
  ) async {
    emit(StockPriceLoading());
    final result = await getStockPriceDataUsecase(event.symbols);
    result.fold(
      (failure) => emit(StockPriceError(failure.message)),
      (data) => emit(StockPriceLoaded(
        priceData: data,
        symbols: event.symbols,
      )),
    );
  }
}
