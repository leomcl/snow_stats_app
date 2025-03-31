import 'package:equatable/equatable.dart';
import '../../../data/models/financial_data.dart';

abstract class FinancialState extends Equatable {
  const FinancialState();

  @override
  List<Object?> get props => [];
}

class FinancialInitial extends FinancialState {}

class FinancialLoading extends FinancialState {}

class FinancialError extends FinancialState {
  final String message;

  const FinancialError(this.message);

  @override
  List<Object?> get props => [message];
}

class FinancialDataLoaded extends FinancialState {
  final FinancialData data;
  final String symbol;
  final int year;

  const FinancialDataLoaded({
    required this.data,
    required this.symbol,
    required this.year,
  });

  @override
  List<Object?> get props => [data, symbol, year];
}

class FinancialMetricsLoaded extends FinancialState {
  final String symbol;
  final int year;

  const FinancialMetricsLoaded({
    required this.symbol,
    required this.year,
  });

}

class FinancialTrendsLoaded extends FinancialState {
  final String symbol;

  const FinancialTrendsLoaded({
    required this.symbol,
  });

}
