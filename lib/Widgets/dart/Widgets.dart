
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:suraksha/Views/Homepage.dart';
import 'package:suraksha/Views/Login.dart';

Container userStat(String attribute, String value, {String unit}) {
  return Container(
      margin: EdgeInsets.all(8),
      child: Neumorphic(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Row(
                    children: [
                      Text(
                        value,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      unit == null
                          ? Container()
                          : Text(
                        ' ' + unit,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  attribute,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          style: NeumorphicStyle(
              border: NeumorphicBorder(
                color: Colors.blue,
                width: 1,
              ),
              depth: 20,
              intensity: 0.5,
              lightSource: LightSource.topLeft,
              shape: NeumorphicShape.convex)));
}

Widget toggleButton(
    IconData icon, String text, bool isToggled, Function onPress) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      NeumorphicButton(
        provideHapticFeedback: true,
        onPressed: onPress,
        style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.circle(),
            depth: 10,
            lightSource: LightSource.topLeft,
            color: isToggled ? Colors.blueAccent : Colors.redAccent),
        child: Icon(
          icon,
          size: 30,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(text),
      )
    ],
  );
}

Widget longButton(String head, String description, IconData icon) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
    child: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            depth: 10,
            lightSource: LightSource.topLeft,
            color: Colors.white70),
        child: Row(
          children: [
            Container(
              color: Colors.blue,
              child: Icon(
                icon,
                size: 45,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(head,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(description,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 35,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ],
        )),
  );
}

Widget startButton(bool isDisabled) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15.0),
    child: NeumorphicButton(
      onPressed: () {},
      style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
          shape: NeumorphicShape.concave,
          depth: isDisabled ? -10 : 10,
          lightSource: LightSource.topLeft,
          color: isDisabled ? Colors.grey : Colors.blue),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Text(
          'Start Track',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ),
  );
}

Widget listTile(String type, var properties) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
    child: Neumorphic(
      style: NeumorphicStyle(
        color: Colors.white30,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
        child: Row(
          children: [
            type == "car"
                ? Image(
                height: 50,
                image: NetworkImage(
                    'https://www.freeiconspng.com/thumbs/car-icon-png/car-icon-png-25.png'))
                : Icon(Icons.no_cell),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    properties['model'],
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Manufacturer:  ' + properties['manufacturer'],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Id:  ' + properties['id'],
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Construction Year: ' +
                        properties['constructionYear'].toString(),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'Fuel Type: ' + properties['fuelType'].toString(),
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget navIcons(String text, IconData iconData, bool isSelected) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        iconData,
        size: isSelected ? 35 : 30,
        color: isSelected ? Colors.white : Colors.black,
      ),
      Text(
        text,
        style: TextStyle(
            fontSize: 12, color: isSelected ? Colors.white : Colors.black),
      )
    ],
  );
}

Widget homeAppBar(BuildContext context) {
  return AppBar(
    actions: [
      ValueListenableBuilder(
          valueListenable: userLoginAct,
          builder: (context, value, widget) {
            return GestureDetector(
              onTap: () {
                if (currentUser == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                } else {
                  currentUser = null;
                  userLoginAct.value = currentUser;
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(currentUser == null ? Icons.login : Icons.logout),
              ),
            );
          })
    ],
    backgroundColor: Colors.blue,
    shadowColor: Colors.blue,
    elevation: 0,
    title: Center(
        child: Image(
            height: 45,
            image: NetworkImage(
                'https://envirocar.org/assets/logo_white.png')) //Text('enviroCar', style: TextStyle(fontSize: 35)),
    ),
  );
}

Widget bottomNavigationBar(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.blue,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
      border: Border.all(
        width: 0,
        color: Colors.green,
        style: BorderStyle.solid,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: navIcons('DashBoard', Icons.speed, true),
        ),
        GestureDetector(
          onTap: () {},
          child: navIcons('My Tracks', Icons.explore, false),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          child: navIcons('Others', Icons.more_horiz, false),
        ),
      ],
    ),
  );
}
