
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:suraksha/Services/notification.dart';
import 'package:suraksha/Views/ViewUser.dart';

class JoinUser extends StatefulWidget {
  @override
  _JoinUserState createState() => _JoinUserState();
}

class _JoinUserState extends State<JoinUser> {
  String dropdownValue = 'One';
  DatabaseReference beacons;
  List<String> beaconsKeyList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    beaconsKeyList = [];

    final FirebaseDatabase database = FirebaseDatabase();
    beacons = database.reference().child('userLocation');

    beacons.once().then((DataSnapshot snapshot) {
      // print(snapshot.value);
      // print(snapshot.key);
      snapshot.value.forEach((key, values) {
        beaconsKeyList.add(key);
        print(beaconsKeyList);
        setState(() {
          dropdownValue = beaconsKeyList.first;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: new BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Column(
                        children: [
                          // Container(
                          //   alignment: Alignment.center,
                          //   padding: EdgeInsets.symmetric(
                          //       vertical: 10, horizontal: 30),
                          //   // margin: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                          //   child: DropdownButton<String>(
                          //     value: dropdownValue,
                          //     iconSize: 24,
                          //     elevation: 16,
                          //     style: const TextStyle(color: Colors.black),
                          //     underline: Container(
                          //       height: 2,
                          //       color: Colors.black,
                          //     ),
                          //     onChanged: (String newValue) {
                          //       setState(() {
                          //         dropdownValue = newValue;
                          //       });
                          //     },
                          //     items: beaconsKeyList
                          //         .map<DropdownMenuItem<String>>(
                          //             (String value) {
                          //       return DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Text(value),
                          //       );
                          //     }).toList(),
                          //   ),
                          // ),
                          // Text(
                          //   "OR",
                          //   style: TextStyle(fontSize: 25, color: Colors.black),
                          // ),
                          Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 30),
                              // margin: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                              child: TextField(
                                decoration: InputDecoration(
                                    labelText: 'Enter User\'s passKey',
                                    hintText: 'Enter Your Name'),
                                onChanged: (text) {
                                  dropdownValue = text;
                                },
                              )),
                        ],
                      ),
                    ),
                  ),
                  button("View Location", () {
                    if (beaconsKeyList.contains(dropdownValue))
                      setFCMToken(dropdownValue);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewUser(
                                  beaconKey: dropdownValue,
                                )),
                      );
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

GestureDetector button(String buttonText, Function onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      color: Colors.blue,
      child: Text(
        buttonText,
        style: TextStyle(fontSize: 25, color: Colors.white),
      ),
    ),
  );
}
