import 'package:get_it/get_it.dart';
import '../../data/repositories/message_repository_impl.dart';
import '../../data/repositories/stock_repository_impl.dart';
import '../../domain/repositories/message_repository.dart';
import '../../domain/usecases/get_message_usecase.dart';
import '../../presentation/blocs/message/message_bloc.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../data/datasources/remote/stock_remote_data_source.dart';
import '../../domain/repositories/stock_repository.dart';
import '../../domain/usecases/get_stocks_usecase.dart';
import '../../domain/usecases/add_stock_usecase.dart';
import '../../domain/usecases/delete_stock_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../presentation/blocs/stock/stock_bloc.dart';
import '../../presentation/blocs/dividends/dividends_bloc.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../domain/repositories/dividend_repository.dart';
import '../../data/repositories/dividend_repository_impl.dart';
import '../../domain/usecases/get_previous_year_dividends.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => MessageBloc(sl()));
  sl.registerFactory(() => AuthBloc());
  sl.registerFactory(
    () => DividendsBloc(
      getPreviousYearDividends: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetPreviousYearDividends(sl()));

  // Repositories
  sl.registerLazySingleton<MessageRepository>(() => MessageRepositoryImpl());
  sl.registerLazySingleton<DividendRepository>(
    () => DividendRepositoryImpl(client: sl()),
  );

  // Data sources
  sl.registerLazySingleton<StockRemoteDataSource>(
    () => StockRemoteDataSourceImpl(firestore: FirebaseFirestore.instance),
  );

  // Repositories
  sl.registerLazySingleton<StockRepository>(
    () => StockRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetStocksUseCase(sl()));
  sl.registerLazySingleton(() => AddStockUseCase(sl()));
  sl.registerLazySingleton(() => DeleteStockUseCase(sl()));

  // Blocs
  sl.registerFactory(
    () => StockBloc(
      getStocksUseCase: sl(),
      addStockUseCase: sl(),
      deleteStockUseCase: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
} 