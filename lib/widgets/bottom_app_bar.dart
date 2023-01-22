import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:mobilepacking/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:mobilepacking/blocs/docdetail/docdetail_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/widgets/product_detail_list.dart';
import 'package:mobilepacking/widgets/product_list.dart';

Future<void> scanBarcodeNormal(BuildContext context, String textScan) async {
  String barcodeScanRes;

  try {
    barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    print('---> $barcodeScanRes');

    context
        .read<DocdetailBloc>()
        .add(ProductScaned(barcode: '', textScan: textScan + barcodeScanRes));
    FlutterBeep.beep();
  } on PlatformException {
    barcodeScanRes = 'Failed to get platform version.';
    FlutterBeep.beep(false);
  }
}

StreamSubscription<dynamic>? tempScan;

Future<void> startBarcodeScanStream(
    BuildContext context, User user, StoreType storeType) async {
  String oldBarcode = "";

  tempScan = FlutterBarcodeScanner.getBarcodeStreamReceiver(
          '#ff6666', 'Cancel', false, ScanMode.DEFAULT)!
      .listen((barcode) {
    if (barcode == '-1') {
      tempScan?.cancel();
    }
    if (oldBarcode != barcode && barcode != '-1') {
      oldBarcode = barcode;
      context.read<StoreBloc>().add(StoreProductScaned(
          barcode: "EE-00001", user: user, storeType: storeType));
      FlutterBeep.beep();
    }
  });
}

Future _openProductListDialog(
    BuildContext context, String txtScanVal, StoreType storeType) async {
  // String itemCode = await
  print("txtScanVal " + txtScanVal);
  Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) {
        return new ProductDetailListDialog(txtValue: txtScanVal);
      },
      fullscreenDialog: true));
  // if (itemCode != null) {
  //   print(itemCode);
  // }
}

Widget buttomAppBar(BuildContext context, StoreType storeType) {
  TextEditingController txtFieldScan = TextEditingController();
  AuthenticationState authenticationState =
      BlocProvider.of<AuthenticationBloc>(context).state;
  User user = User.empty();
  FocusNode myFocusNode = FocusNode();
  if (authenticationState.status == AuthenticationStatus.authenticated) {
    user = authenticationState.user ?? User.empty();
  }
  return Container(
    padding: EdgeInsets.only(top: 15, left: 9, right: 9),
    child: Row(
      children: <Widget>[
        // Edit text
        Flexible(
          child: Container(
            child: TextField(
              autofocus: true,
              focusNode: myFocusNode,
              onSubmitted: (text) {
                context
                    .read<DocdetailBloc>()
                    .add(ProductScaned(barcode: '', textScan: text));
                txtFieldScan.text = '';
                myFocusNode.requestFocus();
              },
              controller: txtFieldScan,
              style: TextStyle(color: Colors.black, fontSize: 18.0),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    context.read<DocdetailBloc>().add(ProductScaned(
                        barcode: '', textScan: txtFieldScan.text));
                    txtFieldScan.text = '';
                  },
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "",
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        // Button send image
        Material(
          child: new Container(
            margin: new EdgeInsets.symmetric(horizontal: 1.0),
            child: new IconButton(
              icon: new Icon(Icons.camera_alt),
              onPressed: () => scanBarcodeNormal(context, txtFieldScan.text),
              color: Colors.blue,
            ),
          ),
          color: Colors.white,
        ),
        Material(
          child: new Container(
            margin: new EdgeInsets.symmetric(horizontal: 1.0),
            child: new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () => _openProductListDialog(
                  context, txtFieldScan.text.toString(), storeType),
              color: Colors.blue,
            ),
          ),
          color: Colors.white,
        ),
      ],
    ),
  );
}
