part of 'dividends_bloc.dart';

sealed class DividendsState {
  const DividendsState();
}

final class DividendsInitial extends DividendsState {
  const DividendsInitial();
}

final class DividendsLoading extends DividendsState {
  const DividendsLoading();
}

final class DividendsLoaded extends DividendsState {
  final DividendResponse dividends;
  const DividendsLoaded(this.dividends);
}

final class DividendsError extends DividendsState {
  final String message;
  const DividendsError(this.message);
}

final class DividendsMetricsLoaded extends DividendsState {
  final DividendMetrics metrics;

  const DividendsMetricsLoaded({required this.metrics});

  List<Object?> get props => [metrics];
} 