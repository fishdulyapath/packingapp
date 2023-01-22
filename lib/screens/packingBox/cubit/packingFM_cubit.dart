import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/repositories/store_repository.dart';
import 'package:mobilepacking/global.dart' as globals;
import 'package:mobilepacking/screens/packingBox/packbox_detail.dart';
part 'packingFM_state.dart';

class PackingFMCubit extends Cubit<PackingFMState> {
  final StoreRepository _storeRepository;

  PackingFMCubit({required StoreRepository storeRepository})
      : this._storeRepository = storeRepository,
        super(PackingFMInitial());

  Future<void> loadDocpackingFM(String docNo) async {
    try {
      final dataResponse = await _storeRepository.fetchDocdetail(docNo);

      final docData = dataResponse.data;
      print(docData);

      globals.productDetail = (dataResponse.data as List)
          .map((product) => Product.fromMap(product))
          .toList();

      List<Product> products = (dataResponse.data as List)
          .map((product) => Product.fromMap(product))
          .toList();
    } catch (e) {
      print('on catch');
      print(e.toString());
    }
  }
}
