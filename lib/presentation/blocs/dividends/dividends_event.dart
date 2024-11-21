part of 'dividends_bloc.dart';

abstract class DividendsEvent {
  const DividendsEvent();

  List<Object> get props => [];
}

class FetchDividends extends DividendsEvent {
  final List<Stock> stocks;

  const FetchDividends(this.stocks);

  @override
  List<Object> get props => [stocks];
}

class CalculateMetrics extends DividendsEvent {
  final List<Stock> stocks;

  const CalculateMetrics(this.stocks);

  @override
  List<Object> get props => [stocks];
} 