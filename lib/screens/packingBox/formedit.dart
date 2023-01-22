import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilepacking/blocs/docdetail/docdetail_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/product.dart';

class EditPackBox extends StatefulWidget {
  final DocDetail product;

  const EditPackBox({Key? key, required this.product}) : super(key: key);

  @override
  _EditPackBoxState createState() => _EditPackBoxState();
}

class _EditPackBoxState extends State<EditPackBox> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  double qty = 0;
  double maxqty = 0;
  List<String> items = ["sn00001", "sn00002", "sn00003"];
  bool isVisi = true;

  void addQty(BuildContext context) {
    setState(() {
      this.qty = this.qty + 1;
      if (this.qty > this.maxqty) {
        this.qty = this.maxqty;
      }
      this.isVisi = true;
      // context.read<DocdetailBloc>()
      //   ..add(ProductQtyIncreased(
      //       productCode: widget.product.itemCode,
      //       unitCode: widget.product.unitCode));
    });
  }

  void removeQty(BuildContext context) {
    setState(() {
      if (this.qty > 1) {
        this.qty = this.qty - 1;
        // context.read<DocdetailBloc>()
        //   ..add(ProductQtyDecreased(
        //       productCode: widget.product.itemCode,
        //       unitCode: widget.product.unitCode));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    final docState = context.read<DocdetailBloc>().state;
    if (docState is DocDetailLoadSuccess) {
      DocDetail productSelected = docState.docDetail.firstWhere(
          (element) => element.itemCode == widget.product.itemCode,
          orElse: () => DocDetail.empty());

      if (productSelected.itemCode != '') {
        this.qty = productSelected.qty_scan;
        this.maxqty = productSelected.qty_wait;
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
          widget.product.itemName,
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<DocdetailBloc>()
                          ..add(ProductRemoved(
                              productCode: widget.product.itemCode,
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
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<DocdetailBloc>()
                          ..add(ProductQtyChanged(
                              qty: this.qty,
                              productCode: widget.product.itemCode,
                              unitCode: widget.product.unitCode));
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade600,
                        fixedSize: Size(130.0, 45.0),
                        // textStyle: const TextStyle(fontSize: 18),
                      ),
                      icon: Icon(Icons.save),
                      label: Text("บันทึก"),
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
              context.read<DocdetailBloc>()
                ..add(ProductRemoved(
                    productCode: widget.product.itemCode,
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

  Widget itemName() {
    _nameController.value = TextEditingValue(text: widget.product.itemName);
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
                  readOnly: true,
                  controller: _qtyController,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
                    if (double.parse(value) > maxqty) {
                      _qtyController.text = maxqty.toString();
                    }
                  },
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
}
