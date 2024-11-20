import '../entities/stock.dart';

abstract class StockRepository {
  Stream<List<Stock>> getStocks(String userId);
  Future<void> addStock(Stock stock);
  Future<void> deleteStock(String ticker, String userId);
} 