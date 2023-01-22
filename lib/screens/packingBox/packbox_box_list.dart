import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
import 'package:mobilepacking/screens/packingBox/packbox_detail.dart';
import 'package:mobilepacking/screens/packingBox/packbox_list.dart';
import 'package:mobilepacking/screens/packingBox/packboxform.dart';
import 'package:mobilepacking/widgets/bottom_app_confirm.dart';
import 'package:mobilepacking/widgets/bottom_pack_confirm.dart';
import 'package:mobilepacking/widgets/cart_item_show.dart';
import 'package:uuid/uuid.dart';

class PackboxBoxList extends StatefulWidget {
  final String? docnoselect;
  final int status;
  const PackboxBoxList(
      {Key? key, required this.docnoselect, required this.status})
      : super(key: key);

  @override
  _PackboxBoxListState createState() => _PackboxBoxListState();
}

class _PackboxBoxListState extends State<PackboxBoxList> {
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
    context.read<BoxlistBloc>()
      ..add(BoxlistLoaded(docNo: widget.docnoselect.toString()));

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
                BlocBuilder<BoxlistBloc, BoxlistState>(
                  builder: (context, state) {
                    return (state is BoxlistLoadSuccess)
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
          "รายการกล่อง",
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

  String _formatDate(date) {
    List<String> date_split = date.split('-');
    return date_split[2] + '/' + date_split[1] + '/' + date_split[0];
  }

  Widget DetailCardItem(BuildContext context, StorePack docdetail) {
    return new Card(
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      ListTile(
        onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (_) => PackBoxListDetail(
                        docNo: docdetail.docNo,
                        boxnumber: docdetail.boxNumber,
                        status: widget.status,
                        docDetail: docdetail.details,
                        docnumber: widget.docnoselect.toString(),
                      )),
              (route) => false);
        },
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
                        'กล่องที่ ${docdetail.boxNumber}',
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
