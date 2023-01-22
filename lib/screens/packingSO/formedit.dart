import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/data/struct/product.dart';

class EditWithdraw extends StatefulWidget {
  final Product product;

  const EditWithdraw({Key? key, required this.product}) : super(key: key);

  @override
  _EditWithdrawState createState() => _EditWithdrawState();
}

class _EditWithdrawState extends State<EditWithdraw> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  double qty = 0;
  List<String> items = ["sn00001", "sn00002", "sn00003"];
  bool isVisi = true;

  void addQty(BuildContext context) {
    setState(() {
      this.qty = this.qty + 1;
      this.isVisi = true;
      context.read<StoreBloc>()
        ..add(StoreProductQtyIncreased(
            productCode: widget.product.code,
            unitCode: widget.product.unitCode));
    });
  }

  void removeQty(BuildContext context) {
    setState(() {
      if (this.qty > 1) {
        this.qty = this.qty - 1;
        context.read<StoreBloc>()
          ..add(StoreProductQtyDecreased(
              productCode: widget.product.code,
              unitCode: widget.product.unitCode));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    final storeState = context.read<StoreBloc>().state;
    if (storeState is StoreLoadSuccess) {
      Product productSelected = storeState.products.firstWhere(
          (element) => element.code == widget.product.code,
          orElse: () => Product.empty());

      if (productSelected.code != '') {
        this.qty = productSelected.qty;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(171, 167, 242, 1),
        centerTitle: true,
        title: Text(
          widget.product.name,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(7),
            child: Column(
              children: <Widget>[
                itemName(),
                inputQty(context),
                scanSN(context),
                BlocConsumer<StoreBloc, StoreState>(
                  buildWhen: (previous, current) {
                    if (previous is StoreLoadInProgress &&
                        current is StoreLoadSuccess) {
                      return true;
                    } else {
                      return false;
                    }
                  },
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is StoreLoadSuccess) {
                      Product tempProduct = state.products.firstWhere(
                          (product) => product.code == widget.product.code);

                      if (state.type == StoreType.PackingSO) {
                        Product tempRefProduct = state.refProducts.firstWhere(
                            (product) => product.code == widget.product.code);
                        return serialListPackingSO(
                            context, tempProduct, tempRefProduct);
                      } else {
                        return serialList(context, tempProduct);
                      }
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => scanBarcodeNormal(context),
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(130.0, 45.0)),
                      icon: Icon(Icons.camera_alt),
                      label: Text("สแกน"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<StoreBloc>()
                          ..add(StoreProductRemoved(
                              productCode: widget.product.code,
                              unitCode: widget.product.unitCode));
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade600,
                        fixedSize: Size(130.0, 45.0),
                        // textStyle: const TextStyle(fontSize: 18),
                      ),
                      icon: Icon(Icons.delete),
                      label: Text("ลบสินค้า"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget btnDelete(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          width: 130,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.red.shade600,
                textStyle: const TextStyle(fontSize: 18)),
            onPressed: () {
              context.read<StoreBloc>()
                ..add(StoreProductRemoved(
                    productCode: widget.product.code,
                    unitCode: widget.product.unitCode));
              Navigator.of(context).pop();
            },
            child: Row(
              // Replace with a Row for horizontal icon + text
              children: <Widget>[Icon(Icons.delete), Text("ลบสินค้า")],
            ),
          ),
        ),
      ),
    );
  }

  Widget serialList(BuildContext context, Product product) {
    return product.serialNumbers.length > 0
        ? Container(
            height: (MediaQuery.of(context).size.height / 100) * 55,
            child: ListView.builder(
              itemCount: product.serialNumbers.length,
              itemBuilder: (context, index) {
                final serial = product.serialNumbers[index];
                return Card(
                    color: Colors.grey.shade100,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                  child: Container(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Icon(Icons.done, size: 25),
                                  ),
                                ),
                                TextSpan(
                                  text: serial.serialNumber,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ]),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.remove,
                                    size: 30.0,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      this.qty -= 1;
                                    });

                                    context.read<StoreBloc>()
                                      ..add(StoreProductBarcodeRemoved(
                                          productCode: widget.product.code,
                                          barcode: serial.serialNumber,
                                          unitCode: widget.product.unitCode));
                                    //   _onDeleteItemPressed(index);
                                    // context.read<StoreBloc>()
                                    //   ..add(StoreProductBarcodeRemoved(
                                    //       productCode: productCode, barcode: barcode));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]));
              },
            ),
          )
        : Container(
            height: (MediaQuery.of(context).size.height / 100) * 55,
          );
  }

  Widget serialListPackingSO(
      BuildContext context, Product product, Product refProduct) {
    return product.serialNumbers.length > 0
        ? Container(
            height: (MediaQuery.of(context).size.height / 100) * 55,
            child: ListView.builder(
              itemCount: refProduct.serialNumbers.length,
              itemBuilder: (context, index) {
                final refSerial = refProduct.serialNumbers[index];

                int indexMatchSerial = product.serialNumbers.indexWhere(
                    (serial) => serial.serialNumber == refSerial.serialNumber);
                bool _isDisable = indexMatchSerial == -1;
                return Card(
                    color: Colors.grey.shade100,
                    child: Column(mainAxisSize: MainAxisSize.min, children: <
                        Widget>[
                      ListTile(
                        title: RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: Container(
                                padding: EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  Icons.done,
                                  size: 25,
                                  color:
                                      _isDisable ? Colors.grey : Colors.green,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: refSerial.serialNumber,
                              style: TextStyle(
                                color: _isDisable ? Colors.grey : Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                          ]),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                size: 30.0,
                                color: _isDisable ? Colors.grey : Colors.black,
                              ),
                              onPressed: _isDisable
                                  ? null
                                  : () {
                                      setState(() {
                                        this.qty -= 1;
                                      });

                                      context.read<StoreBloc>()
                                        ..add(StoreProductBarcodeRemoved(
                                            productCode: widget.product.code,
                                            barcode: refSerial.serialNumber,
                                            unitCode: widget.product.unitCode));
                                      //   _onDeleteItemPressed(index);
                                      // context.read<StoreBloc>()
                                      //   ..add(StoreProductBarcodeRemoved(
                                      //       productCode: productCode, barcode: barcode));
                                    },
                            ),
                          ],
                        ),
                      ),
                    ]));
              },
            ),
          )
        : Container();
  }

  Widget scanSN(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, bottom: 5.0),
      child: Row(
        children: [
          Text(
            "Serial",
            style: TextStyle(fontSize: 16.0),
          ),
          // IconButton(
          //   iconSize: 30,
          //   icon: new Icon(Icons.camera_alt),
          //   onPressed: () => scanBarcodeNormal(context),
          //   color: Colors.black,
          // ),
        ],
      ),
    );
  }

  Widget itemName() {
    _nameController.value = TextEditingValue(text: widget.product.name);
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: TextField(
        controller: _nameController,
        decoration: new InputDecoration(
          enabled: false,
          border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.teal)),
          hintText: 'สาขา',
          labelText: 'สินค้า',
        ),
      ),
    );
  }

  Widget inputQty(BuildContext context) {
    _qtyController.value = TextEditingValue(text: this.qty.toString());

    return Visibility(
      visible: this.isVisi,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: <Widget>[
            // Edit text
            Flexible(
              child: Container(
                child: TextField(
                  controller: _qtyController,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    hintText: 'จำนวน',
                    labelText: 'จำนวน',
                  ),
                ),
              ),
            ),
            // Button send image
            Material(
              child: new Container(
                child: new IconButton(
                  icon: new Icon(Icons.remove),
                  onPressed: () => removeQty(context),
                  iconSize: 30,
                  color: Colors.red,
                ),
              ),
              color: Colors.white,
            ),
            Material(
              child: new Container(
                child: new IconButton(
                  iconSize: 30,
                  icon: new Icon(Icons.add),
                  onPressed: () => addQty(context),
                  color: Colors.green,
                ),
              ),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> scanBarcodeNormal(BuildContext context) async {
    String barcodeScaned;

    try {
      barcodeScaned = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.DEFAULT);

      FlutterBeep.beep();
      context.read<StoreBloc>().add(StoreProductBarcodeScaned(
          productCode: widget.product.code,
          barcode: barcodeScaned,
          unitCode: widget.product.unitCode));
    } on PlatformException {
      barcodeScaned = 'Failed to get platform version.';
      FlutterBeep.beep(false);
    }
  }

  Future<void> startBarcodeScanStream(BuildContext context) async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.DEFAULT)!
        .listen((barcode) {
      if (this.items.length > 0) {
        setState(() {
          isVisi = false;
        });
      } else {
        setState(() {
          isVisi = true;
        });
      }

      if (barcode != '-1') {
        context.read<StoreBloc>().add(StoreProductBarcodeScaned(
              productCode: widget.product.code,
              barcode: barcode,
              unitCode: widget.product.unitCode,
            ));
      }
      FlutterBeep.beep();
    });
  }
}
