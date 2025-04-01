import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/stock.dart';
import '../blocs/stock_sum/stock_sum_bloc.dart';
import '../blocs/stock_sum/stock_sum_event.dart';
import '../blocs/stock_sum/stock_sum_state.dart';

class StockFinancialSummaryPage extends StatelessWidget {
  final Stock stock;

  const StockFinancialSummaryPage({
    super.key,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
    // Fetch data when the page loads using the new StockSumBloc
    context
        .read<StockSumBloc>()
        .add(GetStockSum(stock.ticker, DateTime.now().year - 1));

    return Scaffold(
      appBar: AppBar(
        title: Text('${stock.ticker} Summary'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<StockSumBloc, StockSumState>(
          builder: (context, state) {
            if (state is StockSumLoading || state is StockSumInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is StockSumError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${state.message}',
                        style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<StockSumBloc>().add(
                            GetStockSum(stock.ticker, DateTime.now().year - 1));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is StockSumLoaded) {
              final stockSum = state.stockSum;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stockSum.symbol,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 8),
                            Text('Shares Owned: ${stock.shares}'),
                            const Divider(),
                            _buildHeaderWithStatus(context, 'Financial Summary',
                                stockSum.financialHealthStatus),
                            const SizedBox(height: 16),

                            // Current Price
                            _buildInfoTile(
                              'Current Price',
                              '\$${stockSum.currentPrice.toStringAsFixed(2)}',
                              Icons.show_chart,
                            ),

                            // P/E Ratio
                            _buildInfoTile(
                              'P/E Ratio',
                              stockSum.peRatio > 0
                                  ? stockSum.peRatio.toStringAsFixed(2)
                                  : 'N/A',
                              Icons.calculate,
                            ),

                            // Price to Book Ratio
                            _buildInfoTile(
                              'Price to Book Ratio',
                              stockSum.priceToBookRatio > 0
                                  ? stockSum.priceToBookRatio.toStringAsFixed(2)
                                  : 'N/A',
                              Icons.book,
                            ),

                            // Debt to Equity Ratio
                            _buildInfoTile(
                              'Debt to Equity Ratio',
                              stockSum.debtToEquityRatio > 0
                                  ? stockSum.debtToEquityRatio
                                      .toStringAsFixed(2)
                                  : 'N/A',
                              Icons.account_balance,
                              valueColor: _getValueColor(
                                  stockSum.debtToEquityRatio, true, 2.0, 1.0),
                            ),

                            // Return on Equity
                            _buildInfoTile(
                              'Return on Equity',
                              stockSum.returnOnEquity > 0
                                  ? '${stockSum.returnOnEquity.toStringAsFixed(2)}%'
                                  : 'N/A',
                              Icons.trending_up,
                              valueColor: _getValueColor(
                                  stockSum.returnOnEquity, false, 5, 15),
                            ),

                            // Dividend Yield
                            _buildInfoTile(
                              'Dividend Yield',
                              stockSum.dividendYield > 0
                                  ? '${stockSum.dividendYield.toStringAsFixed(2)}%'
                                  : 'N/A',
                              Icons.attach_money,
                            ),

                            // Revenue Growth
                            _buildInfoTile(
                              'Revenue Growth',
                              stockSum.revenueGrowth != 0
                                  ? '${stockSum.revenueGrowth.toStringAsFixed(2)}%'
                                  : 'N/A',
                              Icons.trending_up,
                              valueColor: _getValueColor(
                                  stockSum.revenueGrowth, false, 0, 10),
                            ),

                            // Profit Margin
                            _buildInfoTile(
                              'Profit Margin',
                              stockSum.profitMargin != 0
                                  ? '${stockSum.profitMargin.toStringAsFixed(2)}%'
                                  : 'N/A',
                              Icons.monetization_on,
                              valueColor: _getValueColor(
                                  stockSum.profitMargin, false, 0, 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: Text('Unexpected state'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildHeaderWithStatus(
      BuildContext context, String title, String status) {
    Color statusColor;

    switch (status.toLowerCase()) {
      case 'strong':
        statusColor = Colors.green;
        break;
      case 'weak':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Chip(
          label: Text(
            status,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: statusColor,
        ),
      ],
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon,
      {Color? valueColor}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: valueColor,
        ),
      ),
    );
  }

  Color? _getValueColor(double value, bool isLowerBetter, double poorThreshold,
      double goodThreshold) {
    if (value <= 0) return null;

    if (isLowerBetter) {
      if (value > poorThreshold) return Colors.red;
      if (value < goodThreshold) return Colors.green;
    } else {
      if (value < poorThreshold) return Colors.red;
      if (value > goodThreshold) return Colors.green;
    }

    return Colors.orange;
  }

  String _formatNumber(num value) {
    final doubleValue = value.toDouble();
    if (doubleValue >= 1000000000) {
      return '${(doubleValue / 1000000000).toStringAsFixed(2)}B';
    } else if (doubleValue >= 1000000) {
      return '${(doubleValue / 1000000).toStringAsFixed(2)}M';
    } else if (doubleValue >= 1000) {
      return '${(doubleValue / 1000).toStringAsFixed(2)}K';
    } else {
      return doubleValue.toStringAsFixed(2);
    }
  }
}
