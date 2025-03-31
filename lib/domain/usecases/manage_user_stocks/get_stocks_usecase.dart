import '../../repositories/stock_repository.dart';
import '../../entities/stock.dart';

class GetStocksUseCase {
  final StockRepository repository;

  GetStocksUseCase(this.repository);

  Stream<List<Stock>> execute(String userId) {
    return repository.getStocks(userId);
  }
} 