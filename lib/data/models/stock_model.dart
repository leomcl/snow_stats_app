import '../../domain/entities/stock.dart';

class StockModel extends Stock {
  StockModel({
    required String ticker,
    required int shares,
    required String userId,
  }) : super(
          ticker: ticker,
          shares: shares,
          userId: userId,
        );

  factory StockModel.fromMap(Map<String, dynamic> map) {
    return StockModel(
      ticker: map['ticker'],
      shares: map['shares'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticker': ticker,
      'shares': shares,
      'userId': userId,
    };
  }

  factory StockModel.fromEntity(Stock stock) {
    return StockModel(
      ticker: stock.ticker,
      shares: stock.shares,
      userId: stock.userId,
    );
  }
} 