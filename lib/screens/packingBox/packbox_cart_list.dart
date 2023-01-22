import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobilepacking/blocs/boxcartlist/boxcartlist_bloc.dart';
import 'package:mobilepacking/blocs/boxlist/boxlist_bloc.dart';
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
import 'package:mobilepacking/data/struct/storepack.dart';
import 'package:mobilepacking/screens/packingBox/packbox_box_detail.dart';
import 'package:mobilepacking/screens/packingBox/packbox_cart_detail.dart';
import 'package:mobilepacking/screens/packingBox/packbox_detail.dart';
import 'package:mobilepacking/screens/packingBox/packbox_list.dart';
import 'package:mobilepacking/screens/packingBox/packboxform.dart';
import 'package:mobilepacking/screens/packingBox/packcartedit.dart';
import 'package:mobilepacking/screens/packingBox/packcartform.dart';
import 'package:mobilepacking/screens/packingBox/packcartformmerge.dart';
import 'package:mobilepacking/widgets/bottom_app_confirm.dart';
import 'package:mobilepacking/widgets/bottom_pack_confirm.dart';
import 'package:mobilepacking/widgets/cart_item_show.dart';
import 'package:uuid/uuid.dart';

class PackboxCartList extends StatefulWidget {
  final String? docnoselect;
  final int status;
  const PackboxCartList(
      {Key? key, required this.docnoselect, required this.status})
      : super(key: key);

  @override
  _PackboxCartListState createState() => _PackboxCartListState();
}

class _PackboxCartListState extends State<PackboxCartList> {
  bool selectmode = false;
  List<String> selectCart = [];
  List<StorePack> docdetailList = [];
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
    context.read<BoxcartlistBloc>()
      ..add(BoxcartlistLoaded(docNo: widget.docnoselect.toString()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(247, 166, 245, 1),
        title: Text(
          'รายการตะกร้า',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (_) => PackboxDetail(
                            status: widget.status,
                            docnoselect: widget.docnoselect.toString(),
                          )),
                  (route) => false);
            }),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    (!selectmode)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                textStyle: const TextStyle(fontSize: 18)),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => CartForm(
                                            status: widget.status,
                                            docnoselect:
                                                widget.docnoselect.toString(),
                                          )),
                                  (Route<dynamic> route) => false);
                            },
                            child: Row(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(Icons.add_shopping_cart),
                                Text(" สร้างตะกร้า")
                              ],
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade700,
                                textStyle: const TextStyle(fontSize: 18)),
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => CartFormMerge(
                                            cartselect: docdetailList,
                                            status: widget.status,
                                            docnoselect:
                                                widget.docnoselect.toString(),
                                          )),
                                  (Route<dynamic> route) => false);
                            },
                            child: Row(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(Icons.add_box),
                                Text(" สร้างกล่อง")
                              ],
                            ),
                          ),
                    SizedBox(
                      width: 10,
                    ),
                    (!selectmode)
                        ? ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                textStyle: const TextStyle(fontSize: 18)),
                            onPressed: () {
                              setState(() {
                                selectCart = [];
                                docdetailList = [];
                                selectmode = true;
                              });
                            },
                            child: Row(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(Icons.check_box_outlined),
                                Text(" รวมกล่อง")
                              ],
                            ),
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade700,
                                textStyle: const TextStyle(fontSize: 18)),
                            onPressed: () {
                              setState(() {
                                selectCart = [];
                                docdetailList = [];
                                selectmode = false;
                              });
                            },
                            child: Row(
                              // Replace with a Row for horizontal icon + text
                              children: <Widget>[
                                Icon(Icons.cancel_presentation),
                                Text(" ยกเลิกรวมกล่อง")
                              ],
                            ),
                          ),
                  ],
                ),
                BlocBuilder<BoxcartlistBloc, BoxcartlistState>(
                  builder: (context, state) {
                    return (state is BoxcartlistLoadSuccess)
                        ? cartDocDetailShow(context, state.storePack, 75)
                        : Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text('ไม่พบข้อมูล'),
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
      BuildContext context, List<StorePack> docdetail, double height) {
    return Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Column(
          children: <Widget>[
            titleBoxName(),
            SizedBox(
              height: 5,
            ),
            DocitemList(context, docdetail, height)
          ],
        ));
  }

  Widget titleBoxName() {
    return Row(
      children: [
        Text(
          "รายการตะกร้า",
          style: TextStyle(fontSize: 15),
        )
      ],
    );
  }

  Widget DocitemList(context, List<StorePack> docdetail, height) {
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

  bool checkSelect(String docno) {
    int found = 0;
    selectCart.forEach((data) {
      if (data == docno) {
        found++;
      }
    });
    if (found != 0) {
      return true;
    } else {
      return false;
    }
  }

  String _formatDate(date) {
    List<String> date_split = date.split('-');
    return date_split[2] + '/' + date_split[1] + '/' + date_split[0];
  }

  Widget DetailCardItem(BuildContext context, StorePack docdetail) {
    return new Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
          side: BorderSide(
              color: checkSelect(docdetail.docNo) ? Colors.blue : Colors.white,
              width: 2.0),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            onTap: () {
              if (selectmode) {
                setState(() {
                  if (checkSelect(docdetail.docNo)) {
                    selectCart.removeWhere((ele) => ele == docdetail.docNo);
                    docdetailList
                        .removeWhere((ele) => ele.docNo == docdetail.docNo);
                  } else {
                    selectCart.add(docdetail.docNo);
                    docdetailList.add(docdetail);
                  }
                });
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => CartEdit(
                              docnoselect: widget.docnoselect,
                              docno: docdetail.docNo,
                              boxnumber: docdetail.boxNumber,
                              status: widget.status,
                              docDetail: docdetail.details,
                              docnumber: widget.docnoselect.toString(),
                            )),
                    (route) => false);
              }
            },
            //CartEdit
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${docdetail.docNo}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'ผู้สร้าง: ${docdetail.creatorCode} ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          Text(
                            'วันที่ : ${_formatDate(docdetail.docDate)}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'เวลา : ${docdetail.docTime}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        children: [
                          Text(
                            'จำนวนสินค้า : ${docdetail.details.length}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          Text(
                            'มูลค่า : ${docdetail.totalAmount}',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )
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
