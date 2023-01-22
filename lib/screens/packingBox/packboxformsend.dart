import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilepacking/blocs/customer/customer_bloc.dart';
import 'package:mobilepacking/blocs/doclist/doclist_bloc.dart';
import 'package:mobilepacking/blocs/dropoff/dropoff_bloc.dart';
import 'package:mobilepacking/blocs/branch/branch_bloc.dart';
import 'package:mobilepacking/blocs/docdetail/docdetail_bloc.dart';
import 'package:mobilepacking/blocs/product/product_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/blocs/store_form/store_form_bloc.dart';
import 'package:mobilepacking/blocs/warehouse_location/warehouse_location_bloc.dart';
import 'package:mobilepacking/data/struct/customer.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/docList.dart';
import 'package:mobilepacking/data/struct/dropoff.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/global.dart' as globals;
import 'package:mobilepacking/screens/main_menu.dart';
import 'package:mobilepacking/screens/packingBox/cubit/packingFM_cubit.dart';
import 'package:mobilepacking/screens/packingBox/formedit.dart';
import 'package:mobilepacking/screens/packingBox/packbox_detail.dart';
import 'package:mobilepacking/screens/packingBox/packbox_list.dart';
import 'package:mobilepacking/screens/packingBox/packboxconfirm.dart';
import 'package:mobilepacking/screens/packingSO/cubit/packingSO_cubit.dart';
import 'package:mobilepacking/util/product_util.dart';
import 'package:mobilepacking/widgets/bottom_app_bar.dart';
import 'package:mobilepacking/widgets/cart_item_list.dart';

class BoxFormSend extends StatefulWidget {
  final String? docnoselect;
  const BoxFormSend({Key? key, required this.docnoselect}) : super(key: key);

  @override
  _BoxFormSendState createState() => _BoxFormSendState();
}

class _BoxFormSendState extends State<BoxFormSend> {
  List<Branch> _branchOptions = <Branch>[Branch(code: 'เขต1', name: 'เขต1')];
  TextEditingController dropPoint = TextEditingController();
  TextEditingController custCode = TextEditingController();

  // String _barcode = "";

  List<String> products = [];

  @override
  void initState() {
    // context.read<DropoffBloc>()..add(DropoffLoad());
    // context.read<CustomerBloc>()..add(CustomerLoad());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreFormBloc, StoreFormState>(
      listener: (context, state) {
        if (state is StoreFormSendSuccess) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('ส่งพิมพ์สำเร็จ')));

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => PackboxList()),
              (route) => false);
        } else if (state is StoreFormSendFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            'ทำรายการล้มเหลว!',
            style: TextStyle(color: Colors.redAccent),
          )));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromRGBO(247, 166, 245, 1),
          leading: BlocBuilder<StoreBloc, StoreState>(
            builder: (context, state) {
              return IconButton(
                  color: Colors.white,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => PackboxDetail(
                                  status: 0,
                                  docnoselect: widget.docnoselect.toString(),
                                )),
                        (route) => false);
                  });
            },
          ),
          title: Text(
            'ส่งพิมพ์เอกสาร',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            IconButton(
                color: Colors.white,
                icon: Icon(Icons.save),
                onPressed: () {
                  if (custCode.text.toString() != "" &&
                      dropPoint.text.toString() != "") {
                    showAlertDialogSend(context, widget.docnoselect.toString());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                      'กรุณาเลือกผู้รับ และ จุดรับสินค้า',
                      style: TextStyle(color: Colors.redAccent),
                    )));
                  }
                }),
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                inputCustomer(context),
                inputDropoff(context),
                SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 112,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green.shade400,
                          textStyle: const TextStyle(fontSize: 18)),
                      onPressed: () {
                        if (custCode.text.toString() != "" &&
                            dropPoint.text.toString() != "") {
                          showAlertDialogSend(
                              context, widget.docnoselect.toString());
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                            'กรุณาเลือกผู้รับ และ จุดรับสินค้า',
                            style: TextStyle(color: Colors.redAccent),
                          )));
                        }
                      },
                      child: Center(
                        child: Row(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[Icon(Icons.send), Text(" ยืนยัน")],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  showAlertDialogSend(BuildContext context, String doc) {
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
        context.read<StoreFormBloc>()
          ..add(StoreFormPackingBoxSend(
              docNo: doc,
              custCode: custCode.text.toString(),
              dropPoint: dropPoint.text.toString()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ยืนยันการทำงาน"),
      content: Text("ต้องการส่งพิมพ์เอกสาร " + doc + " ใช่หรือไม่"),
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

  Widget inputCustomer(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 9, right: 9),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "ผู้รับ",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          SizedBox(
            height: 3,
          ),
          BlocBuilder<DoclistBloc, DoclistState>(
            builder: (context, state) {
              if (state.status == DoclistStateStatus.success) {
                DocList _docList = state.doclist.firstWhere((element) =>
                    element.docNo == widget.docnoselect.toString());

                if (_docList.docNo != "") {
                  if (_docList.docFormatCode == "MWID") {
                    custCode.text = _docList.toBranchName2;
                  } else {
                    custCode.text = _docList.transportName;
                  }
                } else {
                  Navigator.of(context).pop();
                }
              }
              return TextField(
                controller: custCode,
                decoration: InputDecoration(
                  labelText: "",
                  hintText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              );
            },
          ),
          /*BlocBuilder<CustomerBloc, CustomerState>(
            builder: (context, state) {
              List<Customer>? customer;
              if (state.status == CustomerStateStatus.success) {
                customer = state.customer;
              }
              return DropdownSearch<Customer>(
                mode: Mode.DIALOG,
                showSearchBox: true,
                itemAsString: (Customer u) => u.toShowLabel(),
                items: customer,
                label: "ผู้รับสินค้า",
                hint: "เลือกผู้รับสินค้า",
                onChanged: (cust) {
                  setState(() {
                    custCode = cust!.code;
                  });
                },
              );
            },
          ),*/
        ],
      ),
    );
  }

  Widget inputDropoff(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15, left: 9, right: 9),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "เขตขนส่ง",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          SizedBox(
            height: 3,
          ),
          BlocBuilder<DoclistBloc, DoclistState>(
            builder: (context, state) {
              if (state.status == DoclistStateStatus.success) {
                DocList _docList = state.doclist.firstWhere((element) =>
                    element.docNo == widget.docnoselect.toString());

                if (_docList.docNo != "") {
                  if (_docList.docFormatCode == "MWID") {
                    dropPoint.text =
                        _docList.toBranchCode + "-" + _docList.toBranchName;
                  } else {
                    dropPoint.text = _docList.logisticArea;
                  }
                } else {
                  Navigator.of(context).pop();
                }
              }
              return TextField(
                controller: dropPoint,
                decoration: InputDecoration(
                  labelText: "",
                  hintText: "",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget cartDocDetailShow(
      BuildContext context, List<DocDetail> docdetail, double height) {
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

  Widget DocitemList(context, List<DocDetail> docdetail, height) {
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
                  if (docdetail[index].qty_wait > 0) {
                    return DetailCardItem(context, docdetail[index]);
                  } else {
                    return Container();
                  }
                }),
          ),
        )
      ],
    );
  }

  Widget DetailCardItem(BuildContext context, DocDetail docdetail) {
    String subText = 'ค้างจัด : ${docdetail.qty_wait} ';
    String subText2 = ' รับเข้า : ${docdetail.qty_scan} ';
    final handleCardClick = () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => EditPackBox(product: docdetail)));
    return new Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        onTap: handleCardClick,
        title: Text('${docdetail.itemName}'),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 0),
              margin: EdgeInsets.only(bottom: 0),
              child: Text(
                'รหัส: ${docdetail.itemCode} หน่วยนับ: ${docdetail.unitCode} ราคา : ${docdetail.price} ',
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
                ],
              ),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    ]));
  }
}

showSaveAlertDialog(BuildContext context) {
  // set up the buttons

  Widget continueButton = ElevatedButton(
    child: Text("ตกลง"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("AlertDialog"),
    content: Text("กรุณาเลือกจุดรับ"),
    actions: [
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
