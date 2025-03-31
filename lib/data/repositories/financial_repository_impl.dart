import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../domain/repositories/financial_repository.dart';
import '../../domain/failures/failures.dart';
import '../models/financial_data.dart';

class FinancialRepositoryImpl implements FinancialRepository {
  final http.Client client;
  final String baseUrl;

  FinancialRepositoryImpl({
    required this.client,
    this.baseUrl = 'http://localhost:8000',
  });

  @override
  Future<Either<Failure, FinancialData>> getFinancialData(
      String symbol, int year) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/financial/$symbol').replace(
          queryParameters: {'year': year.toString()},
        ),
      );

      if (response.statusCode == 200) {
        return Right(
          FinancialData.fromJson(json.decode(response.body)),
        );
      } else {
        return Left(
          ServerFailure('Server error: ${response.statusCode}'),
        );
      }
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
