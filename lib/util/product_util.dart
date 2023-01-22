import 'package:mobilepacking/data/struct/error_message.dart';
import 'package:mobilepacking/data/struct/error_stack.dart';
import 'package:mobilepacking/data/struct/product.dart';
import 'package:mobilepacking/data/struct/serial_number.dart';

class ProductUtil {
  static ErrorStack checkMatchRefProductList(
      List<Product> products, List<Product> refProducts) {
    ErrorStack errorStack = ErrorStack();

    refProducts.forEach((refProduct) {
      List<Product> findDetailProduct =
          products.where((element) => element.code == refProduct.code).toList();

      if (findDetailProduct.length == 0) {
        refProduct.productStatus = ProductStatus.unknown;
        errorStack.addError(
            "-1", "Product Ref \"${refProduct.code}\" Not Found");
      } else {
        Product productForCheck = findDetailProduct[0];
        ErrorStack errorStackProduct =
            isMatchByProduct(productForCheck, refProduct);

        if (errorStackProduct.isError) {
          errorStack.isError = true;
          errorStack.errorMessages = [
            ...errorStack.errorMessages,
            ...errorStackProduct.errorMessages
          ];
          refProduct.productStatus = ProductStatus.warning;
        }
      }
    });

    return errorStack;
  }

  static ErrorStack isMatchByProduct(Product product, Product refProduct) {
    if (refProduct.qty != product.qty) {
      refProduct.productStatus = ProductStatus.warning;
      return ErrorStack.error(
          "-1", "Product Code \"${refProduct.code}\" is qty not match ");
    }

    if (refProduct.icSerialNo) {
      ErrorStack errorStack = isMatchByProductSerial(
          product.serialNumbers, refProduct.serialNumbers);

      if (errorStack.isError) {
        errorStack.errorMessages = errorStack.errorMessages.map((errorMessage) {
          return ErrorMessage(errorMessage.code,
              "Product Code  \"${refProduct.code}\" ${errorMessage.message}");
        }).toList();
      }

      refProduct.productStatus =
          errorStack.isError ? ProductStatus.warning : ProductStatus.success;

      return errorStack;
    }

    refProduct.productStatus = ProductStatus.success;
    return ErrorStack(isError: false);
  }

  static ErrorStack isMatchByProductSerial(
    List<SerialNumber> productSerial,
    List<SerialNumber> refProductSerial,
  ) {
    List<ErrorMessage> errorMessages = <ErrorMessage>[];
    refProductSerial.forEach((serial) {
      List<SerialNumber> serials = productSerial
          .takeWhile((value) => value.serialNumber == serial.serialNumber)
          .toList();
      if (serials.length == 0) {
        errorMessages.add(ErrorMessage(
            "-1", "Serial number Not Match: ${serial.serialNumber} "));
      }
    });
    return errorMessages.length == 0
        ? ErrorStack(isError: false)
        : ErrorStack(isError: true, errorMessages: errorMessages);
  }
}
