class StockPriceData {
  final double marketCap;
  final double lastClose;
  final DateTime timestamp;

  StockPriceData({
    required this.marketCap,
    required this.lastClose,
    required this.timestamp,
  });

  factory StockPriceData.fromJson(Map<String, dynamic> json) {
    return StockPriceData(
      marketCap: json['market_cap'].toDouble(),
      lastClose: json['last_close'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'market_cap': marketCap,
      'last_close': lastClose,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class PriceResponse {
  final Map<String, StockPriceData> prices;

  PriceResponse({
    required this.prices,
  });

  factory PriceResponse.fromJson(Map<String, dynamic> json) {
    return PriceResponse(
      prices: json.map(
        (key, value) => MapEntry(
          key,
          StockPriceData.fromJson(value),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return prices.map(
      (key, value) => MapEntry(
        key,
        value.toJson(),
      ),
    );
  }
}
