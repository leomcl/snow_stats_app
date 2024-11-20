part of 'dividends_bloc.dart';

sealed class DividendsEvent {
  const DividendsEvent();
}

final class FetchDividends extends DividendsEvent {
  final List<String> symbols;
  const FetchDividends(this.symbols);
} 