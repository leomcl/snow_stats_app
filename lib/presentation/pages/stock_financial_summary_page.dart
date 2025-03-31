import 'package:flutter/material.dart';
import '../../domain/entities/stock.dart';

class StockFinancialSummaryPage extends StatelessWidget {
  final Stock stock;

  const StockFinancialSummaryPage({
    super.key,
    required this.stock,
  });

  @override
  Widget build(BuildContext context) {
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
                      stock.ticker,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('Shares Owned: ${stock.shares}'),
                    const Divider(),
                    // Here you would add more financial details fetched from your API
                    const Text('Financial Summary',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 8),
                    // Placeholder for financial data
                    const ListTile(
                      leading: Icon(Icons.trending_up),
                      title: Text('Market Cap'),
                      subtitle: Text('Loading...'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.show_chart),
                      title: Text('P/E Ratio'),
                      subtitle: Text('Loading...'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.attach_money),
                      title: Text('Dividend Yield'),
                      subtitle: Text('Loading...'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.assessment),
                      title: Text('52-Week Range'),
                      subtitle: Text('Loading...'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
