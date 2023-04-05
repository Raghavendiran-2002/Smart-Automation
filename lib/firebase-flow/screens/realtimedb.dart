import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../deviceinfo-flow/reusable.dart';

class RealTimeDB extends StatefulWidget {
  const RealTimeDB({Key? key}) : super(key: key);

  @override
  State<RealTimeDB> createState() => _RealTimeDBState();
}

class _RealTimeDBState extends State<RealTimeDB> {
  var db = FirebaseFirestore.instance;
  List<DeviceInfo> devicesInfo = [
    DeviceInfo("0x01", true, "fan", "ac"),
    DeviceInfo("0x01", true, "tv", "tv"),
  ];
  var orientation, size, height, width;

  void readData() {
    final docRef = db.collection("home").doc();
    docRef.get().then(
      (DocumentSnapshot doc) {
        // final data = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "My Home",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFDBDBFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    onPressed: () async {
                      // FirebaseAuth.instance.signOut();
                      // GoogleSignIn().signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/", (Route<dynamic> route) => false);
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Color(0xFF6171DC),
                      // color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 40,
            ),
            Text(
              "Good Day, !😃",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: height / 200,
            ),
            Text(
              "Manage your Home",
              style: TextStyle(
                color: Colors.black,
                // fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(
              height: height / 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${devicesInfo.length} Devices",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 50,
            ),
            if (false)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  itemCount: devicesInfo.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: kIsWeb ? 5 : 2,
                    // crossAxisCount: 2,
                    mainAxisExtent: 100,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 15.0,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        bool? val = !devicesInfo[index].deviceState!;
                        devicesInfo[index].deviceState =
                            !devicesInfo[index].deviceState!;
                        // sendResponse(val, devicesInfo[index].deviceID);
                        setState(() {
                          devicesInfo[index].deviceState = val;
                        });
                      },
                      child: CustomDeviceWidget(
                          devicesInfo[index].deviceID,
                          devicesInfo[index].deviceName,
                          devicesInfo[index].deviceType,
                          devicesInfo[index].deviceState,
                          devicesInfo[index].deviceState!
                              ? Color(0xFF6171DC)
                              : Color(0xFFDBDBFC), //0xFFDBDBFC
                          devicesInfo[index].deviceState!
                              ? Colors.white
                              : Color(0xFF6171DC),
                          index),
                    );
                  },
                ),
              ),
            SizedBox(
              height: height / 35,
            ),
          ],
        ),
      ),
    );
  }
}
