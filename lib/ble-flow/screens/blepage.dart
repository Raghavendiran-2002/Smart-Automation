import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_devices/ble-flow/services/bleServices.dart';

class BlePage extends StatefulWidget {
  const BlePage({Key? key}) : super(key: key);

  @override
  State<BlePage> createState() => _BlePageState();
}

class _BlePageState extends State<BlePage> {
  // List<bool> deviceState = [false, false, false, false];
  List<bool> deviceState = [];
  List<int> deviceID = [1, 2, 3, 4];
  bool retrivedDeviceState = false;
  List deviceType = ["lamp", "fan", "tv", "lamp"];
  Timer? timer;
  // late bool _isLoading = true;
  late bool isConnected = false;

  @override
  void initState() {
    super.initState();
    // _storeDate();
    checkDeviceConnected();
    _readData();
    connectBluetoothDevice();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      checkDeviceConnected();
    });
  }

  _storeDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('relay1', false);
    await prefs.setBool('relay2', false);
    await prefs.setBool('relay3', false);
    await prefs.setBool('relay4', false);
  }

  _readData() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? relay1 = prefs.getBool('relay1');
    final bool? relay2 = prefs.getBool('relay2');
    final bool? relay3 = prefs.getBool('relay3');
    final bool? relay4 = prefs.getBool('relay4');
    deviceState.add(relay1!);
    deviceState.add(relay2!);
    deviceState.add(relay3!);
    deviceState.add(relay4!);
    setState(() {
      retrivedDeviceState = true;
    });
  }

  void checkDeviceConnected() async {
    bool check = false;
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

    await flutterBlue.connectedDevices.then((value) {
      value.forEach((BluetoothDevice eachDevice) {
        if (eachDevice.name.toString() == "ESP32") {
          eachDevice.readRssi().then((value) {
            print(value);
          });
          print(BluetoothPackage.instance.scanResult.rssi);
          check = true;
        }
      });
    });
    if (check) {
      setState(() {
        isConnected = true;
      });
    } else {
      setState(() {
        isConnected = false;
      });
    }
    check = false;
  }

  void connectBluetoothDevice() async {
    bool bluetoothON = await FlutterBluePlus.instance.isOn;
    bluetoothON
        ? BluetoothPackage.instance.discoverDevice()
        : reconnectDevice();
  }

  void reconnectDevice() {
    FlutterBluePlus.instance.turnOn();
    connectBluetoothDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                decoration: BoxDecoration(
                  color: isConnected ? Color(0xFF6171DC) : Color(0xFFDE837C),
                  //Color(0xFFA7C4AD),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  isConnected ? "Connect" : "Disconnected",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              retrivedDeviceState
                  ? Expanded(
                      child: GridView.builder(
                        // padding: EdgeInsets.symmetric(horizontal: 10),
                        itemCount: 4,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 100,
                          crossAxisSpacing: 15.0,
                          mainAxisSpacing: 15.0,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              bool val;

                              deviceState[index] ? val = false : val = true;
                              if (isConnected) {
                                final prefs =
                                    await SharedPreferences.getInstance();
                                BluetoothPackage.instance
                                    .actuateRelay(
                                  val,
                                  index,
                                )
                                    .then((value) {
                                  if (value) {
                                    isConnected = true;
                                    setState(() {
                                      deviceState[index] = val;
                                    });
                                  } else {
                                    isConnected = false;
                                    setState(() {
                                      deviceState[index] = !val;
                                    });
                                  }
                                  print(value);
                                  print("*************");
                                });
                                await prefs.setBool('relay${index + 1}', val);
                                // BluetoothPackage.instance.isUpdated
                                //     ? (isConnected = true)
                                //     : (isConnected = false);
                                // setState(() {
                                //   deviceState[index] = val;
                                // });
                              } else {
                                setState(() {
                                  deviceState[index] = !val;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 15),
                              decoration: BoxDecoration(
                                color: deviceState[index]
                                    ? Color(0xFF6171DC)
                                    : Color(0xFFDBDBFC),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      deviceIconWidget(deviceType[index],
                                          deviceState[index]),
                                      Transform.scale(
                                        scale: 1,
                                        child: CupertinoSwitch(
                                          activeColor: Colors.white54,
                                          value: deviceState[index],
                                          onChanged: (val) {
                                            // deviceState[index] = val;
                                            // BluetoothPackage.instance
                                            //     .actuateRelay(val, index).then((value) {
                                            //
                                            // });
                                            // setState(() {
                                            //   deviceState[index] = val;
                                            // });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      deviceState[index]
                                          ? Text(
                                              "ON",
                                              style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 12,
                                              ),
                                            )
                                          : Text(
                                              "OFF",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              GestureDetector(
                onTap: () {
                  connectBluetoothDevice();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                  decoration: BoxDecoration(
                    color: Color(0xFF6171DC),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    "Reconnect",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class deviceIconWidget extends StatelessWidget {
  late String? icon;
  late bool? deviceState;
  deviceIconWidget(this.icon, this.deviceState);

  @override
  Widget build(BuildContext context) {
    Map<bool, Color> iconColoring = {
      true: Colors.white,
      false: Color(0xFF6171DC),
    };
    Map<String, IconData> iconMapping = {
      'lock': CupertinoIcons.lock,
      'lamp': CupertinoIcons.lightbulb,
      'fan': CupertinoIcons.dial_fill,
      'tv': CupertinoIcons.tv,
    };
    Map<String, IconData> iconMappings = {
      'lock': CupertinoIcons.lock,
      'lamp': CupertinoIcons.lightbulb,
      'fan': CupertinoIcons.dial_fill,
      'tv': CupertinoIcons.tv,
    };
    return Icon(deviceState! ? iconMapping[icon] : iconMappings[icon],
        color: iconColoring[deviceState], size: 50);
  }
}
