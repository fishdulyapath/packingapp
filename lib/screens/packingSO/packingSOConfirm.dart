import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobilepacking/blocs/authentication/bloc/authentication_bloc.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/blocs/store_form/store_form_bloc.dart';
import 'package:mobilepacking/data/struct/error_stack.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/store.dart';
import 'package:mobilepacking/repositories/auth_repository.dart';
import 'package:mobilepacking/util/product_util.dart';
import 'package:mobilepacking/widgets/bottom_app_confirm.dart';
import 'package:mobilepacking/widgets/cart_item_show.dart';
import 'package:uuid/uuid.dart';

class packingSOConfirm extends StatefulWidget {
  final String docNo;
  const packingSOConfirm({Key? key, required this.docNo}) : super(key: key);

  @override
  _packingSOConfirmState createState() => _packingSOConfirmState();
}

class _packingSOConfirmState extends State<packingSOConfirm> {
  TextEditingController txtDocNo = TextEditingController();
  bool _isErrorShow = false;
  bool _isError = false;
  String _errorList = "";

  @override
  void initState() {
    StoreState storeState = context.read<StoreBloc>().state;
    if (storeState is StoreLoadSuccess) {
      ErrorStack errorStack = ProductUtil.checkMatchRefProductList(
          storeState.products, storeState.refProducts);

      String _markDownData = "";
      if (errorStack.errorMessages.length > 0) {
        _markDownData = errorStack.errorMessages
            .map((errorMessage) => "- ${errorMessage.message}\n")
            .reduce((x, y) => "$x$y");
      }
      setState(() {
        _isError = errorStack.isError;
        _errorList = _markDownData;
      });

      print(_markDownData);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    txtDocNo.value = TextEditingValue(text: widget.docNo.toString());
    print(widget.docNo.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(171, 167, 242, 1),
        centerTitle: true,
        title: Text(
          'ยืนยันรายการสั่งขาย',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocListener<StoreFormBloc, StoreFormState>(
        listener: (context, state) {
          if (state is StoreFormSaveSuccess) {
            context.read<StoreBloc>().add(StoreLoaded(
                  type: StoreType.PackingSO,
                  docNo: '',
                  products: <Product>[],
                ));

            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('บันทึกสำเร็จ')));

            // Navigator.of(context).pop();
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (_) => GetWithDrawDoc()));
            int count = 0;
            Navigator.of(context).popUntil((_) => count++ >= 2);
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
                docnoTextField(),
                warningProduct(),
                BlocBuilder<StoreBloc, StoreState>(
                  builder: (context, state) {
                    return cartItemShow(
                        context,
                        state is StoreLoadSuccess
                            ? state.products
                            : <Product>[],
                        62);
                  },
                ),
                buttomAppConfirm(
                  context,
                  oncreate: () => {Navigator.of(context).pop()},
                  onSubmit: _isError
                      ? null
                      : () {
                          final storeBloc = context.read<StoreBloc>();
                          AuthenticationState authenticationState =
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .state;
                          User? user = User.empty();

                          if (authenticationState.status ==
                              AuthenticationStatus.authenticated) {
                            user = authenticationState.user ?? User.empty();
                          }

                          final storeState = storeBloc.state;
                          if (storeState is StoreLoadSuccess) {
                            context.read<StoreFormBloc>()
                              ..add(StoreFormPackingSOSaved(
                                  docNo: widget.docNo.toString()));
                          }
                        },
                )
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget docnoTextField() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: TextField(
        controller: txtDocNo,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          enabled: false,
          labelText: "เลขที่ใบส่งมอบสินค้า",
          labelStyle: TextStyle(color: Colors.black),
          hintText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget warningProduct() {
    Widget warningBox = Container();

    if (_isError) {
      warningBox = Column(
        children: [
          SizedBox(height: 10),
          ExpansionPanelList(
            elevation: 1,
            dividerColor: Colors.red,
            children: [
              ExpansionPanel(
                backgroundColor: Colors.orange[200],
                headerBuilder: (context, isExpanded) {
                  return Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "แจ้งเตือน รายการสินค้า",
                        style: TextStyle(color: Colors.black87),
                      ));
                },
                body: Container(child: Text(_errorList)),
                isExpanded: _isErrorShow,
              ),
            ],
            expansionCallback: (i, isOpen) =>
                setState(() => {_isErrorShow = !_isErrorShow}),
          ),
          SizedBox(height: 10),
        ],
      );
    }

    return warningBox;
  }
}
