import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobilepacking/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:mobilepacking/blocs/branch/branch_bloc.dart';
import 'package:mobilepacking/blocs/docdetail/docdetail_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/blocs/store_form/store_form_bloc.dart';
import 'package:mobilepacking/blocs/warehouse_location/warehouse_location_bloc.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/data/struct/storepack.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/screens/packingBox/packbox_box_list.dart';
import 'package:mobilepacking/screens/packingBox/packbox_cart_list.dart';
import 'package:mobilepacking/screens/packingBox/packbox_detail.dart';
import 'package:mobilepacking/widgets/bottom_app_confirm.dart';
import 'package:mobilepacking/widgets/bottom_packform_confirm.dart';
import 'package:mobilepacking/widgets/cart_item_show.dart';
import 'package:uuid/uuid.dart';

class PackBoxCartListDetail extends StatefulWidget {
  final String docnumber;
  final String docNo;
  final int boxnumber;
  final int status;
  final List<DocDetail> docDetail;
  const PackBoxCartListDetail(
      {Key? key,
      required this.docnumber,
      required this.docNo,
      required this.boxnumber,
      required this.status,
      required this.docDetail})
      : super(key: key);

  @override
  _PackBoxCartListDetailState createState() => _PackBoxCartListDetailState();
}

class _PackBoxCartListDetailState extends State<PackBoxCartListDetail> {
  TextEditingController inpDropPoint = TextEditingController();
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

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(247, 166, 245, 1),
        leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) => PackboxCartList(
                            status: widget.status,
                            docnoselect: widget.docnumber.toString(),
                          )),
                  (route) => false);
            }),
        title: Text(
          widget.docnumber.toString(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocListener<StoreFormBloc, StoreFormState>(
        listener: (context, state) {
          if (state is StoreFormDeleteSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('ลบกล่องสำเร็จ')));

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (_) => PackboxBoxList(
                          status: widget.status,
                          docnoselect: widget.docnumber.toString(),
                        )),
                (route) => false);
          } else if (state is StoreFormDeleteFailure) {
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
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        (widget.status == 0)
                            ? Row(
                                children: <Widget>[
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red.shade400,
                                        textStyle:
                                            const TextStyle(fontSize: 18)),
                                    onPressed: () {
                                      showAlertDialog(
                                          context, widget.boxnumber.toString());
                                    },
                                    child: Row(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        Icon(Icons.delete),
                                        Text("ลบกล่อง")
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  cartDocDetailShow(context, widget.docDetail, 65)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String box) {
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
          ..add(StoreFormPackingBoxDeleted(docNo: widget.docNo.toString()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("ยืนยันการทำงาน"),
      content: Text("ต้องการลบกล่องที่ " + box + " ใช่หรือไม่"),
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

  Widget cartDocDetailShow(
      BuildContext context, List<DocDetail> docdetail, double height) {
    return Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Column(
          children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Text('รายการสินค้า ' + widget.boxnumber.toString())),
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
                  return DetailCardItem(context, docdetail[index]);
                }),
          ),
        )
      ],
    );
  }

  Widget DetailCardItem(BuildContext context, DocDetail docdetail) {
    return new Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
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
                    'จำนวน : ${docdetail.qty}',
                    style: TextStyle(
                      color: Colors.black,
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
