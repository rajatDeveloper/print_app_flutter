// import 'package:blue_thermal_printer_example/testprint.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';

// bluetooth.printCustom(
//     "KHANAURI JUNCTION", Size.boldLarge.val, Align.center.val);

// // PATRAN -NARWANA ROAD KHANAURI -148027
// bluetooth.printCustom("PATRAN - NARWANA ROAD KHANAURI - 148027",
//     Size.medium.val, Align.center.val);
// bluetooth.printLeftRight("8396833173", ",7495014651", Size.medium.val);
// bluetooth.printNewLine();
class DeviceList extends StatefulWidget {
  static const routeName = '/device-list';
  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<DeviceList> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  // TestPrint testPrint = TestPrint();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // TODO here add a permission request using permission_handler
    // if permission is not granted, kzaki's thermal print plugin will ask for location permission
    // which will invariably crash the app even if user agrees so we'd better ask it upfront

    // var statusLocation = Permission.location;
    // if (await statusLocation.isGranted != true) {
    //   await Permission.location.request();
    // }
    // if (await statusLocation.isGranted) {
    // ...
    // } else {
    // showDialogSayingThatThisPermissionIsRequired());
    // }

    bool? isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(width: 10),
                const Text(
                  'Device:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 30),
                Expanded(
                  child: DropdownButton(
                    items: _getDeviceItems(),
                    onChanged: (BluetoothDevice? value) =>
                        setState(() => _device = value),
                    value: _device,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  onPressed: () {
                    initPlatformState();
                  },
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _connected ? Colors.red : Colors.green),
                  onPressed: _connected ? _disconnect : _connect,
                  child: Text(
                    _connected ? 'Disconnect' : 'Connect',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            // Padding(
            //   padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
            //     onPressed: () {
            //       // testPrint.sample();
            //     },
            //     child: const Text('PRINT TEST',
            //         style: TextStyle(color: Colors.white)),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? ""),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device != null) {
      bluetooth.isConnected.then((isConnected) {
        if (isConnected == false) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _connected = false);
          });
          setState(() => _connected = true);
        }
      });
    } else {
      show('No device selected.');
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        duration: duration,
      ),
    );
  }
}

// class DeviceList extends StatefulWidget {
//   static const String routeName = '/device-list';
//   const DeviceList({super.key});

//   @override
//   State<DeviceList> createState() => _DeviceListState();
// }

// class _DeviceListState extends State<DeviceList> {
//   List<ScanResult>? devices;
//   BluetoothDevice? connectedDevice; // Store the connected device

//   Future<void> _requestPermissions() async {
//     var status = await Permission.bluetoothScan.status;
//     if (status.isDenied) {
//       await Permission.bluetoothScan.request();
//     }
//     status = await Permission.location.status;
//     if (status.isDenied) {
//       await Permission.location.request();
//     }
//     log('BluetoothScan permission: $status');
//     log('Location permission: ${await Permission.location.status}');
//   }

//   Future<void> initalRun() async {
//     // Request necessary permissions for Bluetooth and location
//     await _requestPermissions();

//     if (await FlutterBluePlus.isSupported == false) {
//       log("Bluetooth not supported by this device");
//       return;
//     }

//     var adapterState = await FlutterBluePlus.adapterState.first;
//     log("Adapter State: $adapterState");
//     if (adapterState != BluetoothAdapterState.on) {
//       log("Bluetooth is not turned on.");
//       return;
//     }

//     log("Bluetooth is ON, starting scan...");
//     _startScan();
//   }

//   Future<void> _startScan() async {
//     // Clear the device list before starting a new scan
//     devices = [];
//     setState(() {});

//     log("Starting scan...");
//     var subscription = FlutterBluePlus.onScanResults.listen((results) {
//       log("Scan Results: ${results.length} devices found");
//       if (results.isNotEmpty) {
//         devices = results;
//         for (var result in results) {
//           log("Device Name: ${result.device.name}, Device ID: ${result.device.id}");
//         }
//         setState(() {});
//       }
//     }, onError: (e) {
//       log("Error during scan: $e");
//     });

//     // Start scanning for devices (without service or name filters for testing)
//     await FlutterBluePlus.startScan(
//       timeout: const Duration(seconds: 10), // Scan timeout
//     );

//     // Stop scanning after timeout
//     await FlutterBluePlus.isScanning.where((val) => val == false).first;
//     subscription.cancel(); // Cancel subscription after scan completes
//   }

//   Future<void> _connectToDevice(BluetoothDevice device) async {
//     try {
//       log("1");
//       await device.connect();
//       log("2");
//       setState(() {
//         connectedDevice = device; // Store the connected device
//       });
//       log("Connected to ${device.name}");
//     } catch (e) {
//       log("Error connecting to device: $e");
//     }
//   }

//   runTwo() async {}

//   @override
//   void initState() {
//     super.initState();
//     initalRun();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Bluetooth Devices'),
//         ),
//         body: Consumer<MainProvider>(
//           builder: (context, provider, _) {
//             return Column(
//               children: [
//                 SizedBox(
//                   height: getDeviceHeight(context) * 0.001,
//                 ),
//                 // Display the connected device at the top if available

//                 Container(
//                   width: getDeviceWidth(context),
//                   padding: const EdgeInsets.all(8.0),
//                   color: AppColors.primary,
//                   child: Text(
//                     'Connected Device: ${provider.connectedDevice?.device.name ?? 'Not connected'}',
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.white),
//                   ),
//                 ),
//                 devices == null
//                     ? const Center(child: CircularProgressIndicator())
//                     : devices!.isEmpty
//                         ? const Center(child: Text("No devices found"))
//                         : Expanded(
//                             child: ListView.builder(
//                               itemCount: devices!.length,
//                               itemBuilder: (context, index) {
//                                 final device = devices![index].device;

//                                 return GestureDetector(
//                                   onTap: () async {
//                                     try {
//                                       await _connectToDevice(device);

//                                       // Connect to the selected device

//                                       provider
//                                           .setConnectedDevice(devices![index]);
//                                     } catch (e) {
//                                       log("Error connecting to device: $e");
//                                     }
//                                   },
//                                   child: ListTile(
//                                     title: Text(device.name.isNotEmpty
//                                         ? device.name
//                                         : "Unknown Device"),
//                                     subtitle: Text(device.id.toString()),
//                                     trailing: IconButton(
//                                       icon:
//                                           const Icon(Icons.bluetooth_connected),
//                                       onPressed: () async {
//                                         try {
//                                           await _connectToDevice(device);

//                                           // Connect to the selected device

//                                           provider.setConnectedDevice(
//                                               devices![index]);
//                                         } catch (e) {
//                                           log("Error connecting to device: $e");
//                                         }
//                                       },
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//               ],
//             );
//           },
//         ));
//   }
// }
