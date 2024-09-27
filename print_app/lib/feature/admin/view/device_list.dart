import 'dart:developer';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:print_app/feature/print_cart/models/print_cart_model.dart';
import 'package:print_app/provider/main_provider.dart';
import 'package:print_app/utils/use_full_function.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceListView extends StatefulWidget {
  static const routeName = '/device-list';
  final String mode;
  const DeviceListView({super.key, required this.mode});

  @override
  State<DeviceListView> createState() => _DeviceListViewState();
}

class _DeviceListViewState extends State<DeviceListView> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _devicesMsg = "Searching for devices...";
  final f = NumberFormat("\$###,###.00", "en_US");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPrinter();
    });
  }

  Future<void> initPrinter() async {
    await _requestPermissions();

    await bluetoothPrint.startScan(timeout: const Duration(seconds: 4));

    if (!mounted) return;

    bluetoothPrint.scanResults.listen((val) {
      if (!mounted) return;

      setState(() {
        _devices = val;
        log("size :${_devices.length}");
        _devicesMsg = _devices.isEmpty ? "No Devices Found" : "";
      });
    });
  }

  Future<void> _requestPermissions() async {
    final bluetoothStatus = await Permission.bluetooth.status;
    final locationStatus = await Permission.location.status;

    if (bluetoothStatus.isDenied || locationStatus.isDenied) {
      await [Permission.bluetooth, Permission.location].request();
    }
  }

  Future<void> _startPrint(
      BluetoothDevice device, List<PrintCartModel> data) async {
    if (device.address != null) {
      try {
        await bluetoothPrint.connect(device);

        List<LineText> list = [];

        // Add the header
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "Food App",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        // Add the order details
        for (var item in data) {
          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: item.product!.name,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
          ));

          list.add(LineText(
            type: LineText.TYPE_TEXT,
            content:
                "${f.format(item.product!.price)} x ${item.quantity} = ${f.format(double.parse(item.product!.price!) * item.quantity!)}",
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
          ));
        }

        // Add the total amount
        final totalAmount = data.fold(
            0.0,
            (total, item) =>
                total + (double.parse(item.product!.price!) * item.quantity!));
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "Total: ${f.format(totalAmount)}",
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        // Send the data to the printer
        await bluetoothPrint.printReceipt({}, list);
      } catch (e) {
        log("Error while printing: $e");
        showSnackBar(context, "Printing failed: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: _devices.isEmpty
            ? Center(child: Text(_devicesMsg))
            : ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  final device = _devices[index];
                  return ListTile(
                    leading: const Icon(Icons.print),
                    title: Text(device.name ?? "Unknown device"),
                    subtitle: Text(device.address!),
                    onTap: () async {
                      try {
                        await _startPrint(device, provider.printCartList!);

                        // Add history entry
                        provider.createHistoryData(
                          context: context,
                          printProductIds: provider.printCartList!
                              .map((e) => e.id!)
                              .toList(),
                          paymentMode: widget.mode,
                        );

                        showSnackBar(context, "Printing...");
                      } catch (e) {
                        showSnackBar(context, "Error: ${e.toString()}");
                      }
                    },
                  );
                },
              ),
      );
    });
  }
}
