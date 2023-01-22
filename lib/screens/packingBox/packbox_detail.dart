import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobilepacking/blocs/branch/branch_bloc.dart';
import 'package:mobilepacking/blocs/docdetail/docdetail_bloc.dart';
import 'package:mobilepacking/blocs/doclist/doclist_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/blocs/store_form/store_form_bloc.dart';
import 'package:mobilepacking/blocs/warehouse_location/warehouse_location_bloc.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
import 'package:mobilepacking/data/struct/docList.dart';
import 'package:mobilepacking/data/struct/master_branch.dart';
import 'package:mobilepacking/data/struct/master_warehouselocation.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/screens/packingBox/packbox_box_list.dart';
import 'package:mobilepacking/screens/packingBox/packbox_cart_list.dart';
import 'package:mobilepacking/screens/packingBox/packbox_list.dart';
import 'package:mobilepacking/screens/packingBox/packboxform.dart';
import 'package:mobilepacking/screens/packingBox/packboxformsend.dart';
import 'package:mobilepacking/widgets/bottom_pack_confirm.dart';

import 'package:mobilepacking/widgets/cart_item_show.dart';
import 'package:uuid/uuid.dart';

class PackboxDetail extends StatefulWidget {
  final String? docnoselect;
  final int status;
  const PackboxDetail(
      {Key? key, required this.docnoselect, required this.status})
      : super(key: key);

  @override
  _PackboxDetailState createState() => _PackboxDetailState();
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

class _PackboxDetailState extends State<PackboxDetail> {
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

  bool _loadShow = false;

  @override
  void initState() {
    context.read<DocdetailBloc>()
      ..add(DocdetailLoaded(docNo: widget.docnoselect.toString()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  MaterialPageRoute(builder: (_) => PackboxList()),
                  (route) => false);
            }),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                buttomPackConfirm(
                  context,
                  widget.status,
                  oncreate: () => {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => BoxForm(
                                  docnoselect: widget.docnoselect.toString(),
                                )),
                        (Route<dynamic> route) => false),
                  },
                  onSubmit: () async {
                    setState(() {
                      _loadShow = true;
                    });
                    context.read<DocdetailBloc>()
                      ..add(DocdetailReLoaded(
                          docNo: widget.docnoselect.toString()));

                    Future.delayed(const Duration(milliseconds: 3500), () {
                      final storeBloc = context.read<DocdetailBloc>();

                      final storeState = storeBloc.state;

                      if (storeState is DocDetailReLoadSuccess) {
                        double item_wait = 0;
                        storeState.docDetail.forEach((element) {
                          item_wait += element.qty_wait;
                        });

                        if (item_wait == 0) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => BoxFormSend(
                                        docnoselect:
                                            widget.docnoselect.toString(),
                                      )),
                              (Route<dynamic> route) => false);
                          /*showAlertDialog(
                              context, widget.docnoselect.toString());*/
                        } else {
                          _showMyDialog();
                          context.read<DocdetailBloc>()
                            ..add(DocdetailLoaded(
                                docNo: widget.docnoselect.toString()));
                        }
                      }
                      setState(() {
                        _loadShow = false;
                      });
                    });
                  },
                  onList: () => {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => PackboxBoxList(
                                  status: widget.status,
                                  docnoselect: widget.docnoselect.toString(),
                                )),
                        (Route<dynamic> route) => false),
                  },
                  onCart: () => {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => PackboxCartList(
                                  status: widget.status,
                                  docnoselect: widget.docnoselect.toString(),
                                )),
                        (Route<dynamic> route) => false),
                  },
                ),
                SizedBox(
                  height: 1.0,
                ),
                BlocBuilder<DocdetailBloc, DocdetailState>(
                  builder: (context, state) {
                    return (state is DocDetailLoadSuccess)
                        ? cartDocDetailShow(context, state.docDetail, 65)
                        : (_loadShow)
                            ? Container(
                                margin: EdgeInsets.only(top: 50),
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.cyanAccent,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
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
                  return DetailCardItem(context, docdetail[index]);
                }),
          ),
        )
      ],
    );
  }

  Widget DetailCardItem(BuildContext context, DocDetail docdetail) {
    String subText = 'จำนวน : ${docdetail.qty} ';
    String subText2 = ' จัดเสร็จ : ${docdetail.qty_success}';
    String subText3 = ' ค้างจัด : ${docdetail.qty_wait} ';
    if (docdetail.qty_wait == 0) {
      subText3 = "";
    }
    return new Card(
        shape: RoundedRectangleBorder(
          side: docdetail.qty_wait == 0
              ? BorderSide(color: Colors.green, width: 2.0)
              : BorderSide(color: Colors.red, width: 2.0),
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
                    'รหัส: ${docdetail.itemCode} หน่วยนับ: ${docdetail.unitCode}',
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
          ),
        ]));
  }
}
