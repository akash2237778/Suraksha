
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:suraksha/Services/notification.dart';
import 'package:suraksha/Views/ShareLocationView.dart';
import 'package:suraksha/Widgets/dart/Widgets.dart';

import 'JoinUser.dart';
import 'Login.dart';
import 'ViewUser.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState() {

    super.initState();
  }

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
                            child: currentUser != null
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



                            startButton(false, context, 'Start Track', (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> ShareLocationView(passKey: FirebaseAuth.instance.currentUser.uid,)));
                            }),
                            startButton(false, context, 'View User', (){ Navigator.push(context, MaterialPageRoute(builder: (context)=> JoinUser()));
                            }),
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

