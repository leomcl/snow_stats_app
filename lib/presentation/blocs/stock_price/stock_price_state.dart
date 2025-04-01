import 'package:equatable/equatable.dart';
import '../../../data/models/price_response.dart';

abstract class StockPriceState extends Equatable {
  const StockPriceState();

  @override
  List<Object?> get props => [];
}

class StockPriceInitial extends StockPriceState {}

class StockPriceLoading extends StockPriceState {}

class StockPriceError extends StockPriceState {
  final String message;

  const StockPriceError(this.message);

  @override
  List<Object?> get props => [message];
}

class StockPriceLoaded extends StockPriceState {
  final PriceResponse priceData;
  final List<String> symbols;

  const StockPriceLoaded({
    required this.priceData,
    required this.symbols,
  });

  @override
  List<Object?> get props => [priceData, symbols];
}
