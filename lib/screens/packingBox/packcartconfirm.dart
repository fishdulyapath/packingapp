import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobilepacking/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:mobilepacking/blocs/branch/branch_bloc.dart';
import 'package:mobilepacking/blocs/docdetail/docdetail_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/blocs/store_form/store_form_bloc.dart';
import 'package:mobilepacking/blocs/store_form_cart/store_form_cart_bloc.dart';
import 'package:mobilepacking/blocs/warehouse_location/warehouse_location_bloc.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/data/struct/storepack.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/screens/packingBox/packbox_cart_list.dart';
import 'package:mobilepacking/screens/packingBox/packbox_detail.dart';
import 'package:mobilepacking/screens/packingBox/packcart_detail.dart';
import 'package:mobilepacking/widgets/bottom_app_confirm.dart';
import 'package:mobilepacking/widgets/bottom_packform_confirm.dart';
import 'package:mobilepacking/widgets/cart_item_show.dart';
import 'package:uuid/uuid.dart';

class ConfirmCartkBox extends StatefulWidget {
  final String docnumber;
  const ConfirmCartkBox({Key? key, required this.docnumber}) : super(key: key);

  @override
  _ConfirmCartkBoxState createState() => _ConfirmCartkBoxState();
}

class _ConfirmCartkBoxState extends State<ConfirmCartkBox> {
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
    inpDropPoint.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(247, 166, 245, 1),
        title: Text(
          'ยืนยันสร้างตะกร้า',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocListener<StoreFormCartBloc, StoreFormCartState>(
        listener: (context, state) {
          if (state is StoreFormCartSaveSuccess) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('บันทึกสำเร็จ')));

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (_) => PackboxCartList(
                          status: 0,
                          docnoselect: widget.docnumber.toString(),
                        )),
                (route) => false);
          } else if (state is StoreFormSaveFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              'บันทึกล้มเหลว!',
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
                  buttomPackFormConfirm(
                    context,
                    onBack: () => {Navigator.of(context).pop()},
                    onSubmit: () {
                      final docdetailBloc = context.read<DocdetailBloc>();

                      AuthenticationState authenticationState =
                          BlocProvider.of<AuthenticationBloc>(context).state;
                      User? user = User.empty();

                      if (authenticationState.status ==
                          AuthenticationStatus.authenticated) {
                        user = authenticationState.user ?? User.empty();
                      }
                      var dt = DateTime.now();

                      String docDate = DateFormat('yyyy-MM-dd').format(dt);
                      String docTime = DateFormat('HH:mm').format(dt);
                      String docNo = "C" +
                          DateFormat('yyyyMMddHHmmss').format(dt) +
                          new Uuid()
                              .v1()
                              .toString()
                              .substring(0, 23)
                              .split('-')[3]
                              .toUpperCase();
                      final docdetailState = docdetailBloc.state;
                      List<DocDetail> docdetailscans = [];
                      if (docdetailState is DocDetailLoadSuccess) {
                        double _totalAmount = 0;
                        int line_number = 0;
                        docdetailState.docDetail.forEach((detail) {
                          if (detail.qty_scan > 0) {
                            detail.sumAmount = detail.price * detail.qty;
                            _totalAmount += detail.sumAmount;
                            DocDetail docdetailscan = DocDetail(
                                itemCode: detail.itemCode,
                                itemName: detail.itemName,
                                unitCode: detail.unitCode,
                                lineNumber: line_number,
                                price: detail.price,
                                qty: detail.qty,
                                qty_scan: detail.qty_scan,
                                qty_success: detail.qty_success,
                                qty_wait: detail.qty_wait,
                                sumAmount: detail.sumAmount);
                            line_number++;
                            docdetailscans.add(docdetailscan);
                          }
                        });

                        StorePack storePack = StorePack(
                            docNo: docNo,
                            docDate: docDate,
                            dropCode: "",
                            totalAmount: _totalAmount,
                            boxNumber: 0,
                            status: 0,
                            docTime: docTime,
                            branchCode: user.branchCode,
                            creatorCode: user.userCode,
                            docRef: widget.docnumber.toString(),
                            details: docdetailscans);

                        context.read<StoreFormCartBloc>()
                          ..add(StoreFormCartPackingBoxSaved(
                              storePack: storePack));
                      }
                    },
                  ),
                  /*  Container(
                    child: TextField(
                      readOnly: true,
                      controller: inpDropPoint,
                      decoration: InputDecoration(
                        labelText: "จุดรับสินค้า",
                        hintText: "",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ),*/
                  BlocBuilder<DocdetailBloc, DocdetailState>(
                    builder: (context, state) {
                      return cartDocDetailShow(
                          context,
                          state is DocDetailLoadSuccess
                              ? state.docDetail
                              : <DocDetail>[],
                          65);
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
                  if (docdetail[index].qty_scan > 0) {
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

    return new Card(
        shape: RoundedRectangleBorder(
          side: docdetail.qty_scan >= docdetail.qty_wait
              ? BorderSide(color: Colors.green, width: 2.0)
              : BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
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
                        subText,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        subText2,
                        style: TextStyle(
                          color: Colors.green,
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
