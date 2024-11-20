class DividendResponse {
  final Map<String, StockDividends> dividends;

  DividendResponse({required this.dividends});

  factory DividendResponse.fromJson(Map<String, dynamic> json) {
    Map<String, StockDividends> dividendMap = {};
    
    json.forEach((symbol, data) {
      dividendMap[symbol] = StockDividends.fromJson(data);
    });

    return DividendResponse(dividends: dividendMap);
  }
}

class StockDividends {
  final List<DividendEntry> dividends;

  StockDividends({required this.dividends});

  factory StockDividends.fromJson(Map<String, dynamic> json) {
    var dividendsList = (json['dividends'] as List)
        .map((entry) => DividendEntry.fromJson(entry))
        .toList();

    return StockDividends(dividends: dividendsList);
  }
}

class DividendEntry {
  final String date;
  final double amount;

  DividendEntry({required this.date, required this.amount});

  factory DividendEntry.fromJson(List<dynamic> json) {
    return DividendEntry(
      date: json[0],
      amount: json[1].toDouble(),
    );
  }
} 