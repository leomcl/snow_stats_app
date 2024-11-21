import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../models/dividend_metrics.dart';
import '../repositories/dividend_repository.dart';

class CalculateDividendMetricsUseCase {
  final DividendRepository repository;

  CalculateDividendMetricsUseCase(this.repository);

  Future<Either<Failure, DividendMetrics>> execute(
    List<String> symbols, {
    required Map<String, double> sharesByTicker,
  }) async {
    final dividendResult = await repository.getPreviousYearDividends(symbols);

    return dividendResult.fold(
      (failure) => Left(failure),
      (dividendResponse) {
        try {
          // Initialize array with 12 zeros (one for each month)
          List<double> monthlyTotals = List.filled(12, 0.0);
          
          // Calculate monthly totals
          dividendResponse.dividends.forEach((symbol, stockDividends) {
            for (var dividend in stockDividends.dividends) {
              // Parse string date to DateTime
              final dateTime = DateTime.parse(dividend.date);
              int monthIndex = dateTime.month - 1;
              monthlyTotals[monthIndex] += dividend.amount;
            }
          });

          // Calculate highest month
          double highestAmount = 0.0;
          String highestMonth = '';
          final months = [
            'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
          ];

          for (int i = 0; i < monthlyTotals.length; i++) {
            if (monthlyTotals[i] > highestAmount) {
              highestAmount = monthlyTotals[i];
              highestMonth = months[i];
            }
          }

          // Calculate total yearly dividends
          double totalYearlyDividends = monthlyTotals.reduce((a, b) => a + b);

          return Right(DividendMetrics(
            monthlyDividends: monthlyTotals,
            totalYearlyDividends: totalYearlyDividends,
            highestPayingMonth: highestMonth,
            highestMonthlyAmount: highestAmount,
          ));
        } catch (e) {
          return Left(ServerFailure('Error calculating dividend metrics: ${e.toString()}'));
        }
      },
    );
  }
} 