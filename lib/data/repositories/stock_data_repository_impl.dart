import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../domain/repositories/stock_data_repository.dart';
import '../../domain/failures/failures.dart';
import '../models/financial_data.dart';
import '../models/dividend_response.dart';
import '../models/price_response.dart';

class StockDataRepositoryImpl implements StockDataRepository {
  final http.Client client;
  final String baseUrl;

  StockDataRepositoryImpl({
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

  @override
  Future<Either<Failure, DividendResponse>> getPreviousYearDividends(
      List<String> symbols) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/forecasted-dividends/${symbols.join(',')}'),
      );

      if (response.statusCode == 200) {
        return Right(
          DividendResponse.fromJson(json.decode(response.body)),
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

  @override
  Future<Either<Failure, PriceResponse>> getPrices(List<String> symbols) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/price/${symbols.join(',')}'),
      );

      if (response.statusCode == 200) {
        return Right(
          PriceResponse.fromJson(json.decode(response.body)),
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
