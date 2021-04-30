import 'dart:collection';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:share/share.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:suraksha/Services/notification.dart';
import 'package:all_sensors/all_sensors.dart';
import 'dart:math' as math;

import 'package:syncfusion_flutter_gauges/gauges.dart';

Location location = new Location();
Color backColor = Colors.white;
double speedThreshold = 80;
Queue speedQ = Queue();
Queue timeQ = Queue();
bool isTesting = false;

class ShareLocationView extends StatefulWidget {
  final String passKey;

  ShareLocationView({Key key, this.passKey}) : super(key: key);

  @override
  _ShareLocationViewState createState() => _ShareLocationViewState();
}

class _ShareLocationViewState extends State<ShareLocationView> {
  DatabaseReference _ref;
  List<double> _accelerometerValues;
  double acc;
  double speed = 0;

  @override
  void initState() {
    super.initState();
    locationSettings();
    final FirebaseDatabase database = FirebaseDatabase();
    _ref = database.reference().child('userLocation');

    gyroscopeEvents.listen((GyroscopeEvent event) {
      if (mounted)
        setState(() {
          _accelerometerValues = <double>[event.x, event.y, event.z];

          acc = math.sqrt(math.pow(_accelerometerValues[0], 2) +
              math.pow(_accelerometerValues[1], 2) +
              math.pow(_accelerometerValues[2], 2));
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sharing your location',
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            color: backColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 300,
                      child: SfRadialGauge(
                          title: GaugeTitle(
                              text: 'Speed',
                              textStyle: const TextStyle(
                                  fontSize: 10.0, fontWeight: FontWeight.bold)),
                          axes: <RadialAxis>[
                            RadialAxis(minimum: 0, maximum: 150, ranges: <
                                GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 50,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 50,
                                  endValue: 100,
                                  color: Colors.orange,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 100,
                                  endValue: 150,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10)
                            ], pointers: <GaugePointer>[
                              NeedlePointer(
                                value: speed,
                                enableAnimation: true,
                              )
                            ], annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Container(
                                      child: Text(
                                          speed.toInt().toString().toString(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold))),
                                  angle: 90,
                                  positionFactor: 0.5)
                            ])
                          ])),
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
                  }),
                  GestureDetector(
                    onTap: () {
                      testWithRandom();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                      color: speedThreshold == -1 ? Colors.green : Colors.red,
                      child: Text(
                        'Test',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int count = 0;
  Future<void> updateValue(
      String lat, String long, bool isSafe, String speed) async {
    var obj = {
      widget.passKey: {
        "lat": lat,
        "long": long,
        "isSafe": isSafe,
        "speed": speed
      }
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
        queueManage(event.speed, event.time, acc, event);

        // print(event.speed);
        if (event.speed > speedThreshold) {
          updateValue(event.latitude.toString(), event.longitude.toString(),
              false, event.speed.toString());
          sendAlert(FirebaseAuth.instance.currentUser.displayName,
              'Speed :' + event.speed.toInt().toString());
          FlutterBeep.beep();
          setState(() {
            speed = event.speed;
            backColor = Colors.red;
          });
        } else {
          updateValue(event.latitude.toString(), event.longitude.toString(),
              true, event.speed.toString());
          setState(() {
            speed = event.speed;
            backColor = Colors.white;
          });
        }
        setState(() {
          log("update location");
        });
      }
    });
  }

  void queueManage(double speed, double time, double acc, var event) {
    if (!timeQ.contains(time)) {
      timeQ.addLast(time);
      speedQ.addLast(speed);
    }
    if (speedQ.length > 1) {
      if (speedQ.length > 2) {
        speedQ.removeFirst();
        timeQ.removeFirst();

        log(speedQ.toString());
        log(((timeQ.last - timeQ.first) / 1000).toString());

        double impact =
            (speedQ.last - speedQ.first) / ((timeQ.last - timeQ.first) / 1000);

        if (!isSafe(impact, resultantToMultiplier(acc))) {
          setState(() {
            int ch = resultantToMultiplier(acc);
            if (ch == 2) {
              backColor = Colors.yellow;
              sendAlert(
                  'Accident Alert! Mild',
                  'Speed : ' +
                      event.speed.toInt().toString() +
                      '   impact : ' +
                      (impact * resultantToMultiplier(acc)).toString());
            } else if (ch == 3) {
              backColor = Colors.blue;
              sendAlert(
                  'Accident Alert! Severe',
                  'Speed : ' +
                      event.speed.toInt().toString() +
                      '   impact : ' +
                      (impact * resultantToMultiplier(acc)).toString());
            } else {
              backColor = Colors.red;
              sendAlert(
                  'Accident Alert! Extreme',
                  'Speed : ' +
                      event.speed.toInt().toString() +
                      '   impact : ' +
                      (impact * resultantToMultiplier(acc)).toString());
            }
          });
          updateValue(event.latitude.toString(), event.longitude.toString(),
              false, event.speed.toString());
          // sendAlert(
          //     'Accident Alert',
          //     'Speed' +
          //         event.speed.toInt().toString() +
          //         '   impact : ' +
          //         (impact * resultantToMultiplier(acc)).toString());
        }
      }
    }
  }

  void testWithRandom() {
    Event event = new Event();
    var rng = new math.Random();
    event.speed = rng.nextInt(90).toDouble();
    event.time = DateTime.now().millisecondsSinceEpoch.toDouble();
    event.latitude = 28.528973 + (rng.nextInt(50).toDouble() / 100000000);
    event.longitude = 77.3304438 + (rng.nextInt(50).toDouble() / 100000000);

    if (this.mounted) {
      queueManage(event.speed, event.time, acc, event);

      if (event.speed > speedThreshold) {
        updateValue(event.latitude.toString(), event.longitude.toString(),
            false, event.speed.toString());
        sendAlert(FirebaseAuth.instance.currentUser.displayName,
            'Speed :' + event.speed.toInt().toString());
        FlutterBeep.beep();
        setState(() {
          speed = event.speed;
          backColor = Colors.red;
        });
      } else {
        updateValue(event.latitude.toString(), event.longitude.toString(), true,
            event.speed.toString());
        setState(() {
          speed = event.speed;
          backColor = Colors.white;
        });
      }
      setState(() {
        log("update location");
      });
    }
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

int resultantToMultiplier(double resultant) {
  if (resultant < 9 && resultant > -9)
    return 1;
  else if (resultant < 10 && resultant > -10)
    return 2;
  else if (resultant < 20 && resultant > -20)
    return 3;
  else
    return 4;
}

bool isSafe(double speedChange, int multiplier) {
  double temp = speedChange * multiplier;
  if (temp < 10 && temp > -10)
    return true; //  No accident
  else if (temp < 15 && temp > -15)
    return false; //  Panic breaking
  else if (temp < 30 && temp > -30)
    return false; //  Mild accident
  else if (temp < 40 && temp > -40)
    return false; //  Severe accident
  else
    return false; //  Extreme conditions
}

class Event {
  double speed;
  double time;
  double latitude;
  double longitude;
}
