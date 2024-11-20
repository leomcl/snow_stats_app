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

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => MessageBloc(sl()));
  sl.registerFactory(() => AuthBloc());

  // Use cases
  sl.registerLazySingleton(() => GetMessageUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<MessageRepository>(() => MessageRepositoryImpl());

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
} 