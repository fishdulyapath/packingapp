import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobilepacking/blocs/boxscan/boxscan_bloc.dart';
import 'package:mobilepacking/blocs/boxsend/boxsend_bloc.dart';
import 'package:mobilepacking/blocs/branch/branch_bloc.dart';
import 'package:mobilepacking/blocs/doccardetail/doccardetail_bloc.dart';
import 'package:mobilepacking/blocs/docdetail/docdetail_bloc.dart';
import 'package:mobilepacking/blocs/doclist/doclist_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/blocs/store_form/store_form_bloc.dart';
import 'package:mobilepacking/blocs/warehouse_location/warehouse_location_bloc.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/docDetailCar.dart';
import 'package:mobilepacking/data/struct/docList.dart';
import 'package:mobilepacking/data/struct/docListCar.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/screens/packingBox/packbox_box_list.dart';
import 'package:mobilepacking/screens/packingBox/packbox_list.dart';
import 'package:mobilepacking/screens/packingBox/packboxform.dart';
import 'package:mobilepacking/screens/packingBox/packboxformsend.dart';
import 'package:mobilepacking/screens/packingCar/packboxcar_list.dart';
import 'package:mobilepacking/widgets/bottom_pack_confirm.dart';

import 'package:mobilepacking/widgets/cart_item_show.dart';
import 'package:uuid/uuid.dart';

class PackboxCarDetail extends StatefulWidget {
  final String? docnoselect;
  final DoclistCar? doclistCar;
  final int status;
  const PackboxCarDetail(
      {Key? key,
      required this.docnoselect,
      required this.status,
      required this.doclistCar})
      : super(key: key);

  @override
  _PackboxCarDetailState createState() => _PackboxCarDetailState();
}

Widget inputBranch(Branch branch) {
  return Container(
    margin: EdgeInsets.only(bottom: 5),
    child: TextFormField(
      initialValue: branch.name,
      decoration: new InputDecoration(
        enabled: false,
        border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.teal)),
        hintText: 'สาขา',
        labelText: 'ผู้รับ',
      ),
    ),
  );
}

Widget inputWarehouseLocation(WarehouseLocation warehouseLocation) {
  return Container(
    child: TextFormField(
      initialValue:
          '${warehouseLocation.locationname} ~ ${warehouseLocation.whname}',
      decoration: new InputDecoration(
        enabled: false,
        border: new OutlineInputBorder(
            borderSide: new BorderSide(color: Colors.teal)),
        hintText: 'คลัง/ที่เก็บ',
        labelText: 'คลัง/ที่เก็บ',
      ),
    ),
  );
}

class _PackboxCarDetailState extends State<PackboxCarDetail> {
  List<String> products = [
    "Test1",
    "Test1",
    "Test1",
    "Test1",
    "Test1",
    "Test1",
    "Test1",
    "Test1",
    "Test1",
  ];
  TextEditingController txtFieldScan = new TextEditingController();
  bool _loadShow = false;
  String oldBarcode = "";
  int waitPack = 0;
  @override
  void initState() {
    context.read<DocdetailcarBloc>()
      ..add(DoccardetailLoaded(docNo: widget.docnoselect.toString()));

    super.initState();
  }

  Future<void> scanBarcodeNormal(
      BuildContext context, String textScan, String docJo) async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
      print('---> $barcodeScanRes');
      if (oldBarcode != barcodeScanRes) {
        oldBarcode = barcodeScanRes;
        context
            .read<BoxscanBloc>()
            .add(BoxscanLoad(docno: barcodeScanRes, docjo: docJo));
        FlutterBeep.beep();
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      FlutterBeep.beep(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> _dateThaiFormat = widget.doclistCar!.docDate.split("-");
    String dateText = 'วันที่ : ' +
        _dateThaiFormat[2] +
        '/' +
        _dateThaiFormat[1] +
        '/' +
        _dateThaiFormat[0];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(247, 166, 245, 1),
        title: Text(
          widget.docnoselect.toString(),
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => PackcarList()),
                  (route) => false);
            }),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<BoxscanBloc, BoxscanState>(
            listener: (context, state) {
              if (state is BoxscanLoadSuccess) {
                context.read<DocdetailcarBloc>()
                  ..add(
                      DoccardetailLoaded(docNo: widget.docnoselect.toString()));
              }
            },
          ),
          BlocListener<BoxsendBloc, BoxsendState>(
            listener: (context, state) {
              if (state is BoxsendLoadSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('จัดส่งเอกสารสำเร็จ')));
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => PackcarList()),
                    (route) => false);
              } else if (state is BoxsendLoadFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('จัดส่งเอกสารล้มเหลว')));
              }
            },
          ),
        ],
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(dateText, style: TextStyle(fontSize: 15)),
                            SizedBox(width: 8),
                            Text('ทะเบียนรถ: ' + widget.doclistCar!.carCode,
                                style: TextStyle(fontSize: 15)),
                          ],
                        ),
                        Row(
                          children: [
                            Text('คนขับ: ' + widget.doclistCar!.carDriverName,
                                style: TextStyle(fontSize: 15)),
                            SizedBox(width: 8),
                            Text('คนติดรถ: ' + widget.doclistCar!.carAssisName,
                                style: TextStyle(fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        // Button send image
                        (widget.status == 0)
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green.shade700,
                                    textStyle: const TextStyle(fontSize: 18)),
                                onPressed: () {
                                  if (waitPack != 0) {
                                    showAlertDialog(context, waitPack);
                                  } else {
                                    showConfirmDialog(context);
                                  }
                                },
                                child: Row(
                                  // Replace with a Row for horizontal icon + text
                                  children: <Widget>[
                                    Icon(Icons.send),
                                    SizedBox(width: 3),
                                    Text("จัดส่งเอกสาร")
                                  ],
                                ),
                              )
                            : Container(),
                        SizedBox(width: 5),
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //       primary: Colors.orange.shade400,
                        //       textStyle: const TextStyle(fontSize: 18)),
                        //   onPressed: () {},
                        //   child: Row(
                        //     // Replace with a Row for horizontal icon + text
                        //     children: <Widget>[
                        //       Icon(Icons.check),
                        //       SizedBox(width: 3),
                        //       Text("ตรวจใบคุม")
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  (widget.status == 0)
                      ? Container(
                          padding: EdgeInsets.only(
                              top: 2, left: 5, right: 5, bottom: 5),
                          child: Row(
                            children: <Widget>[
                              // Edit text
                              Flexible(
                                child: Container(
                                  child: TextField(
                                    autofocus: true,
                                    onSubmitted: (text) {
                                      if (oldBarcode != txtFieldScan.text) {
                                        oldBarcode = txtFieldScan.text;
                                        context.read<BoxscanBloc>().add(
                                            BoxscanLoad(
                                                docno: txtFieldScan.text,
                                                docjo: widget.docnoselect
                                                    .toString()));
                                        txtFieldScan.text = '';
                                      }
                                    },
                                    controller: txtFieldScan,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18.0),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.send),
                                        onPressed: () {
                                          if (oldBarcode != txtFieldScan.text) {
                                            oldBarcode = txtFieldScan.text;
                                            context.read<BoxscanBloc>().add(
                                                BoxscanLoad(
                                                    docno: txtFieldScan.text,
                                                    docjo: widget.docnoselect
                                                        .toString()));
                                            txtFieldScan.text = '';
                                          }
                                        },
                                      ),
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "สแกนบาร์โค้ดกล่อง",
                                      hintStyle: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              // Button send image
                              Material(
                                child: new Container(
                                  margin:
                                      new EdgeInsets.symmetric(horizontal: 1.0),
                                  child: new IconButton(
                                    icon: new Icon(Icons.camera_alt),
                                    onPressed: () => scanBarcodeNormal(
                                        context,
                                        txtFieldScan.text,
                                        widget.docnoselect.toString()),
                                    color: Colors.blue,
                                  ),
                                ),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  BlocBuilder<DocdetailcarBloc, DoccardetailState>(
                    builder: (context, state) {
                      return (state is DoccarDetailLoadSuccess)
                          ? cartDocDetailShow(context, state.doccarDetail, 65)
                          : (_loadShow)
                              ? Container(
                                  margin: EdgeInsets.only(top: 50),
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.cyanAccent,
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.blue),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(''),
                                );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showConfirmDialog(BuildContext context) {
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
        context
            .read<BoxsendBloc>()
            .add(BoxsendLoad(status: 1, docno: widget.docnoselect.toString()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ยืนยันการจัดส่ง"),
      content: Text("ต้องการจัดส่งเอกสารนี้ ใช่หรือไม่"),
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

  showAlertDialog(BuildContext context, int waitPack) {
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
        context
            .read<BoxsendBloc>()
            .add(BoxsendLoad(status: 3, docno: widget.docnoselect.toString()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("มีรายการค้างจัด " + waitPack.toString() + " รายการ"),
      content: Text("ต้องการส่งขออนุมัติส่งขึ้นรถ ใช่หรือไม่"),
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ข้อความระบบ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Center(child: Text('ไม่สามารถทำรายการได้!')),
                Center(child: Text('กรุณาจัดสินค้าให้ครบตามจำนวน!')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget cartDocDetailShow(
      BuildContext context, List<DocDetailCar> docdetail, double height) {
    return Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Column(
          children: <Widget>[
            titleName(),
            SizedBox(
              height: 5,
            ),
            DocitemList(context, docdetail, height)
          ],
        ));
  }

  Widget DocitemList(context, List<DocDetailCar> docdetail, height) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: (MediaQuery.of(context).size.height / 100) * height,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: docdetail.length,
                itemBuilder: (BuildContext context, int index) {
                  return DetailCardItem(context, docdetail[index]);
                }),
          ),
        )
      ],
    );
  }

  Widget DetailCardItem(BuildContext context, DocDetailCar docdetail) {
    String subText = 'จำนวน : ${docdetail.box_qty} ';
    String subText2 = ' จัดเสร็จ : ${docdetail.event_qty}';
    String subText3 =
        ' ค้างจัด : ${(docdetail.box_qty - docdetail.event_qty)} ';
    if ((docdetail.box_qty - docdetail.event_qty) == 0) {
      subText3 = "";
    }
    if ((docdetail.box_qty - docdetail.event_qty) != 0) {
      waitPack += 1;
    }
    return new Card(
        shape: RoundedRectangleBorder(
          side: (docdetail.box_qty - docdetail.event_qty) == 0
              ? BorderSide(color: Colors.green, width: 2.0)
              : BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            title: Text('${docdetail.doc_bo}'),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text('จุดส่ง: ' + docdetail.drop_code),
                ),
                Container(
                  child: Text('ที่อยู่: ' + docdetail.address),
                ),
                Container(
                  child: ((docdetail.box_qty - docdetail.event_qty) == 0)
                      ? Text(
                          'รับแล้ว',
                          style: TextStyle(color: Colors.green, fontSize: 14),
                        )
                      : Text(
                          "ค้างรับ",
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                ),
                // Container(
                //   child: Row(
                //     children: [
                //       Text(
                //         subText,
                //         style: TextStyle(
                //           color: Colors.black,
                //         ),
                //       ),
                //       Text(
                //         subText2,
                //         style: TextStyle(
                //           color: Colors.green.shade700,
                //         ),
                //       ),
                //       Text(
                //         subText3,
                //         style: TextStyle(
                //           color: Colors.red.shade700,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            isThreeLine: true,
          ),
        ]));
  }
}
