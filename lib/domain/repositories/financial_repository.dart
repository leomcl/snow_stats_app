import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../../data/models/financial_data.dart';


abstract class FinancialRepository {
  Future<Either<Failure, FinancialData>> getFinancialData(String symbol, int year);
}

