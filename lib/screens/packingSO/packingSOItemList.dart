import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/screens/main_menu.dart';
import 'package:mobilepacking/screens/packingSO/packingSOConfirm.dart';
import 'package:mobilepacking/screens/packingSO/packingSO_products.dart';
import 'package:mobilepacking/util/product_util.dart';
import 'package:mobilepacking/widgets/alert.dart';
import 'package:mobilepacking/widgets/bottom_app_bar.dart';
import 'package:mobilepacking/widgets/cart_item_list.dart';

class PackingSOItemList extends StatefulWidget {
  final String docNo;
  const PackingSOItemList({Key? key, required this.docNo}) : super(key: key);

  @override
  _PackingSOItemListState createState() => _PackingSOItemListState();
}

class _PackingSOItemListState extends State<PackingSOItemList> {
  TextEditingController txtDocNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    txtDocNo.value = TextEditingValue(text: widget.docNo.toString());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(171, 167, 242, 1),
        title: Text(
          'ยืนยันรายการสั่งขาย',
          style: TextStyle(color: Colors.white),
        ),
        leading: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            List<Product> _product =
                state is StoreLoadSuccess ? state.products : <Product>[];
            return IconButton(
                color: Colors.white,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  if (_product.length > 0) {
                    showAlertDialog(context);
                  } else {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => Mainmenu()),
                        (route) => false);
                  }
                });
          },
        ),
        actions: <Widget>[
          IconButton(
              color: Colors.white,
              icon: Icon(Icons.save),
              onPressed: () {
                final storeBloc = context.read<StoreBloc>();
                final storeState = storeBloc.state;
                if (storeState is StoreLoadSuccess) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => packingSOConfirm(
                        docNo: widget.docNo.toString(),
                      ),
                    ),
                  );
                }
              }),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                docnoTextField(),
                SizedBox(
                  height: 5,
                ),
                buttomAppBar(context, StoreType.PackingSO),
                BlocListener<StoreBloc, StoreState>(
                  listener: (context, state) {
                    if (state is StoreScanProductFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${state.message}',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      );
                    }
                  },
                  child: BlocBuilder<StoreBloc, StoreState>(
                    builder: (context, state) {
                      if (state is StoreLoadSuccess) {
                        ProductUtil.checkMatchRefProductList(
                          state.products,
                          state.refProducts,
                        );
                      }
                      return state is StoreLoadSuccess
                          ? cartItemList(
                              context, state.refProducts, 62, state.type)
                          : Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget docnoTextField() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextField(
        style: TextStyle(color: Colors.black),
        controller: txtDocNo,
        decoration: InputDecoration(
          enabled: false,
          labelText: "เลขที่ใบสั่งซื้อ",
          labelStyle: TextStyle(color: Colors.black),
          hintText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  void showWaringpackingSOProduct(int cartProductCount, int refProductCount) {
    Widget content = RichText(
        text: TextSpan(children: [
      TextSpan(
        text: 'รายการรับสินค้าไม่ครบ ',
        style: TextStyle(color: Colors.black),
      ),
      TextSpan(
          text: ' $cartProductCount/$refProductCount',
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pop(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => packingSOProducts()));
            }),
    ]));

    showWarningDialog(context, content: content);
  }
}

showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = ElevatedButton(
    style: ElevatedButton.styleFrom(primary: Colors.red.shade600),
    child: Text("ยกเลิก"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = ElevatedButton(
    child: Text("ตกลง"),
    onPressed: () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Mainmenu()), (route) => false);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Text("ต้องการยกเลิกรายการที่ทำอยู่หรือไม่"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
