import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobilepacking/blocs/dropoff/dropoff_bloc.dart';
import 'package:mobilepacking/blocs/branch/branch_bloc.dart';
import 'package:mobilepacking/blocs/docdetail/docdetail_bloc.dart';
import 'package:mobilepacking/blocs/product/product_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/blocs/warehouse_location/warehouse_location_bloc.dart';
import 'package:mobilepacking/data/struct/docDetail.dart';
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
import 'package:mobilepacking/screens/packingBox/packboxconfirm.dart';
import 'package:mobilepacking/screens/packingSO/cubit/packingSO_cubit.dart';
import 'package:mobilepacking/util/product_util.dart';
import 'package:mobilepacking/widgets/bottom_app_bar.dart';
import 'package:mobilepacking/widgets/cart_item_list.dart';

class BoxForm extends StatefulWidget {
  final String? docnoselect;
  const BoxForm({Key? key, required this.docnoselect}) : super(key: key);

  @override
  _BoxFormState createState() => _BoxFormState();
}

class _BoxFormState extends State<BoxForm> {
  List<Branch> _branchOptions = <Branch>[Branch(code: 'เขต1', name: 'เขต1')];
  String dropPoint = "";
  // String _barcode = "";

  List<String> products = [];

  @override
  void initState() {
    context.read<DropoffBloc>()..add(DropoffLoad());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(247, 166, 245, 1),
        leading: BlocBuilder<StoreBloc, StoreState>(
          builder: (context, state) {
            List<Product> _proeduct =
                state is StoreLoadSuccess ? state.products : <Product>[];
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
          'สร้างกล่องใหม่',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              color: Colors.white,
              icon: Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ConfirmPackBox(
                          detailList: [],
                          docnumber: widget.docnoselect.toString(),
                        )));
              }),
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              //inputDropoff(context),
              buttomAppBar(context, StoreType.Packbox),
              BlocListener<DocdetailBloc, DocdetailState>(
                listener: (context, state) {
                  if (state is DocdetailScanProductFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    );
                  }
                },
                child: BlocBuilder<DocdetailBloc, DocdetailState>(
                  builder: (context, state) {
                    return state is DocDetailLoadSuccess
                        ? cartDocDetailShow(context, state.docDetail, 65)
                        : state is DocdetailInProgress
                            ? CircularProgressIndicator(
                                backgroundColor: Colors.cyanAccent,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Text(''),
                              );
                  },
                ),
              ),

              Center(
                child: Container(
                  width: 112,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade400,
                        textStyle: const TextStyle(fontSize: 18)),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ConfirmPackBox(
                                detailList: [],
                                docnumber: widget.docnoselect.toString(),
                              )));
                    },
                    child: Center(
                      child: Row(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[Icon(Icons.save), Text("บันทึก")],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
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
                "ผู้รับ",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
          SizedBox(
            height: 3,
          ),
          BlocBuilder<DropoffBloc, DropoffState>(
            builder: (context, state) {
              List<Dropoff>? dropoff;
              if (state.status == DropoffStateStatus.success) {
                dropoff = state.dropoff;
              }
              return DropdownSearch<Dropoff>(
                mode: Mode.DIALOG,
                showSearchBox: true,
                itemAsString: (Dropoff u) => u.toShowLabel(),
                items: dropoff,
                label: "จุดรับสินค้า",
                hint: "เลือกจุดรับสินค้า",
                onChanged: (drop) {
                  setState(() {
                    dropPoint = drop!.code;
                  });
                },
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
        shape: RoundedRectangleBorder(
          side: docdetail.qty_scan >= docdetail.qty_wait
              ? BorderSide(color: Colors.green, width: 2.0)
              : BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(4.0),
        ),
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
