import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/data/struct/product.dart';

class packingSOProducts extends StatelessWidget {
  const packingSOProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการรับสินค้า'),
      ),
      body: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          return state is StoreLoadSuccess
              ? ListView.builder(
                  itemCount: state.refProducts.length,
                  itemBuilder: (context, index) {
                    Product product = state.refProducts[index];
                    return ListTile(
                      leading: Icon(
                        Icons.check_circle_outline,
                        color: isProductInpackingSO(state.products, product)
                            ? Colors.green
                            : Colors.grey,
                        size: 40.0,
                      ),
                      title: Text('${product.code}'),
                      subtitle: Text(product.name),
                    );
                  },
                )
              : Container();
        },
      ),
    );
  }

  bool isProductInpackingSO(List<Product> productCart, Product productRef) {
    int productIdx =
        productCart.indexWhere((product) => product.code == productRef.code);
    return productIdx != -1;
  }
}
