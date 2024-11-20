import '../repositories/stock_repository.dart';

class DeleteStockUseCase {
  final StockRepository repository;

  DeleteStockUseCase(this.repository);

  Future<void> execute(String ticker, String userId) {
    return repository.deleteStock(ticker, userId);
  }
} 