abstract class StockSumEvent {}

class GetStockSum extends StockSumEvent {
  final String symbol;
  final int year;

  GetStockSum(this.symbol, this.year);
}
