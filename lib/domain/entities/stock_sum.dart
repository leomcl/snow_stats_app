class StockSum {
  final String symbol;
  final double currentPrice;
  final double peRatio;
  final double priceToBookRatio;
  final double debtToEquityRatio;
  final double returnOnEquity;
  final double dividendYield;
  final double revenueGrowth;
  final double profitMargin;
  final String financialHealthStatus;

  StockSum({
    required this.symbol,
    required this.currentPrice,
    required this.peRatio,
    required this.priceToBookRatio,
    required this.debtToEquityRatio,
    required this.returnOnEquity,
    required this.dividendYield,
    required this.revenueGrowth,
    required this.profitMargin,
    required this.financialHealthStatus,
  });
}
