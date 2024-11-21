import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/dividends/dividends_bloc.dart';
import '../blocs/stock/stock_bloc.dart';
import '../widgets/dividends_list_view.dart';
import '../widgets/monthly_dividends_chart.dart';

class DividendPage extends StatelessWidget {
  const DividendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dividends'),
      ),
      body: BlocBuilder<StockBloc, StockState>(
        builder: (context, stockState) {
          return BlocBuilder<DividendsBloc, DividendsState>(
            builder: (context, state) {
              switch (state) {
                case DividendsInitial():
                  if (stockState is StockLoaded) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<DividendsBloc>().add(
                            CalculateMetrics(stockState.stocks),
                          );
                        },
                        child: const Text('Load Dividend Metrics'),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('Loading stocks...'),
                    );
                  }
                
                case DividendsLoading():
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                
                case DividendsLoaded(:final dividends):
                  return DividendsListView(dividends: dividends);
                
                case DividendsError(:final message):
                  return Center(
                    child: Text('Error: $message'),
                  );

                case DividendsMetricsLoaded(:final metrics):
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.attach_money,
                                        color: Theme.of(context).primaryColor),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Total Yearly Dividends: \$${metrics.totalYearlyDividends.toStringAsFixed(2)}',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                ListTile(
                                  leading: Icon(Icons.calendar_month,
                                      color: Theme.of(context).primaryColor),
                                  title: Text('Highest Paying Month'),
                                  subtitle: Text(
                                    '${metrics.highestPayingMonth} - \$${metrics.highestMonthlyAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: MonthlyDividendsChart(
                              monthlyDividends: metrics.monthlyDividends,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }
} 