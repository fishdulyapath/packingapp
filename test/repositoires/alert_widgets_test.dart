import 'package:flutter_test/flutter_test.dart';
import 'package:mobilepacking/data/struct/error_stack.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/serial_number.dart';
import 'package:mobilepacking/util/product_util.dart';

void main() {
  test('product', () {
    Product pdt1 = Product(
        code: "95011697",
        name: "หูฟัง บลูทูธ Candy Pop",
        unitCode: "PCS",
        icSerialNo: false,
        isPremium: false);
    Product pdt2 = Product(
        code: "20036035",
        name: "DEMO OPPO A15s",
        unitCode: "PCS",
        icSerialNo: false,
        isPremium: false);
    Product pdt3 = Product(
        code: "20036122",
        name: "A-102A อาซากิอะแดปเตอร์ 22.5W(WH)",
        unitCode: "PCS",
        icSerialNo: true,
        isPremium: false);

    List<SerialNumber> serials1 = <SerialNumber>[];

    SerialNumber sn1 = SerialNumber(serialNumber: "x001");
    SerialNumber sn2 = SerialNumber(serialNumber: "x002");

    serials1.add(sn1);
    serials1.add(sn2);

    pdt3.serialNumbers = serials1;

    List<Product> productList = <Product>[];
    productList.add(pdt1);
    productList.add(pdt2);
    productList.add(pdt3);

    Product pdt4 = Product(
        code: "95011697",
        name: "หูฟัง บลูทูธ Candy Pop",
        unitCode: "PCS",
        icSerialNo: false,
        isPremium: false);
    Product pdt5 = Product(
        code: "20036035s",
        name: "DEMO OPPO A15s",
        unitCode: "PCS",
        icSerialNo: false,
        isPremium: false);
    Product pdt6 = Product(
        code: "20036122",
        name: "A-102A อาซากิอะแดปเตอร์ 22.5W(WH)",
        unitCode: "PCS",
        icSerialNo: true,
        isPremium: false);

    List<SerialNumber> serials2 = <SerialNumber>[];

    SerialNumber sn3 = SerialNumber(serialNumber: "x001xxxx");
    SerialNumber sn4 = SerialNumber(serialNumber: "x002x");

    serials2.add(sn3);
    serials2.add(sn4);

    pdt6.serialNumbers = serials2;

    List<Product> refProductList = <Product>[];
    refProductList.add(pdt4);
    refProductList.add(pdt5);
    refProductList.add(pdt6);

    // Store store = Store(
    //   docNo: "xxx",
    //   docDate: "xxx",
    //   docFormatCode: "xx",
    //   totalAmount: 0,
    //   docTime: "",
    //   branchCode: "",
    //   whCode: "whCode",
    //   shelfCode: "shelfCode",
    //   details: productList,
    // );

    ErrorStack errorStack = ProductUtil.checkMatchRefProductList(
      productList,
      refProductList,
    );
    expect(true, errorStack.isError);
  });
}
