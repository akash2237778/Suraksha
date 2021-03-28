
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:suraksha/Widgets/dart/Widgets.dart';

import 'Login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPress1 = true;
  bool isPress2 = true;
  bool isPress3 = true;
  bool isPress4 = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: homeAppBar(context),
        // backgroundColor: Colors.blue,
        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    border: Border.all(
                      width: 0,
                      color: Colors.green,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        maxRadius: 60,
                        minRadius: 50,
                        backgroundImage: NetworkImage(
                            'https://www.vhv.rs/dpng/d/426-4263064_circle-avatar-png-picture-circle-avatar-image-png.png'),
                      ),
                      ValueListenableBuilder(
                        valueListenable: userLoginAct,
                        builder: (context, value, widget) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: FirebaseAuth.instance.currentUser != null
                                ? Text(
                              currentUser.name,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 20),
                            )
                                : Container(),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          userStat('Total Tracks', '00'),
                          userStat('Total Distance', '0', unit: 'km'),
                          userStat('Total Duration', '00:00', unit: 'h'),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  color: Colors.black,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10),
                                  child: Text(
                                    'Recording Settings',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                toggleButton(Icons.bluetooth, 'Bluetooth', isPress1,
                                        () {
                                      setState(() {
                                        isPress1 = !isPress1;
                                      });
                                    }),
                                toggleButton(
                                    Icons.mobile_friendly, 'OBD', !isPress2, () {
                                  setState(() {
                                    isPress2 = !isPress2;
                                  });
                                }),
                                toggleButton(Icons.gps_fixed, 'GPS', isPress3, () {
                                  setState(() {
                                    isPress3 = !isPress3;
                                  });
                                }),
                                toggleButton(Icons.car_rental, 'Car', !isPress4,
                                        () {
                                      setState(() {
                                        isPress4 = !isPress4;
                                      });
                                    }),
                              ],
                            ),
                            longButton(
                                'No OBD-II adapter selected',
                                'click here to select one',
                                Icons.bluetooth_connected),
                            longButton('Renault Duster', '2014, 898 , Diesel',
                                Icons.car_repair),
                            startButton(false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar(context)
              ],
            )),
      ),
    );
  }
}

