import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/repositories/store_repository.dart';

part 'packingSO_state.dart';

class PackingSOCubit extends Cubit<PackingSOState> {
  final StoreRepository _storeRepository;

  PackingSOCubit({required StoreRepository storeRepository})
      : this._storeRepository = storeRepository,
        super(PackingSOInitial());

  Future<void> loadDocpackingSO(String docNo) async {
    emit(PackingSOLoadProducInProgress());
    try {
      final dataResponse = await _storeRepository.fetchSaleSO(docNo);

      final docData = dataResponse.data;
      print(docData);
      List<Product> products = (docData['details'] as List)
          .map((product) => Product.fromMap(product))
          .toList();

      if (products.length > 0) {
        print(products[0].code);
      }

      Store store = Store(
        docNo: docData['docNo'],
        docFormatCode: docData['docFormatCode'],
        docDate: '${docData['docDate']}',
        docTime: docData['docTime'],
        branchCode: docData['branch'] ?? '',
        whCode: docData['warehouse'] ?? '',
        shelfCode: docData['location'] ?? '',
        totalAmount: 0.0,
      );

      store.details = products;

      emit(PackingSOLoadProducSuccess(store: store, products: products));
    } catch (e) {
      print('on catch');
      print(e.toString());
      emit(PackingSOLoadProducFailure(message: e.toString()));
    }
  }
}
