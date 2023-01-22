import 'package:flutter/material.dart';
import 'package:mobilepacking/data/struct/product.dart';

Widget itemList(context, List<Product> products, height) {
  return Row(
    children: [
      Expanded(
        child: SizedBox(
          height: (MediaQuery.of(context).size.height / 100) * height,
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                return cardItem(context, products[index]);
              }),
        ),
      )
    ],
  );
}

Widget cardItem(BuildContext context, Product product) {
  String subText = 'จำนวน : ${product.qty}';
  if (product.serialNumbers.length > 0) {
    subText += ', บาร์โค้ด : ${product.serialNumbers.length}';
  }

  return new Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
    ListTile(
      title: Text('${product.name}'),
      subtitle: Text(subText),
      isThreeLine: true,
    ),
  ]));
}

Widget titleName() {
  return Row(
    children: [
      Text(
        "รายการสินค้า",
        style: TextStyle(fontSize: 15),
      )
    ],
  );
}

Widget cartItemShow(
    BuildContext context, List<Product> products, double height) {
  return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Column(
        children: <Widget>[
          titleName(),
          SizedBox(
            height: 5,
          ),
          itemList(context, products, height)
        ],
      ));
}
