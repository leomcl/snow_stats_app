import '../repositories/stock_repository.dart';
import '../entities/stock.dart';

class AddStockUseCase {
  final StockRepository repository;

  AddStockUseCase(this.repository);

  Future<void> execute(Stock stock) {
    return repository.addStock(stock);
  }
} 