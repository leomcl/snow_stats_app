import 'package:equatable/equatable.dart';

class Stock extends Equatable {
  final String ticker;
  final int shares;
  final String userId;

  const Stock({
    required this.ticker,
    required this.shares,
    required this.userId,
  });

  @override
  List<Object> get props => [ticker, shares, userId];
} 