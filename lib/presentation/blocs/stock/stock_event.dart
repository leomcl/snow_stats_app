part of 'stock_bloc.dart';

abstract class StockEvent extends Equatable {
  const StockEvent();

  @override
  List<Object> get props => [];
}

class LoadStocks extends StockEvent {}

class AddStock extends StockEvent {
  final String ticker;
  final int shares;

  const AddStock({required this.ticker, required this.shares});

  @override
  List<Object> get props => [ticker, shares];
}

class DeleteStock extends StockEvent {
  final String ticker;
  final String userId;

  const DeleteStock({required this.ticker, required this.userId});

  @override
  List<Object> get props => [ticker, userId];
}

class _UpdateStocks extends StockEvent {
  final List<Stock> stocks;

  const _UpdateStocks(this.stocks);

  @override
  List<Object> get props => [stocks];
} 