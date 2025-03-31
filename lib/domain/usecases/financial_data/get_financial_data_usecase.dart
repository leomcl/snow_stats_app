import 'package:dartz/dartz.dart';
import '../../repositories/stock_data_repository.dart';
import '../../failures/failures.dart';
import '../../../data/models/financial_data.dart';

class GetFinancialDataUseCase {
  final StockDataRepository repository;

  GetFinancialDataUseCase(this.repository);

  Future<Either<Failure, FinancialData>> call(String symbol, int year) async {
    return await repository.getFinancialData(symbol, year);
  }
}
