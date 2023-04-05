import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothPackage {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  late BluetoothDevice connectedDevice;
  late bool isOnline = false;
  late bool isUpdated;
  var DeviceID = "ESP32";
  late ScanResult scanResult;
  void connectBLEDevice(BluetoothDevice device) async {
    await device.connect(autoConnect: true).catchError((error) async {
      await device.disconnect();
      await Future.delayed(Duration(seconds: 2));
      discoverDevice();
    });
    initServiceCharacteristic(device);
  }

  void initServiceCharacteristic(Device) async {
    List<BluetoothService> services = await Device.discoverServices();
    for (int j = 0; j < services.length; j++) {
      if (services[j].uuid.toString() ==
          "28406d0e-73e1-11ed-a1eb-0242ac120002") {
        List<BluetoothCharacteristic> characteristicsList =
            services[j].characteristics;
        for (int i = 0; i < characteristicsList.length; i++) {
          if (characteristicsList[i].uuid.toString() ==
              "beb5483e-36e1-4688-b7f5-ea07361b26a8") {
            isOnline = true;
          }
        }
      }
    }
  }

  // void isDeviceConnected() async {
  //   await flutterBlue.connectedDevices.then((value) {
  //     value.forEach((BluetoothDevice eachDevice) async {
  //       switch (eachDevice.name.toString()) {
  //         case "TestDevice":
  //           List<BluetoothService> services =
  //               await eachDevice.discoverServices();
  //           for (int j = 0; j < services.length; j++) {
  //             if (services[j].uuid.toString() ==
  //                 "28406d0e-73e1-11ed-a1eb-0242ac120002") {
  //               List<BluetoothCharacteristic> characteristicsList =
  //                   services[j].characteristics;
  //               for (int i = 0; i < characteristicsList.length; i++) {
  //                 if (characteristicsList[i].uuid.toString() ==
  //                     "beb5483e-36e1-4688-b7f5-ea07361b26a8") {
  //                   List<int> value = await characteristicsList[i].read();
  //                   if (String.fromCharCodes(value) == "Connected") {
  //                     isOnline = true;
  //                     print(String.fromCharCodes(value));
  //                   } else {
  //                     isOnline = false;
  //                     print(String.fromCharCodes(value));
  //                   }
  //                 }
  //               }
  //             }
  //           }
  //           break;
  //         default:
  //           isOnline = false;
  //       }
  //     });
  //   });
  // }

  Future<bool> actuateRelay(deviceState, deviceID) async {
    // await flutterBlue.connectedDevices.then((value) {
    //   value.forEach((BluetoothDevice eachDevice) {
    //     if (eachDevice.name.toString() == "TestDevice") {
    //       isOnline = true;
    //     }
    //   });
    // });

    List<BluetoothService> services = await connectedDevice.discoverServices();
    for (int j = 0; j < services.length; j++) {
      if (services[j].uuid.toString() ==
          "28406d0e-73e1-11ed-a1eb-0242ac120002") {
        List<BluetoothCharacteristic> characteristicsList =
            services[j].characteristics;
        for (int i = 0; i < characteristicsList.length; i++) {
          if (characteristicsList[i].uuid.toString() ==
              "beb5483e-36e1-4688-b7f5-ea07361b26a8") {
            final json =
                '{ "deviceState": $deviceState , "deviceID": $deviceID}';
            try {
              await characteristicsList[i]
                  .write(json.codeUnits)
                  .then((value) async {
                List<int> value = await characteristicsList[i].read();
                print("Reciveddddd");
                print(String.fromCharCodes(value));
                if (String.fromCharCodes(value) == "deviceState") {
                  isUpdated = true;
                  // return true;
                }
              });
            } catch (e) {
              isUpdated = false;
              isOnline = false;
              print(e);
              print('*********');
              // return false;
            }
          }
        }
      }
    }
    return Future<bool>.value(isUpdated);
  }

  void readValue(BluetoothCharacteristic ble) async {
    List<int> value = await ble.read();
    // await ble.read().
    // print(value);
    // print(String.fromCharCode(value[0]));
    print(String.fromCharCodes(value));
  }

  void writeValue(
      var deviceID, var deviceState, BluetoothCharacteristic ble) async {
    print("Startted");
    final json = '{ "deviceState": $deviceState , "deviceID": $deviceID}';
    await ble.write([0, 0], withoutResponse: true);
    // await ble.write(msg.codeUnits);
  }

  void discoverDevice() async {
    await flutterBlue.connectedDevices.then((value) {
      value.forEach((BluetoothDevice eachDevice) {
        if (eachDevice.name.toString() == DeviceID) {
          initServiceCharacteristic(eachDevice);
          connectedDevice = eachDevice;
        }
      });
      flutterBlue.startScan(timeout: Duration(seconds: 1));
      bool isFirst = true;
      flutterBlue.scanResults.listen((results) {
        for (ScanResult r in results) {
          print('Devicesss  : ${r}');
          print(r.rssi);
          scanResult = r;
          if (r.device.name.toString() == DeviceID && isFirst) {
            // if (r.device.name.toString() == "TestDevice" && isFirst) {
            connectBLEDevice(r.device);
            connectedDevice = r.device;
          }
        }
      });
    });
  }

  BluetoothPackage._();

  static final instance = BluetoothPackage._();
}
