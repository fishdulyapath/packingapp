import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilepacking/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:mobilepacking/blocs/docdetail/docdetail_bloc.dart';

import 'package:mobilepacking/blocs/productdetail/productdetail_bloc.dart';

import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/productdetail.dart';

import 'package:mobilepacking/repositories/auth_repository.dart';

class ProductDetailListDialog extends StatefulWidget {
  final String txtValue;

  const ProductDetailListDialog({Key? key, required this.txtValue})
      : super(key: key);

  @override
  ProductDetailListDialogState createState() =>
      new ProductDetailListDialogState();
}

class ProductDetailListDialogState extends State<ProductDetailListDialog> {
  @override
  void initState() {
    context.read<ProductDetailBloc>()..add(ProductDetailLoad());

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(247, 166, 245, 1),
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

  Widget itemList(context, List<ProductDetail> products) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: (MediaQuery.of(context).size.height / 100) * 75,
            child: ListView.builder(
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

  Widget itemDetail(BuildContext context, ProductDetail product) {
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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'เลือกสินค้า ${product.itemCode} ~ ${product.itemName}',
                style: TextStyle(color: Colors.green),
              ),
            ),
          );

          context.read<DocdetailBloc>().add(ProductScaned(
              barcode: '', textScan: widget.txtValue + product.itemCode));

          Navigator.of(context).pop();
        },
        title: Text('${product.itemName}'),
        subtitle: Text(
            'รหัส: ${product.itemCode} หน่วยนับ: ${product.unitCode}    ราคา: ${product.price} '),
      ),
    ]));
  }

  Widget productrList(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Column(
          children: <Widget>[
            BlocBuilder<ProductDetailBloc, ProductDetailState>(
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
                      if (state.status !=
                          ProductDetailStateStatus.searchProcess) {
                        context.read<ProductDetailBloc>()
                          ..add(ProductDetailLoad(
                            keyWord: keyword,
                          ));
                      }
                    });
                  },
                );
              },
            ),
            SizedBox(
              height: 5,
            ), //
            BlocBuilder<ProductDetailBloc, ProductDetailState>(
              builder: (context, state) {
                return state.status == ProductDetailStateStatus.searchProcess
                    ? loadSearchProgress()
                    : itemList(context, state.products);
              },
            ),
            BlocBuilder<ProductDetailBloc, ProductDetailState>(
              builder: (context, state) {
                return state.status == ProductDetailStateStatus.inProcess
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
