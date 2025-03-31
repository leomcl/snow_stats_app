
class FinancialData {
  final String ticker;
  final int year;
  final String cik;
  final FinancialMetrics data;

  FinancialData({
    required this.ticker,
    required this.year,
    required this.cik,
    required this.data,
  });

  factory FinancialData.fromJson(Map<String, dynamic> json) {
    return FinancialData(
      ticker: json['ticker'] as String,
      year: json['year'] as int,
      cik: json['cik'] as String,
      data: FinancialMetrics.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class FinancialMetrics {
  final List<FinancialMetric> revenue;
  final List<FinancialMetric> costOfGoodsSold;
  final List<FinancialMetric> netIncome;
  final List<FinancialMetric> liabilities;
  final List<FinancialMetric> assets;
  final List<FinancialMetric> operatingExpenses;
  final List<FinancialMetric> cashFlow;
  final List<FinancialMetric> operatingIncome;
  final List<FinancialMetric> debt;
  final List<FinancialMetric> shareholderEquity;
  final List<FinancialMetric> dividendsPerShare;

  FinancialMetrics({
    required this.revenue,
    required this.costOfGoodsSold,
    required this.netIncome,
    required this.liabilities,
    required this.assets,
    required this.operatingExpenses,
    required this.cashFlow,
    required this.operatingIncome,
    required this.debt,
    required this.shareholderEquity,
    required this.dividendsPerShare,
  });

  factory FinancialMetrics.fromJson(Map<String, dynamic> json) {
    return FinancialMetrics(
      revenue: (json['Revenue'] as List)
          .map((e) => FinancialMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      costOfGoodsSold: (json['CostOfGoodsSold'] as List)
          .map((e) => FinancialMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      netIncome: (json['NetIncome'] as List)
          .map((e) => FinancialMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      liabilities: (json['Liabilities'] as List)
          .map((e) => FinancialMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      assets: (json['Assets'] as List)
          .map((e) => FinancialMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      operatingExpenses: (json['OperatingExpenses'] as List)
          .map((e) => FinancialMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      cashFlow: (json['CashFlow'] as List)
          .map((e) => FinancialMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      operatingIncome: (json['OperatingIncome'] as List)
          .map((e) => FinancialMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      debt: (json['Debt'] as List)
          .map((e) => FinancialMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      shareholderEquity: (json['ShareholderEquity'] as List)
          .map((e) => FinancialMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
      dividendsPerShare: (json['DividendsPerShare'] as List)
          .map((e) => FinancialMetric.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class FinancialMetric {
  final String unit;
  final String? start;
  final String end;
  final double value;
  final String form;
  final String fp;
  final String tag;
  final String reportType;

  FinancialMetric({
    required this.unit,
    this.start,
    required this.end,
    required this.value,
    required this.form,
    required this.fp,
    required this.tag,
    required this.reportType,
  });

  factory FinancialMetric.fromJson(Map<String, dynamic> json) {
    return FinancialMetric(
      unit: json['unit'] as String,
      start: json['start'] as String?,
      end: json['end'] as String,
      value: (json['value'] as num).toDouble(),
      form: json['form'] as String,
      fp: json['fp'] as String,
      tag: json['tag'] as String,
      reportType: json['report_type'] as String,
    );
  }
}
