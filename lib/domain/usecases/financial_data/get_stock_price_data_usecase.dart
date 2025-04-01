import 'package:dartz/dartz.dart';
import '../../repositories/stock_data_repository.dart';
import '../../failures/failures.dart';
import '../../../data/models/price_response.dart';


class GetStockPriceDataUsecase {
  final StockDataRepository stockDataRepository;
  
  GetStockPriceDataUsecase(this.stockDataRepository);

  Future<Either<Failure, PriceResponse>> call(List<String> symbols) async {
    return await stockDataRepository.getPrices(symbols);
  }
}
