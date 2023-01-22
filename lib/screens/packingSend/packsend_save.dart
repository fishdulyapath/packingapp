import 'dart:convert';
import 'dart:typed_data';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:intl/intl.dart';
import 'package:mobilepacking/blocs/branch/branch_bloc.dart';

import 'dart:ui' as ui;
import 'package:mobilepacking/blocs/doclistsend/doclistsend_bloc.dart';
import 'package:mobilepacking/blocs/docsend/docsend_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/blocs/store_form/store_form_bloc.dart';
import 'package:mobilepacking/blocs/warehouse_location/warehouse_location_bloc.dart';

import 'package:mobilepacking/data/struct/docListSend.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/screens/login_page.dart';
import 'package:mobilepacking/screens/main_menu.dart';
import 'package:mobilepacking/screens/packingBox/packbox_detail.dart';
import 'package:mobilepacking/screens/packingBox/packboxconfirm.dart';
import 'package:mobilepacking/screens/packingCar/packboxcar_detail.dart';
import 'package:mobilepacking/screens/packingSend/packsend_detail.dart';
import 'package:mobilepacking/widgets/bottom_app_bar.dart';
import 'package:mobilepacking/widgets/cart_item_list.dart';
import 'package:signature/signature.dart';

class PacksendSave extends StatefulWidget {
  final String? docnoselect;
  final DoclistSend? doclistSend;
  final List<String> docboselect;
  const PacksendSave(
      {Key? key,
      required this.docnoselect,
      required this.docboselect,
      required this.doclistSend})
      : super(key: key);

  @override
  _PacksendSaveState createState() => _PacksendSaveState();
}

class _PacksendSaveState extends State<PacksendSave> {
  TextEditingController docNo = TextEditingController();
  bool _isFillter = false;
  String fromDate = "";
  String toDate = "";
  late Uint8List signatureBytes;
  SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  // String _barcode = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DocsendBloc, DocsendState>(
      listener: (context, state) {
        if (state is DocsendLoadSuccess) {
          Future.delayed(const Duration(milliseconds: 3500), () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (_) => PackSendDetail(
                          doclistSend: widget.doclistSend,
                          docnoselect: widget.docnoselect,
                        )),
                (route) => false);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(247, 166, 245, 1),
          title: Text(
            'เซ็นรับของ',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => PackSendDetail(
                              doclistSend: widget.doclistSend,
                              docnoselect: widget.docnoselect,
                            )),
                    (route) => false);
              }),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                        child: Signature(
                          width: double.infinity,
                          height: 300,
                          controller: _controller,
                          backgroundColor: Colors.grey.shade100,
                        )),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(primary: Colors.orange),
                        icon: Icon(
                          Icons.clear,
                          size: 24.0,
                        ),
                        label: Text(
                          "ล้างข้อมูล",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () async {
                          _controller.clear();
                        }),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(primary: Colors.green),
                        icon: Icon(
                          Icons.save,
                          size: 24.0,
                        ),
                        label: Text(
                          "บันทึกจัดส่ง",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () async {
                          if (_controller.isNotEmpty) {
                            showAlertDialog(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('กรุณาเพิ่มลายเซ็น')));
                          }
                        }),
                  ],
                ),
              ],
            ),
          ),
        )),
      ),
    );
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
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ยืนยันการทำงาน"),
      content: Text("ต้องการบันทึกการจัดส่งใช่หรือไม่"),
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
}
