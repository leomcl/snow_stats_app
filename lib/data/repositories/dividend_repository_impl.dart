import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import '../../domain/repositories/dividend_repository.dart';
import '../../domain/failures/failures.dart';
import '../models/dividend_response.dart';

class DividendRepositoryImpl implements DividendRepository {
  final http.Client client;
  final String baseUrl;

  DividendRepositoryImpl({
    required this.client,
    this.baseUrl = 'http://localhost:8000',
  });

  @override
  Future<Either<Failure, DividendResponse>> getPreviousYearDividends(
      List<String> symbols) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/previous-year-dividends/${symbols.join(',')}'),
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
} 