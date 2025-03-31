import 'package:flutter_bloc/flutter_bloc.dart';
import 'financial_event.dart';
import 'financial_state.dart';
import '../../../domain/usecases/financial_data/get_financial_data_usecase.dart';

class FinancialBloc extends Bloc<FinancialEvent, FinancialState> {
  final GetFinancialDataUseCase getFinancialDataUseCase;

  FinancialBloc({
    required this.getFinancialDataUseCase,
  }) : super(FinancialInitial()) {
    on<GetFinancialData>(_onGetFinancialData);
    
  }

  Future<void> _onGetFinancialData(
    GetFinancialData event,
    Emitter<FinancialState> emit,
  ) async {
    emit(FinancialLoading());
    final result = await getFinancialDataUseCase(event.symbol, event.year);
    result.fold(
      (failure) => emit(FinancialError(failure.message)),
      (data) => emit(FinancialDataLoaded(
        data: data,
        symbol: event.symbol,
        year: event.year,
      )),
    );
  }
}
