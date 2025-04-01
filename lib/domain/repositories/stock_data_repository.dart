import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../../data/models/financial_data.dart';
import '../../data/models/dividend_response.dart';
import '../../data/models/price_response.dart';

abstract class StockDataRepository {
  Future<Either<Failure, FinancialData>> getFinancialData(
      String symbol, int year);

  Future<Either<Failure, DividendResponse>> getPreviousYearDividends(
      List<String> symbols);

  Future<Either<Failure, PriceResponse>> getPrices(List<String> symbols);
}
