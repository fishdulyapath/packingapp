import 'package:flutter/material.dart';
import 'package:mobilepacking/blocs/store/store_bloc.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/screens/PackingSO/formedit.dart';

Widget itemList(context, List<Product> products, height, StoreType storeType) {
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
                return cardItem(context, products[index], storeType);
              }),
        ),
      )
    ],
  );
}

Widget cardItem(BuildContext context, Product product, StoreType storeType) {
  final handleCardClick = () => Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => EditWithdraw(product: product)));

  if (storeType == StoreType.PackingSO) {
    switch (product.productStatus) {
      case ProductStatus.success:
        return cardSuccess(product, onTap: handleCardClick);
      case ProductStatus.warning:
        return cardWarning(product, onTap: handleCardClick);
      case ProductStatus.unknown:
      default:
        return cardShadow(product);
    }
  } else {
    return cardDefault(product, onTap: handleCardClick);
  }
}

Widget cardSuccess(Product product, {VoidCallback? onTap}) {
  return cardDefault(product,
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

Widget cardWarning(Product product, {VoidCallback? onTap}) {
  return cardDefault(product,
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

Widget cardShadow(Product product, {VoidCallback? onTap}) {
  return cardDefault(
    product,
    onTap: onTap,
    tileColor: Colors.grey[50],
    textColor: Colors.grey,
  );
}

Widget cardDefault(
  Product product, {
  VoidCallback? onTap,
  ShapeBorder? shape,
  Color? tileColor,
  Color? textColor,
  Icon? icon,
}) {
  String subText = 'จำนวน : ${product.qty}';
  if (product.serialNumbers.length > 0) {
    subText += ', บาร์โค้ด : ${product.serialNumbers.length}';
  }

  return Card(
      shape: shape,
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTileTheme(
          textColor: textColor,
          child: ListTile(
            onTap: onTap,
            title: Text('${product.name}'),
            subtitle: Text(subText),
            isThreeLine: true,
            tileColor: tileColor,
            trailing: icon,
          ),
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

Widget cartItemList(BuildContext context, List<Product> products, double height,
    StoreType storeType) {
  return Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: Column(
        children: <Widget>[
          titleName(),
          SizedBox(
            height: 5,
          ),
          itemList(context, products, height, storeType),
        ],
      ));
}
