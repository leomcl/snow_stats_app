import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../../data/models/dividend_response.dart';

abstract class DividendRepository {
  Future<Either<Failure, DividendResponse>> getPreviousYearDividends(List<String> symbols);
} 