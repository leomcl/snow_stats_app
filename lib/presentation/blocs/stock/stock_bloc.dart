import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../../../domain/entities/stock.dart';
import '../../../domain/usecases/get_stocks_usecase.dart';
import '../../../domain/usecases/add_stock_usecase.dart';
import '../../../domain/usecases/delete_stock_usecase.dart';

part 'stock_event.dart';
part 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final GetStocksUseCase _getStocksUseCase;
  final AddStockUseCase _addStockUseCase;
  final DeleteStockUseCase _deleteStockUseCase;
  final FirebaseAuth _auth;
  StreamSubscription? _stocksSubscription;

  StockBloc({
    required GetStocksUseCase getStocksUseCase,
    required AddStockUseCase addStockUseCase,
    required DeleteStockUseCase deleteStockUseCase,
    FirebaseAuth? auth,
  })  : _getStocksUseCase = getStocksUseCase,
        _addStockUseCase = addStockUseCase,
        _deleteStockUseCase = deleteStockUseCase,
        _auth = auth ?? FirebaseAuth.instance,
        super(StockInitial()) {
    on<LoadStocks>(_onLoadStocks);
    on<AddStock>(_onAddStock);
    on<DeleteStock>(_onDeleteStock);
    on<_UpdateStocks>(_onUpdateStocks);
  }

  Future<void> _onLoadStocks(LoadStocks event, Emitter<StockState> emit) async {
    emit(StockLoading());
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        emit(const StockError('User not authenticated'));
        return;
      }

      await _stocksSubscription?.cancel();
      _stocksSubscription = _getStocksUseCase
          .execute(userId)
          .listen((stocks) {
        if (!isClosed) {
          add(_UpdateStocks(stocks));
        }
      });
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  Future<void> _onAddStock(AddStock event, Emitter<StockState> emit) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        emit(const StockError('User not authenticated'));
        return;
      }

      final stock = Stock(
        ticker: event.ticker.toUpperCase(),
        shares: event.shares,
        userId: userId,
      );

      await _addStockUseCase.execute(stock);
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  Future<void> _onDeleteStock(DeleteStock event, Emitter<StockState> emit) async {
    try {
      await _deleteStockUseCase.execute(event.ticker, event.userId);
    } catch (e) {
      emit(StockError(e.toString()));
    }
  }

  Future<void> _onUpdateStocks(_UpdateStocks event, Emitter<StockState> emit) async {
    emit(StockLoaded(event.stocks));
  }

  @override
  Future<void> close() {
    _stocksSubscription?.cancel();
    return super.close();
  }
} 