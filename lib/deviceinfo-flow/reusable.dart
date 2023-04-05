import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDeviceWidget extends StatefulWidget {
  final String? deviceName;
  final String? deviceID;
  final String? deviceType;
  late bool? deviceStatus;
  final Color widgetColors;
  final Color textColors;
  final int index;
  CustomDeviceWidget(this.deviceID, this.deviceName, this.deviceType,
      this.deviceStatus, this.widgetColors, this.textColors, this.index);

  @override
  State<CustomDeviceWidget> createState() => _CustomDeviceWidgetState();
}

class _CustomDeviceWidgetState extends State<CustomDeviceWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 15),
      decoration: BoxDecoration(
        color: widget.widgetColors,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              deviceIconWidget(widget.deviceType, widget.deviceStatus),
              Transform.scale(
                scale: 0.7,
                child: CupertinoSwitch(
                  activeColor: Colors.white54,
                  value: widget.deviceStatus!,
                  onChanged: (val) {},
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.deviceName!,
                style: TextStyle(
                  color: widget.textColors,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              widget.deviceStatus!
                  ? Text(
                      "ON",
                      style: TextStyle(
                        color: widget.textColors,
                        fontSize: 12,
                      ),
                    )
                  : Text(
                      "OFF",
                      style: TextStyle(
                        color: widget.textColors,
                        fontSize: 12,
                      ),
                    ),
            ],
          ),
        ],
      ), //BoxDecoration
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
      'ac': CupertinoIcons.snow
    };
    Map<String, IconData> iconMappings = {
      'lock': CupertinoIcons.lock,
      'lamp': CupertinoIcons.lightbulb,
      'fan': CupertinoIcons.dial_fill,
      'tv': CupertinoIcons.tv,
      'ac': CupertinoIcons.snow
    };
    return Icon(deviceState! ? iconMapping[icon] : iconMappings[icon],
        color: iconColoring[deviceState], size: 50);
  }
}

class DeviceInfo {
  String? deviceID;
  bool? deviceState;
  String? deviceName;
  String? deviceType;

  DeviceInfo(
    this.deviceID,
    this.deviceState,
    this.deviceName,
    this.deviceType,
  );

  DeviceInfo.fromJson(Map<String, dynamic> json) {
    deviceID = json['deviceID'];
    deviceState = json['deviceState'];
    deviceName = json['deviceName'];
    deviceType = json['deviceType'];
  }

  Map<String, dynamic> toJson(Map<dynamic, dynamic> map) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceID'] = this.deviceID;
    data['deviceState'] = this.deviceState;
    data['deviceName'] = this.deviceName;
    data['deviceType'] = this.deviceType;
    return data;
  }
}
