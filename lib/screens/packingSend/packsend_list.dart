import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_launcher_icons/constants.dart';
import 'package:intl/intl.dart';
import 'package:mobilepacking/blocs/branch/branch_bloc.dart';

import 'package:mobilepacking/blocs/doclistsend/doclistsend_bloc.dart';
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
import 'package:mobilepacking/screens/packingBox/packbox_list.dart';
import 'package:mobilepacking/screens/packingBox/packboxconfirm.dart';
import 'package:mobilepacking/screens/packingCar/packboxcar_detail.dart';
import 'package:mobilepacking/screens/packingSend/packsend_detail.dart';
import 'package:mobilepacking/widgets/bottom_app_bar.dart';
import 'package:mobilepacking/widgets/cart_item_list.dart';

class PacksendList extends StatefulWidget {
  const PacksendList({Key? key}) : super(key: key);

  @override
  _PacksendListState createState() => _PacksendListState();
}

class _PacksendListState extends State<PacksendList> {
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
    context.read<DoclistSendBloc>()
      ..add(DoclistSendLoaded(fromDate: datenow, toDate: datenow));

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
          '??????????????????????????????????????????????????????',
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
                .showSnackBar(SnackBar(content: Text('??????????????????????????????????????????')));

            context.read<DoclistSendBloc>()
              ..add(DoclistSendLoaded(fromDate: fromDate, toDate: toDate));
          } else if (state is StoreFormSendFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              '?????????????????????????????????????????????!',
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
                              "????????????????????????",
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
                BlocBuilder<DoclistSendBloc, DoclistSendState>(
                  builder: (context, state) {
                    return state.status == DoclistSendStateStatus.success
                        ? docListSend(context, state.doclistSend, 76)
                        : Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text('?????????????????????????????????'),
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
      child: BlocBuilder<DoclistSendBloc, DoclistSendState>(
        builder: (context, state) {
          return TextField(
            controller: docNo,
            decoration: InputDecoration(
              labelText: "????????????????????????????????????",
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
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (state.status != DoclistSendStateStatus.inProcess) {
                  context.read<DoclistSendBloc>()
                    ..add(DoclistSendLoaded(keyWord: keyword));
                }
              });
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
        BlocBuilder<DoclistSendBloc, DoclistSendState>(
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
                Future.delayed(const Duration(milliseconds: 1000), () {
                  if (state.status != DoclistSendStateStatus.inProcess) {
                    context.read<DoclistSendBloc>()
                      ..add(DoclistSendLoaded(
                          fromDate: fromDate, toDate: toDate));
                  }
                });
              },
              decoration: InputDecoration(
                labelText: fromDate == "" ? formattedDate : "???????????????????????????",
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
        BlocBuilder<DoclistSendBloc, DoclistSendState>(
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
                Future.delayed(const Duration(milliseconds: 1000), () {
                  if (state.status != DoclistSendStateStatus.inProcess) {
                    context.read<DoclistSendBloc>()
                      ..add(DoclistSendLoaded(
                          fromDate: fromDate, toDate: toDate));
                  }
                });
              },
              decoration: InputDecoration(
                labelText: toDate == "" ? formattedDate : "???????????????????????????",
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

      context.read<DoclistSendBloc>()
        ..add(DoclistSendLoaded(keyWord: docNo.text));

      FlutterBeep.beep();
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
      FlutterBeep.beep(false);
    }
  }
}

Widget docListSend(
    BuildContext context, List<DoclistSend> doclistSend, double height) {
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
                      itemCount: doclistSend.length,
                      itemBuilder: (BuildContext context, int index) {
                        return cardDoclistSend(context, doclistSend[index]);
                      }),
                ),
              )
            ],
          ),
        ],
      ));
}

Widget cardDoclistSend(BuildContext context, DoclistSend doclistSend) {
  final handleCardClick = () => Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PackSendDetail(
          docnoselect: doclistSend.docNo, doclistSend: doclistSend)));

  switch (doclistSend.doclistSendStatus) {
    case DoclistSendStatus.success:
      return DoccardSuccess(context, doclistSend, onTap: handleCardClick);
    case DoclistSendStatus.warning:
      return DoccardWarning(context, doclistSend, onTap: handleCardClick);
    case DoclistSendStatus.unknown:
    default:
      return DoccardShadow(context, doclistSend, onTap: handleCardClick);
  }
}

Widget DoccardSuccess(BuildContext context, DoclistSend DoclistSend,
    {VoidCallback? onTap}) {
  return DoccardDefault(context, DoclistSend,
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

Widget DoccardWarning(BuildContext context, DoclistSend DoclistSend,
    {VoidCallback? onTap}) {
  return DoccardDefault(context, DoclistSend,
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

Widget DoccardShadow(BuildContext context, DoclistSend DoclistSend,
    {VoidCallback? onTap}) {
  return DoccardDefault(
    context,
    DoclistSend,
    onTap: onTap,
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.blue.shade100, width: 2.0),
      borderRadius: BorderRadius.circular(4.0),
    ),
  );
}

Widget DoccardDefault(
  BuildContext context,
  DoclistSend doclistSend, {
  VoidCallback? onTap,
  ShapeBorder? shape,
  Color? tileColor,
  Color? textColor,
  Icon? icon,
}) {
  List<String> _dateThaiFormat = doclistSend.docDate.split("-");
  String dateText = '?????????????????? : ' +
      _dateThaiFormat[2] +
      '/' +
      _dateThaiFormat[1] +
      '/' +
      _dateThaiFormat[0];
  String title = '';
  double item_wait = (double.parse(doclistSend.boxEventCount) -
      double.parse(doclistSend.boxSendCount));

  title += '??????????????? : ' + doclistSend.docNo;

  String subText = '???????????????: ' + doclistSend.boxEventCount;

  String subText2 = '     ?????????????????????:' + doclistSend.boxSendCount;
  String subText3 = '     ?????????????????????:' + item_wait.toString();
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
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    textStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                child: Text('??????????????????????????????'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => PackSendDetail(
                            docnoselect: doclistSend.docNo,
                            doclistSend: doclistSend,
                          )));
                },
              ),
            ),
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
//     child: Text("??????????????????"),
//     onPressed: () {
//       Navigator.of(context).pop();
//     },
//   );
//   Widget continueButton = ElevatedButton(
//     child: Text("????????????"),
//     onPressed: () {
//       context.read<StoreFormBloc>()..add(StoreFormPackingBoxSend(docNo: doc));
//       Navigator.of(context).pop();
//     },
//   );
//   // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//     title: Text("??????????????????????????????????????????"),
//     content: Text("??????????????????????????????????????????????????????????????? " + doc + " ??????????????????????????????"),
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
    child: Text("??????????????????"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = ElevatedButton(
    child: Text("????????????"),
    onPressed: () {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Mainmenu()), (route) => false);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Text("?????????????????????????????????????????????????????????????????????????????????????????????????????????"),
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
