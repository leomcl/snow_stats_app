import 'package:equatable/equatable.dart';

abstract class FinancialEvent extends Equatable {
  const FinancialEvent();

  @override
  List<Object?> get props => [];
}

class GetFinancialData extends FinancialEvent {
  final String symbol;
  final int year;

  const GetFinancialData(this.symbol, this.year);

  @override
  List<Object?> get props => [symbol, year];
}

class AnalyzeFinancialMetrics extends FinancialEvent {
  final String symbol;
  final int year;

  const AnalyzeFinancialMetrics(this.symbol, this.year);

  @override
  List<Object?> get props => [symbol, year];
}

class CompareFinancialTrends extends FinancialEvent {
  final String symbol;
  final List<int> years;

  const CompareFinancialTrends(this.symbol, this.years);

  @override
  List<Object?> get props => [symbol, years];
}
