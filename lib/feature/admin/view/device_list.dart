import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_app/provider/main_provider.dart';
import 'package:print_app/res/colors.dart';
import 'package:print_app/utils/use_full_function.dart';
import 'package:provider/provider.dart';

class DeviceList extends StatefulWidget {
  static const String routeName = '/device-list';
  const DeviceList({super.key});

  @override
  State<DeviceList> createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  List<ScanResult>? devices;
  BluetoothDevice? connectedDevice; // Store the connected device

  Future<void> _requestPermissions() async {
    var status = await Permission.bluetoothScan.status;
    if (status.isDenied) {
      await Permission.bluetoothScan.request();
    }
    status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }
    log('BluetoothScan permission: $status');
    log('Location permission: ${await Permission.location.status}');
  }

  Future<void> initalRun() async {
    // Request necessary permissions for Bluetooth and location
    await _requestPermissions();

    if (await FlutterBluePlus.isSupported == false) {
      log("Bluetooth not supported by this device");
      return;
    }

    var adapterState = await FlutterBluePlus.adapterState.first;
    log("Adapter State: $adapterState");
    if (adapterState != BluetoothAdapterState.on) {
      log("Bluetooth is not turned on.");
      return;
    }

    log("Bluetooth is ON, starting scan...");
    _startScan();
  }

  Future<void> _startScan() async {
    // Clear the device list before starting a new scan
    devices = [];
    setState(() {});

    log("Starting scan...");
    var subscription = FlutterBluePlus.onScanResults.listen((results) {
      log("Scan Results: ${results.length} devices found");
      if (results.isNotEmpty) {
        devices = results;
        for (var result in results) {
          log("Device Name: ${result.device.name}, Device ID: ${result.device.id}");
        }
        setState(() {});
      }
    }, onError: (e) {
      log("Error during scan: $e");
    });

    // Start scanning for devices (without service or name filters for testing)
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 10), // Scan timeout
    );

    // Stop scanning after timeout
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
    subscription.cancel(); // Cancel subscription after scan completes
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      log("1");
      await device.connect();
      log("2");
      setState(() {
        connectedDevice = device; // Store the connected device
      });
      log("Connected to ${device.name}");
    } catch (e) {
      log("Error connecting to device: $e");
    }
  }

  runTwo() async {}

  @override
  void initState() {
    super.initState();
    // initalRun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bluetooth Devices'),
        ),
        body: Consumer<MainProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                SizedBox(
                  height: getDeviceHeight(context) * 0.001,
                ),
                // Display the connected device at the top if available

                Container(
                  width: getDeviceWidth(context),
                  padding: const EdgeInsets.all(8.0),
                  color: AppColors.primary,
                  child: Text(
                    'Connected Device: ${provider.connectedDevice?.device.name ?? 'Not connected'}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                devices == null
                    ? const Center(child: CircularProgressIndicator())
                    : devices!.isEmpty
                        ? const Center(child: Text("No devices found"))
                        : Expanded(
                            child: ListView.builder(
                              itemCount: devices!.length,
                              itemBuilder: (context, index) {
                                final device = devices![index].device;

                                return GestureDetector(
                                  onTap: () async {
                                    try {
                                      await _connectToDevice(device);

                                      // Connect to the selected device

                                      provider
                                          .setConnectedDevice(devices![index]);
                                    } catch (e) {
                                      log("Error connecting to device: $e");
                                    }
                                  },
                                  child: ListTile(
                                    title: Text(device.name.isNotEmpty
                                        ? device.name
                                        : "Unknown Device"),
                                    subtitle: Text(device.id.toString()),
                                    trailing: IconButton(
                                      icon:
                                          const Icon(Icons.bluetooth_connected),
                                      onPressed: () async {
                                        try {
                                          await _connectToDevice(device);

                                          // Connect to the selected device

                                          provider.setConnectedDevice(
                                              devices![index]);
                                        } catch (e) {
                                          log("Error connecting to device: $e");
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            );
          },
        ));
  }
}
