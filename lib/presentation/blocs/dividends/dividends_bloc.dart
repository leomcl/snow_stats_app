import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_previous_year_dividends.dart';
import '../../../data/models/dividend_response.dart';

part 'dividends_event.dart';
part 'dividends_state.dart';

class DividendsBloc extends Bloc<DividendsEvent, DividendsState> {
  final GetPreviousYearDividends getPreviousYearDividends;

  DividendsBloc({
    required this.getPreviousYearDividends,
  }) : super(const DividendsInitial()) {
    on<FetchDividends>(_onFetchDividends);
  }

  Future<void> _onFetchDividends(
    FetchDividends event,
    Emitter<DividendsState> emit,
  ) async {
    emit(const DividendsLoading());

    final result = await getPreviousYearDividends(event.symbols);

    result.fold(
      (failure) => emit(DividendsError(failure.message)),
      (dividends) => emit(DividendsLoaded(dividends)),
    );
  }
} 