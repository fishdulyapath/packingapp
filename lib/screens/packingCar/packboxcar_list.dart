import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:intl/intl.dart';
import 'package:mobilepacking/blocs/branch/branch_bloc.dart';

import 'package:mobilepacking/blocs/doclistcarpack/doclistcarpack_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/blocs/store_form/store_form_bloc.dart';
import 'package:mobilepacking/blocs/warehouse_location/warehouse_location_bloc.dart';

import 'package:mobilepacking/data/struct/docListCar.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/screens/login_page.dart';
import 'package:mobilepacking/screens/main_menu.dart';
import 'package:mobilepacking/screens/packingBox/packbox_detail.dart';
import 'package:mobilepacking/screens/packingBox/packbox_list.dart';
import 'package:mobilepacking/screens/packingBox/packboxconfirm.dart';
import 'package:mobilepacking/screens/packingCar/packboxcar_detail.dart';
import 'package:mobilepacking/widgets/bottom_app_bar.dart';
import 'package:mobilepacking/widgets/cart_item_list.dart';

class PackcarList extends StatefulWidget {
  const PackcarList({Key? key}) : super(key: key);

  @override
  _PackcarListState createState() => _PackcarListState();
}

class _PackcarListState extends State<PackcarList> {
  TextEditingController docNo = TextEditingController();
  bool _isFillter = false;
  String fromDate = "";
  String toDate = "";
  final _debouncer = Debouncer(milliseconds: 1000);
  // String _barcode = "";
  @override
  void initState() {
    DateTime date = new DateTime.now();

    String datenow = DateFormat('yyyy-MM-dd').format(date);
    context.read<DoclistCarBloc>()
      ..add(DoclistCarLoaded(fromDate: datenow, toDate: datenow));

    super.initState();
  }

  List<String> products = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(247, 166, 245, 1),
        title: Text(
          'รายการจัดสินค้าขึ้นรถ',
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
                  MaterialPageRoute(builder: (_) => Mainmenu()),
                  (route) => false);
            }),
      ),
      body: BlocListener<StoreFormBloc, StoreFormState>(
        listener: (context, state) {
          if (state is StoreFormSendSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('ส่งพิมพ์สำเร็จ')));

            context.read<DoclistCarBloc>()
              ..add(DoclistCarLoaded(fromDate: fromDate, toDate: toDate));
          } else if (state is StoreFormSendFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              'ทำรายการล้มเหลว!',
              style: TextStyle(color: Colors.redAccent),
            )));
          }
        },
        child: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                ExpansionPanelList(
                  dividerColor: Colors.red,
                  children: [
                    ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return Container(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "การค้นหา",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 18.0),
                            ));
                      },
                      body: Column(
                        children: [
                          textFromDate(),
                          texttoDate(),
                          textFieldDoc(),
                          SizedBox(height: 10)
                        ],
                      ),
                      isExpanded: _isFillter,
                    ),
                  ],
                  expansionCallback: (i, isOpen) =>
                      setState(() => {_isFillter = !_isFillter}),
                ),
                BlocBuilder<DoclistCarBloc, DoclistCarState>(
                  builder: (context, state) {
                    return state.status == DoclistCarStateStatus.success
                        ? doclistCar(context, state.doclistCar, 76)
                        : state.status == DoclistCarStateStatus.inProcess
                            ? Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Text(
                                  'กำลังประมวลผล',
                                  style: TextStyle(
                                      color: Colors.blueAccent, fontSize: 18),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text('ไม่พบข้อมูล',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 18)),
                              );
                  },
                ),
                Divider(height: 0, color: Colors.black26),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget textFieldDoc() {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10),
      child: BlocBuilder<DoclistCarBloc, DoclistCarState>(
        builder: (context, state) {
          return TextField(
            controller: docNo,
            decoration: InputDecoration(
              labelText: "เลขที่เอกสาร",
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
            onChanged: (keyword) {
              _debouncer.run(() => context.read<DoclistCarBloc>()
                ..add(DoclistCarLoaded(
                    fromDate: fromDate, toDate: toDate, keyWord: docNo.text)));
            },
          );
        },
      ),
    );
  }

  Widget textFromDate() {
    DateTime date = new DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Column(children: <Widget>[
        BlocBuilder<DoclistCarBloc, DoclistCarState>(
          builder: (context, state) {
            return DateTimeField(
              format: DateFormat("yyyy-MM-dd"),
              onShowPicker: (context, curren_date) {
                return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: DateTime.now(),
                  lastDate: DateTime(2100),
                ).then((date) {
                  setState(() {
                    fromDate = date.toString().split(" ")[0];
                  });
                  print(fromDate);
                  return date;
                });
              },
              onChanged: (keyword) {
                _debouncer.run(() => context.read<DoclistCarBloc>()
                  ..add(DoclistCarLoaded(
                      fromDate: fromDate,
                      toDate: toDate,
                      keyWord: docNo.text)));
              },
              decoration: InputDecoration(
                labelText: fromDate == "" ? formattedDate : "จากวันที่",
                hintText: formattedDate,
                suffixIcon: InkWell(
                  child: Icon(Icons.calendar_today),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }

  Widget texttoDate() {
    DateTime date = new DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Column(children: <Widget>[
        BlocBuilder<DoclistCarBloc, DoclistCarState>(
          builder: (context, state) {
            return DateTimeField(
              format: DateFormat("yyyy-MM-dd"),
              onShowPicker: (context, curren_date) {
                return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: DateTime.now(),
                  lastDate: DateTime(2100),
                ).then((date) {
                  setState(() {
                    toDate = date.toString().split(" ")[0];
                  });
                  print(toDate);
                  return date;
                });
              },
              onChanged: (keyword) {
                _debouncer.run(() => context.read<DoclistCarBloc>()
                  ..add(DoclistCarLoaded(
                      fromDate: fromDate,
                      toDate: toDate,
                      keyWord: docNo.text)));
              },
              decoration: InputDecoration(
                labelText: toDate == "" ? formattedDate : "ถึงวันที่",
                hintText: formattedDate,
                suffixIcon: InkWell(
                  child: Icon(Icons.calendar_today),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            );
          },
        ),
      ]),
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
      print("barcodeScanRes " + barcodeScanRes);
      docNo.text = barcodeScanRes;

      context.read<DoclistCarBloc>()
        ..add(DoclistCarLoaded(keyWord: docNo.text));

      FlutterBeep.beep();
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      FlutterBeep.beep(false);
    }
  }
}

Widget doclistCar(
    BuildContext context, List<DoclistCar> doclistCar, double height) {
  return Container(
      padding: EdgeInsets.only(left: 2, right: 2, top: 5),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: (MediaQuery.of(context).size.height / 100) * height,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: doclistCar.length,
                      itemBuilder: (BuildContext context, int index) {
                        return cardDoclistCar(context, doclistCar[index]);
                      }),
                ),
              )
            ],
          ),
        ],
      ));
}

Widget cardDoclistCar(BuildContext context, DoclistCar doclistCar) {
  final handleCardClick = () => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PackboxCarDetail(
          status: doclistCar.status,
          docnoselect: doclistCar.docNo,
          doclistCar: doclistCar)));

  switch (doclistCar.doclistCarStatus) {
    case DoclistCarStatus.success:
      return DoccardSuccess(context, doclistCar, onTap: handleCardClick);
    case DoclistCarStatus.warning:
      return DoccardWarning(context, doclistCar, onTap: handleCardClick);
    case DoclistCarStatus.unknown:
    default:
      return DoccardShadow(context, doclistCar);
  }
}

Widget DoccardSuccess(BuildContext context, DoclistCar DoclistCar,
    {VoidCallback? onTap}) {
  return DoccardDefault(context, DoclistCar,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.green, width: 2.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      // tileColor: Colors.green[300],
      icon: Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 27.0,
      ));
}

Widget DoccardWarning(BuildContext context, DoclistCar DoclistCar,
    {VoidCallback? onTap}) {
  return DoccardDefault(context, DoclistCar,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.orange, width: 2.0),
        borderRadius: BorderRadius.circular(4.0),
      ),
      icon: Icon(
        Icons.warning,
        color: Colors.orange,
      ));
}

Widget DoccardShadow(BuildContext context, DoclistCar DoclistCar,
    {VoidCallback? onTap}) {
  return DoccardDefault(
    context,
    DoclistCar,
    onTap: onTap,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.blue.shade100, width: 2.0),
      borderRadius: BorderRadius.circular(4.0),
    ),
  );
}

Widget DoccardDefault(
  BuildContext context,
  DoclistCar doclistCar, {
  VoidCallback? onTap,
  ShapeBorder? shape,
  Color? tileColor,
  Color? textColor,
  Icon? icon,
}) {
  List<String> _dateThaiFormat = doclistCar.docDate.split("-");
  String dateText = 'วันที่ : ' +
      _dateThaiFormat[2] +
      '/' +
      _dateThaiFormat[1] +
      '/' +
      _dateThaiFormat[0];
  String title = '';
  double item_wait =
      (double.parse(doclistCar.boQty) - double.parse(doclistCar.boSuccess));

  title += 'ใบคุม : ' + doclistCar.docNo;

  String subText = 'จำนวน: ' + doclistCar.boQty;

  String subText2 = '     จัดเสร็จ:' + doclistCar.boSuccess;
  String subText3 = '     ค้างจัด:' + item_wait.toString();
  String status = "";
  if (item_wait == 0) {
    status = "   Complete";
  } else {
    status = "   Incomplete";
  }
  return Card(
    shape: shape,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTileTheme(
          textColor: textColor,
          child: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                Text(status,
                    style: TextStyle(
                        color: status.trim() == 'Complete'
                            ? Colors.green.shade800
                            : Colors.red.shade800))
              ],
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 0),
                  margin: EdgeInsets.only(bottom: 0),
                  child: Text(
                    dateText,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text(
                        subText,
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        subText2,
                        style: TextStyle(
                          color: Colors.green.shade700,
                        ),
                      ),
                      Text(
                        subText3,
                        style: TextStyle(
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            tileColor: tileColor,
            trailing: icon,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              child: Text('รายละเอียด'),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => PackboxCarDetail(
                        docnoselect: doclistCar.docNo,
                        doclistCar: doclistCar,
                        status: doclistCar.status)));
              },
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              child: Text(item_wait == 0
                  ? doclistCar.status == 0
                      ? 'พร้อมส่ง'
                      : 'ส่งพิมพ์แล้ว'
                  : 'รอส่ง'),
              style: ElevatedButton.styleFrom(
                  primary: item_wait == 0 ? Colors.green : Colors.purple,
                  textStyle:
                      TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              onPressed: () {
                if (item_wait == 0 && doclistCar.status == '0') {
                  //showAlertSend(context, DoclistCar.docNo);
                  print('send success');
                }
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
      ],
    ),
  );
}

// showAlertSend(BuildContext context, String doc) {
//   // set up the buttons
//   Widget cancelButton = ElevatedButton(
//     style: ElevatedButton.styleFrom(primary: Colors.red.shade600),
//     child: Text("ยกเลิก"),
//     onPressed: () {
//       Navigator.of(context).pop();
//     },
//   );
//   Widget continueButton = ElevatedButton(
//     child: Text("ตกลง"),
//     onPressed: () {
//       context.read<StoreFormBloc>()..add(StoreFormPackingBoxSend(docNo: doc));
//       Navigator.of(context).pop();
//     },
//   );
//   // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//     title: Text("ยืนยันการทำงาน"),
//     content: Text("ต้องการส่งพิมพ์เอกสาร " + doc + " ใช่หรือไม่"),
//     actions: [
//       cancelButton,
//       continueButton,
//     ],
//   );
//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }

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
