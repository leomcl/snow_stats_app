import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/stock_model.dart';

abstract class StockRemoteDataSource {
  Stream<List<StockModel>> getStocks(String userId);
  Future<void> addStock(StockModel stock);
  Future<void> deleteStock(String ticker, String userId);
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  final FirebaseFirestore firestore;

  StockRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<StockModel>> getStocks(String userId) {
    return firestore
        .collection('stocks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => StockModel.fromMap(doc.data()))
            .toList());
  }

  @override
  Future<void> addStock(StockModel stock) async {
    await firestore.collection('stocks').add(stock.toMap());
  }

  @override
  Future<void> deleteStock(String ticker, String userId) async {
    final snapshot = await firestore
        .collection('stocks')
        .where('userId', isEqualTo: userId)
        .where('ticker', isEqualTo: ticker)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
} 