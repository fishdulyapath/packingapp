import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/screens/packingSO/cubit/packingSO_cubit.dart';
import 'package:mobilepacking/screens/packingSO/packingSOItemList.dart';

class GetWithDrawDoc extends StatefulWidget {
  const GetWithDrawDoc({Key? key}) : super(key: key);

  @override
  _GetWithDrawDocState createState() => _GetWithDrawDocState();
}

class _GetWithDrawDocState extends State<GetWithDrawDoc> {
  TextEditingController docNo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(171, 167, 242, 1),
        centerTitle: true,
        title: Text(
          'ยืนยันรายการสั่งขาย',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //iconHeader(),
                title(),
                textFieldDoc(),
                BlocListener<PackingSOCubit, PackingSOState>(
                  listener: (context, state) {
                    if (state is PackingSOLoadProducSuccess) {
                      context
                          .read<StoreBloc>()
                          .add(StorePackingSOLoaded(store: state.store));
                      final String tempDoc = this.docNo.text;
                      this.docNo.text = '';

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => PackingSOItemList(docNo: tempDoc)));
                    } else if (state is PackingSOLoadProducFailure) {
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
                  child: submitButton(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget submitButton(BuildContext context) {
    return Container(
      child: Center(
        child: SizedBox(
          width: 120,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Colors.blue.shade300,
                textStyle: const TextStyle(fontSize: 16)),
            onPressed: () {
              context.read<PackingSOCubit>().loadDocpackingSO(docNo.text);
            },
            child: Row(
              children: <Widget>[Icon(Icons.check), Text("Submit")],
            ),
          ),
        ),
      ),
    );
  }

  Widget textFieldDoc() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 50),
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        controller: docNo,
        decoration: InputDecoration(
          labelText: "เลขที่ใบสั่งขาย",
          hintText: "",
          suffixIcon: InkWell(
            onTap: () => scanBarcodeNormal(),
            child: Icon(Icons.camera_alt),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      margin: EdgeInsets.only(bottom: 50, top: 50),
      child: Text(
        "เลขที่ใบสั่งขาย",
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget iconHeader() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Icon(
        Icons.ballot,
        size: 200,
        color: Colors.grey.shade400,
      ),
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
      print("barcodeScanRes " + barcodeScanRes);
      docNo.text = "SO17100003";
      FlutterBeep.beep();
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      FlutterBeep.beep(false);
    }
  }
}
