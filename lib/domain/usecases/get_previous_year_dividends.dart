import 'package:dartz/dartz.dart';
import '../repositories/dividend_repository.dart';
import '../failures/failures.dart';
import '../../data/models/dividend_response.dart';

class GetPreviousYearDividends {
  final DividendRepository repository;

  GetPreviousYearDividends(this.repository);

  Future<Either<Failure, DividendResponse>> call(List<String> symbols) async {
    return await repository.getPreviousYearDividends(symbols);
  }
} 