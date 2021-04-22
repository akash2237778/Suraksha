import 'dart:collection';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:share/share.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:suraksha/Services/notification.dart';


Location location = new Location();
Color backColor = Colors.white;
double speedThreshold = 0.2;
Queue speedQ = Queue();
Queue timeQ = Queue();

class ShareLocationView extends StatefulWidget {
  final String passKey;

  ShareLocationView({Key key, this.passKey}) : super(key: key);

  @override
  _ShareLocationViewState createState() => _ShareLocationViewState();
}

class _ShareLocationViewState extends State<ShareLocationView> {
  DatabaseReference _ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationSettings();
    final FirebaseDatabase database = FirebaseDatabase();
    _ref = database.reference().child('userLocation');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(

        body: SafeArea(
          child: Container(
            color: backColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 150.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sharing your location...',
                          style: TextStyle(fontSize: 30),
                        ),
                        Icon(
                          Icons.location_on,
                          size: 40,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: Text('Stay on page to continue sharing location'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Text(
                        'Click on the button below to share your Suraksha Key'),
                  ),
                  button(widget.passKey, () {
                    Share.share(
                        'Check out my live location! My Suraksha Key : ' +
                            widget.passKey);
                    log("pressed");
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int count = 0;
  Future<void> updateValue(String lat, String long, bool isSafe, String speed) async {
    var obj = {
      widget.passKey: {"lat": lat, "long": long, "isSafe": isSafe , "speed":speed }
    };
    _ref.update(obj);
    count++;
  }

  void locationSettings() async {

    await location.changeSettings(
      interval: 500, accuracy: LocationAccuracy.high,
      //distanceFilter:
    );
    location.onLocationChanged.listen((event) {

      if (this.mounted) {
        queueManage(event.speed, event.time);
       // print(event.speed);
        if(event.speed>speedThreshold){
          updateValue(event.latitude.toString(), event.longitude.toString(), false, event.speed.toString());
          sendAlert(FirebaseAuth.instance.currentUser.displayName, 'Speed' + event.speed.toString());
          FlutterBeep.beep();
          setState(() {

            backColor = Colors.red;

          });
        }else{
          updateValue(event.latitude.toString(), event.longitude.toString(), true, event.speed.toString());
          setState(() {

            backColor = Colors.white;
          });
        }
        setState(() {


          log("update location");
        });
      }
    });
  }
}

void queueManage(double speed, double time) {
  if (!timeQ.contains(time)) {
    timeQ.addLast(time);
    speedQ.addLast(speed);

  }
  if (speedQ.length > 1) {
    if (speedQ.length > 2) {
      speedQ.removeFirst();
      timeQ.removeFirst();
    }

  }

  log(speedQ.toString());
  log(((timeQ.last-timeQ.first)/1000).toString());
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
