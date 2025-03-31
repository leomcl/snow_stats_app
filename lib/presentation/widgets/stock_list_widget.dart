import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/stock/stock_bloc.dart';
import '../pages/stock_financial_summary_page.dart';

class StockListWidget extends StatelessWidget {
  const StockListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StockBloc, StockState>(
      builder: (context, state) {
        if (state is StockLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is StockError) {
          return Center(child: Text(state.message));
        }

        if (state is StockLoaded) {
          if (state.stocks.isEmpty) {
            return const Center(child: Text('No stocks added yet'));
          }

          return ListView.builder(
            itemCount: state.stocks.length,
            itemBuilder: (context, index) {
              final stock = state.stocks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(stock.ticker[0]),
                  ),
                  title: Text(stock.ticker),
                  subtitle: Text('${stock.shares} shares'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<StockBloc>().add(
                            DeleteStock(
                              ticker: stock.ticker,
                              userId: stock.userId,
                            ),
                          );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StockFinancialSummaryPage(
                          stock: stock,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
