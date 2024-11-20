import 'package:flutter/material.dart';
import '../../data/models/dividend_response.dart';

class DividendsListView extends StatelessWidget {
  final DividendResponse dividends;

  const DividendsListView({
    super.key,
    required this.dividends,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dividends.dividends.length,
      itemBuilder: (context, index) {
        final symbol = dividends.dividends.keys.elementAt(index);
        final stockDividends = dividends.dividends[symbol]!;

        return ExpansionTile(
          title: Text(symbol),
          children: stockDividends.dividends.map((dividend) {
            return ListTile(
              title: Text('Date: ${dividend.date}'),
              trailing: Text('\$${dividend.amount.toStringAsFixed(2)}'),
            );
          }).toList(),
        );
      },
    );
  }
} 