import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_previous_year_dividends.dart';
import '../../../data/models/dividend_response.dart';
import '../../../domain/usecases/calculate_dividend_metrics_usecase.dart';
import '../../../domain/models/dividend_metrics.dart';
import '../../../domain/entities/stock.dart';

part 'dividends_event.dart';
part 'dividends_state.dart';

class DividendsBloc extends Bloc<DividendsEvent, DividendsState> {
  final GetPreviousYearDividends getPreviousYearDividends;
  final CalculateDividendMetricsUseCase calculateMetricsUseCase;
  int lastProcessedStockCount = 0;

  DividendsBloc({
    required this.getPreviousYearDividends,
    required this.calculateMetricsUseCase,
  }) : super(const DividendsInitial()) {
    on<FetchDividends>(_onFetchDividends);
    on<CalculateMetrics>(_calculateMetrics);
  }

  Future<void> _onFetchDividends(
    FetchDividends event,
    Emitter<DividendsState> emit,
  ) async {
    emit(const DividendsLoading());

    final tickers = event.stocks.map((stock) => stock.ticker).toList();
    
    final result = await getPreviousYearDividends(tickers);

    result.fold(
      (failure) => emit(DividendsError(failure.message)),
      (dividends) => emit(DividendsLoaded(dividends)),
    );
  }

  Future<void> _calculateMetrics(
    CalculateMetrics event,
    Emitter<DividendsState> emit,
  ) async {
    final stocksMap = {
      for (var stock in event.stocks) 
        stock.ticker: stock.shares.toDouble()
    };
    
    final result = await calculateMetricsUseCase.execute(
      event.stocks.map((stock) => stock.ticker).toList(),
      sharesByTicker: stocksMap,
    );
    
    result.fold(
      (failure) => emit(DividendsError(failure.message)),
      (metrics) {
        lastProcessedStockCount = event.stocks.length;
        emit(DividendsMetricsLoaded(metrics: metrics));
      },
    );
  }
} 