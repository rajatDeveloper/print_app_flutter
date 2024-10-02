import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:print_app/feature/print_cart/models/print_cart_model.dart';
import 'package:print_app/printerenum.dart';

class TestPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  // Method to calculate total quantity
  int _getTotalQuantity(List<PrintCartModel> printCartList) {
    return printCartList.fold(0, (total, e) => total + (e.quantity ?? 0));
  }

  // Method to calculate total amount
  double _getTotalAmount(List<PrintCartModel> printCartList) {
    return printCartList.fold(
        0.0,
        (total, e) =>
            total + ((e.quantity ?? 0) * (double.parse(e.product!.price!))));
  }

  // Main print function
  printMainData(
      {required List<PrintCartModel> invoiceItem, required String mode}) async {
    // Ensure Bluetooth is connected
    bool isConnected = await bluetooth.isConnected ?? false;
    if (isConnected) {
      // Print header
      bluetooth.printCustom(
          "KHANAURI JUNCTION", Size.boldLarge.val, Align.center.val);

// PATRAN -NARWANA ROAD KHANAURI -148027
      bluetooth.printCustom("PATRAN - NARWANA ROAD KHANAURI - 148027",
          Size.medium.val, Align.center.val);
      bluetooth.printLeftRight("Anil", "Ankit", Size.medium.val);
      bluetooth.printLeftRight("8396833173", "7495014651", Size.medium.val);
      bluetooth.printNewLine();

      // Print invoice details (Product name, price, quantity)
      for (var item in invoiceItem) {
        bluetooth.printCustom(
            "${item.product!.name}", Size.medium.val, Align.left.val);

        bluetooth.printLeftRight(
            "${item.quantity} x ${item.product!.price!} =",
            "${(double.parse(item.product!.price!) * (item.quantity ?? 0)).toStringAsFixed(2)}",
            Size.medium.val);
      }
      bluetooth.printNewLine();

      // Print total quantity
      final totalQuantity = _getTotalQuantity(invoiceItem);

      bluetooth.printLeftRight(
          "Total Quantity: ", "$totalQuantity", Size.bold.val);

      bluetooth.printLeftRight("Mode: ", mode, Size.bold.val);

      // Print total amount
      final totalAmount = _getTotalAmount(invoiceItem);
      bluetooth.printLeftRight(
          "Total Amount: ", "${totalAmount.toStringAsFixed(2)}", Size.bold.val);
      bluetooth.printNewLine();

      // Optionally, print footer
      bluetooth.printCustom(
          "Thank you, Visit again", Size.bold.val, Align.center.val);
      bluetooth.printNewLine();

      // Optionally, print QR code
      // bluetooth.printQRcode("Order Summary", 200, 200, Align.center.val);
      // bluetooth.printNewLine();

      // Optionally, cut paper
      bluetooth.paperCut();
    } else {
      // Handle case when not connected
      print("Bluetooth is not connected");
    }
  }
}
