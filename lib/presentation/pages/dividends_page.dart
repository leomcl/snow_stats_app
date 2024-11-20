import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/dividends/dividends_bloc.dart';
import '../widgets/dividends_list_view.dart';

class DividendsPage extends StatelessWidget {
  const DividendsPage({super.key});

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
                      FetchDividends(['AAPL', 'MSFT']),
                    );
                  },
                  child: const Text('Fetch Dividends'),
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
          }
        },
      ),
    );
  }
} 