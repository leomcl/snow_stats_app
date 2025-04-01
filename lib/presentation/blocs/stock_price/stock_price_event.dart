import 'package:equatable/equatable.dart';

abstract class StockPriceEvent extends Equatable {
  const StockPriceEvent();

  @override
  List<Object?> get props => [];
}

class GetStockPriceData extends StockPriceEvent {
  final List<String> symbols;

  const GetStockPriceData(this.symbols);

  @override
  List<Object?> get props => [symbols];
}
