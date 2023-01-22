import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilepacking/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:mobilepacking/blocs/product/product_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';

class ProductListDialog extends StatefulWidget {
  final String txtValue;
  final StoreType storeType;
  const ProductListDialog(
      {Key? key, required this.txtValue, required this.storeType})
      : super(key: key);

  @override
  ProductListDialogState createState() => new ProductListDialogState();
}

class ProductListDialogState extends State<ProductListDialog> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    context.read<ProductBloc>()
      ..add(ProductLoad(newLoad: true, storeType: widget.storeType));
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      ProductBloc productBloc = context.read<ProductBloc>();
      if (productBloc.state.page.currentPage < productBloc.state.page.maxPage) {
        productBloc
            .add(ProductLoad(newLoad: false, storeType: widget.storeType));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(171, 167, 242, 1),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(""),
        ),
        title: const Text(
          'เลือกสินค้า',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: productrList(context),
      ),
    );
  }

  Widget itemList(context, List<Product> products) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: (MediaQuery.of(context).size.height / 100) * 75,
            child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  return itemDetail(context, products[index]);
                }),
          ),
        )
      ],
    );
  }

  Widget itemDetail(BuildContext context, Product product) {
    AuthenticationState authenticationState =
        BlocProvider.of<AuthenticationBloc>(context).state;
    User user = User.empty();

    if (authenticationState.status == AuthenticationStatus.authenticated) {
      user = authenticationState.user ?? User.empty();
    }
    return new Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        onTap: () {
          double _qty = 1;
          if (widget.txtValue.isNotEmpty) {
            final String numbervalue = widget.txtValue.split("*")[0];

            _qty = double.parse(numbervalue);
          }

          if (product.icSerialNo) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'เป็นสินค้า Serial ให้ทำการ Scan Serial Number เท่านั้น',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'เพิ่มสินค้า ${product.code} ~ ${product.name}',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            );

            context
                .read<StoreBloc>()
                .add(StoreProductAded(product: product, qty: _qty, user: user));
          }

          Navigator.of(context).pop();
        },
        title: Text('${product.name}'),
        subtitle: Text('หน่วยนับ: EA   ราคา: 150 '),
      ),
    ]));
  }

  Widget productrList(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Column(
          children: <Widget>[
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return TextField(
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'ค้นหารายการสินค้า',
                    labelText: 'ค้นหา',
                  ),
                  onChanged: (keyword) {
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      if (state.status != ProductStateStatus.searchProcess) {
                        context.read<ProductBloc>()
                          ..add(ProductLoad(
                              newLoad: true,
                              keyWord: keyword,
                              isSearch: true,
                              storeType: widget.storeType));
                      }
                    });
                  },
                );
              },
            ),
            SizedBox(
              height: 5,
            ), //
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return state.status == ProductStateStatus.searchProcess
                    ? loadSearchProgress()
                    : itemList(context, state.products);
              },
            ),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                return state.status == ProductStateStatus.inProcess
                    ? loadProgress()
                    : Container();
              },
            ),
          ],
        ));
  }

  Widget loadProgress() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: LinearProgressIndicator(
        minHeight: 7,
      ),
    );
  }

  Widget loadSearchProgress() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      child: CircularProgressIndicator(),
    );
  }
}
