import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/di/injection_container.dart' as di;
import 'presentation/pages/home_page.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'firebase_options.dart';
import 'presentation/blocs/stock/stock_bloc.dart';
import 'presentation/blocs/dividends/dividends_bloc.dart';
import 'presentation/blocs/financial/financial_bloc.dart';
import 'presentation/blocs/stock_price/stock_price_bloc.dart';
import 'presentation/blocs/stock_sum/stock_sum_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<StockBloc>(),
        ),
        BlocProvider<DividendsBloc>(
          create: (context) => di.sl<DividendsBloc>(),
        ),
        BlocProvider<FinancialBloc>(
          create: (context) => di.sl<FinancialBloc>(),
        ),
        BlocProvider<StockPriceBloc>(
          create: (context) => di.sl<StockPriceBloc>(),
        ),
        BlocProvider<StockSumBloc>(
          create: (context) => di.sl<StockSumBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
