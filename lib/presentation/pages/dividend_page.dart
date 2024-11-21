import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/dividends/dividends_bloc.dart';
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
      body: BlocBuilder<DividendsBloc, DividendsState>(
        builder: (context, state) {
          switch (state) {
            case DividendsInitial():
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    context.read<DividendsBloc>().add(
                      const CalculateMetrics(['AAPL', 'MSFT']),
                    );
                  },
                  child: const Text('Load Dividend Metrics'),
                ),
              );
            
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
                child: Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Yearly Dividends: \$${metrics.totalYearlyDividends.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Highest Paying Month: ${metrics.highestPayingMonth}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Amount: \$${metrics.highestMonthlyAmount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    MonthlyDividendsChart(
                      monthlyDividends: metrics.monthlyDividends,
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }
} 