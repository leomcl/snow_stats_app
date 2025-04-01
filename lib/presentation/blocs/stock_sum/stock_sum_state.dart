import '../../../domain/entities/stock_sum.dart';

abstract class StockSumState {}

class StockSumInitial extends StockSumState {}

class StockSumLoading extends StockSumState {}

class StockSumLoaded extends StockSumState {
  final StockSum stockSum;

  StockSumLoaded(this.stockSum);
}

class StockSumError extends StockSumState {
  final String message;

  StockSumError(this.message);
}
