import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:intl/intl.dart';
import 'package:print_app/feature/print_cart/models/print_cart_model.dart';
import 'package:print_app/printerenum.dart';

class TestPrint {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  // Alignment and Size Constants
  final int centerAlign = Align.center.val;
  final int leftAlign = Align.left.val;
  final int boldLarge = Size.boldLarge.val;
  final int bold = Size.bold.val;
  final int medium = Size.medium.val;

  // Method to calculate total quantity
  int _getTotalQuantity(List<PrintCartModel> printCartList) {
    return printCartList.fold(0, (total, e) => total + (e.quantity ?? 0));
  }

  String formatDate() {
    // Parse the date string into a DateTime object
    DateTime dateTime = DateTime.now();

    // Define the desired format
    DateFormat formatter = DateFormat('d MMM yyyy h:mm a');

    // Format the DateTime object to the desired string format
    return formatter.format(dateTime);
  }

  // Method to calculate total amount
  double _getTotalAmount(List<PrintCartModel> printCartList) {
    return printCartList.fold(
        0.0,
        (total, e) =>
            total + ((e.quantity ?? 0) * (double.parse(e.product!.price!))));
  }

  // Main print function
  Future<void> printMainData(
      {required List<PrintCartModel> invoiceItem, required String mode}) async {
    // Check Bluetooth connection
    bool isConnected = await bluetooth.isConnected ?? false;
    if (!isConnected) {
      print("Bluetooth is not connected");
      return;
    }

    // Print Header
    bluetooth.printCustom("KHANAURI JUNCTION", boldLarge, centerAlign);
    bluetooth.printCustom(
        "PATRAN - NARWANA ROAD KHANAURI - 148027", medium, centerAlign);
    bluetooth.printLeftRight("Anil: 8396833173", "Ankit: 7495014651", medium);

    bluetooth.printNewLine();
    //Date
    bluetooth.printCustom(formatDate(), medium, centerAlign);

    bluetooth.printNewLine();

    // Print Invoice Items
    for (var item in invoiceItem) {
      bluetooth.printCustom("${item.product!.name}", bold, leftAlign);
      bluetooth.printLeftRight(
        "${item.quantity} x ${item.product!.price!} =",
        (double.parse(item.product!.price!) * (item.quantity ?? 0))
            .toStringAsFixed(2),
        bold,
      );
    }
    bluetooth.printNewLine();

    // Print Payment Mode
    bluetooth.printLeftRight("Mode: ", mode, bold);

    // Print Total Quantity
    final totalQuantity = _getTotalQuantity(invoiceItem);
    bluetooth.printLeftRight("Total Quantity: ", "$totalQuantity", bold);

    // Print Total Amount
    final totalAmount = _getTotalAmount(invoiceItem);
    bluetooth.printLeftRight(
        "Total Amount: ", totalAmount.toStringAsFixed(2), bold);
    bluetooth.printNewLine();

    // Footer
    bluetooth.printCustom("Thank you, Visit again", bold, centerAlign);
    bluetooth.printNewLine();
    bluetooth.printNewLine();
    bluetooth.printNewLine();

    // Cut Paper (with delay to ensure paper holds)
    bluetooth.paperCut();
    await Future.delayed(
        Duration(milliseconds: 500)); // Add delay before second cut
    bluetooth.paperCut();
  }
}
