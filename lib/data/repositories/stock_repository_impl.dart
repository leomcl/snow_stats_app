import '../../domain/repositories/stock_repository.dart';
import '../datasources/remote/stock_remote_data_source.dart';
import '../models/stock_model.dart';
import '../../domain/entities/stock.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource remoteDataSource;

  StockRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<Stock>> getStocks(String userId) {
    return remoteDataSource.getStocks(userId);
  }

  @override
  Future<void> addStock(Stock stock) async {
    await remoteDataSource.addStock(StockModel.fromEntity(stock));
  }

  @override
  Future<void> deleteStock(String ticker, String userId) async {
    await remoteDataSource.deleteStock(ticker, userId);
  }
} 