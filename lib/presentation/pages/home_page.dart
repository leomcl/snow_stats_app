import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dividend_page.dart';
import '../blocs/auth/auth_bloc.dart';
import 'login_page.dart';
import '../widgets/stock_list_widget.dart';
import '../blocs/stock/stock_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _tickerController = TextEditingController();
  final _sharesController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  

  @override
  void initState() {
    super.initState();
    context.read<StockBloc>().add(LoadStocks());
  }

  Future<void> _addStock() async {
    if (_formKey.currentState!.validate()) {
      context.read<StockBloc>().add(
            AddStock(
              ticker: _tickerController.text.toUpperCase(),
              shares: int.parse(_sharesController.text),
            ),
          );

      _tickerController.clear();
      _sharesController.clear();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage() {
    switch (_selectedIndex) {
      case 0:
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _tickerController,
                        decoration: const InputDecoration(
                          labelText: 'Ticker Symbol',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a ticker';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _sharesController,
                        decoration: const InputDecoration(
                          labelText: 'Number of Shares',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter shares';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: _addStock,
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: StockListWidget(),
            ),
          ],
        );
      case 1:
        return const DividendPage();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snow Stats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: _getPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Dividends',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _tickerController.dispose();
    _sharesController.dispose();
    super.dispose();
  }
} 