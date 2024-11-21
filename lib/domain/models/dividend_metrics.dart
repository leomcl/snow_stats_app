class DividendMetrics {
  final List<double> monthlyDividends;
  final double totalYearlyDividends;
  final String highestPayingMonth;
  final double highestMonthlyAmount;

  const DividendMetrics({
    required this.monthlyDividends,
    required this.totalYearlyDividends,
    required this.highestPayingMonth,
    required this.highestMonthlyAmount,
  });
} 