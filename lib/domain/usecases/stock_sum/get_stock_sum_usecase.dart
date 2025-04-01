import 'package:dartz/dartz.dart';
import '../../failures/failures.dart';
import '../../entities/stock_sum.dart';
import '../financial_data/get_financial_data_usecase.dart';
import '../financial_data/get_stock_price_data_usecase.dart';

class GetStockSumUseCase {
  final GetFinancialDataUseCase financialDataUseCase;
  final GetStockPriceDataUsecase priceDataUseCase;

  GetStockSumUseCase({
    required this.financialDataUseCase,
    required this.priceDataUseCase,
  });

  Future<Either<Failure, StockSum>> call(String symbol, int year) async {
    // Get financial data
    final financialDataResult = await financialDataUseCase(symbol, year);

    // Get current price data
    final priceDataResult = await priceDataUseCase([symbol]);

    return financialDataResult.fold(
      (failure) => Left(failure),
      (financialData) {
        return priceDataResult.fold(
          (failure) => Left(failure),
          (priceData) {
            final stockPriceData = priceData.prices[symbol];
            if (stockPriceData == null) {
              return Left(
                  CalculationFailure('No price data found for $symbol'));
            }

            final currentPrice = stockPriceData.lastClose;

            // Get the most recent values from the metrics lists
            final earningsPerShare =
                financialData.data.earningsPerShare.isNotEmpty
                    ? financialData.data.earningsPerShare.last.value
                    : 0.0;

            final revenue = financialData.data.revenue.isNotEmpty
                ? financialData.data.revenue.last.value
                : 0.0;

            final netIncome = financialData.data.netIncome.isNotEmpty
                ? financialData.data.netIncome.last.value
                : 0.0;

            final totalAssets = financialData.data.assets.isNotEmpty
                ? financialData.data.assets.last.value
                : 0.0;

            final totalLiabilities = financialData.data.liabilities.isNotEmpty
                ? financialData.data.liabilities.last.value
                : 0.0;

            final totalEquity = financialData.data.shareholderEquity.isNotEmpty
                ? financialData.data.shareholderEquity.last.value
                : 0.0;

            final totalDebt = financialData.data.debt.isNotEmpty
                ? financialData.data.debt.last.value
                : 0.0;

            final dividendPerShare =
                financialData.data.dividendsPerShare.isNotEmpty
                    ? financialData.data.dividendsPerShare.last.value
                    : 0.0;

            // Get previous year revenue for growth calculation
            final previousYearRevenue = financialData.data.revenue.length > 1
                ? financialData
                    .data.revenue[financialData.data.revenue.length - 2].value
                : 0.0;

            // Calculate book value per share (rough estimate as we don't have shares outstanding)
            final bookValuePerShare =
                totalEquity > 0 && stockPriceData.marketCap > 0
                    ? totalEquity / (stockPriceData.marketCap / currentPrice)
                    : 0.0;

            // Calculate financial ratios
            final peRatio =
                earningsPerShare != 0 ? currentPrice / earningsPerShare : 0.0;

            final priceToBookRatio =
                bookValuePerShare != 0 ? currentPrice / bookValuePerShare : 0.0;

            final debtToEquityRatio =
                totalEquity != 0 ? totalDebt / totalEquity : 0.0;

            final returnOnEquity =
                totalEquity != 0 ? (netIncome / totalEquity) * 100 : 0.0;

            final dividendYield = currentPrice != 0
                ? (dividendPerShare / currentPrice) * 100
                : 0.0;

            final revenueGrowth = previousYearRevenue != 0
                ? ((revenue - previousYearRevenue) / previousYearRevenue) * 100
                : 0.0;

            final profitMargin =
                revenue != 0 ? (netIncome / revenue) * 100 : 0.0;

            // Determine financial health status
            String healthStatus = "Neutral";
            if (peRatio > 0 &&
                peRatio < 15 &&
                debtToEquityRatio < 1.0 &&
                returnOnEquity > 15 &&
                profitMargin > 10) {
              healthStatus = "Strong";
            } else if (debtToEquityRatio > 2.0 || profitMargin < 0) {
              healthStatus = "Weak";
            }

            // Create and return the StockSum entity
            return Right(StockSum(
              symbol: symbol,
              currentPrice: currentPrice,
              peRatio: peRatio,
              priceToBookRatio: priceToBookRatio,
              debtToEquityRatio: debtToEquityRatio,
              returnOnEquity: returnOnEquity,
              dividendYield: dividendYield,
              revenueGrowth: revenueGrowth,
              profitMargin: profitMargin,
              financialHealthStatus: healthStatus,
            ));
          },
        );
      },
    );
  }
}
