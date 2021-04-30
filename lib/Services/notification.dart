

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:http/http.dart' as http;

import 'FirebaseFunctions.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

FlutterLocalNotificationsPlugin fltNotification;

Future<void> initialize() async {


  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  print(await messaging.getToken());

  initMessaging();
  //await messaging.subscribeToTopic('notify');
}

void initMessaging() {
  var androiInit = AndroidInitializationSettings('ic_launcher');

  var iosInit = IOSInitializationSettings();

  var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

  fltNotification = FlutterLocalNotificationsPlugin();

  fltNotification.initialize(initSetting);

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');
  //
  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification.title}');
  //   }
  // });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("message  : "+message.messageId);
    showNotification(message.notification.title, message.notification.body);
  });
}

void showNotification(String title, String body) async {
  var androidDetails =
  AndroidNotificationDetails('1', 'channelName', 'channel Description');

  var iosDetails = IOSNotificationDetails();

  var generalNotificationDetails =
  NotificationDetails(android: androidDetails, iOS: iosDetails);

  await fltNotification.show(0, title, body, generalNotificationDetails,
      payload: 'Notification');
}

void notitficationPermission() async {
 await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
}


void setFCMToken(String uid)async{

  String token = await messaging.getToken();

    await Firebase.initializeApp();

        setValue("FCMToken", uid, {"token": token} , FirebaseFirestore.instance);


    }



class Notifications{




  //var userToken = "djF7ptx6T368QTvfbM-ARP:APA91bHo2wRBnKlH2gkLsDnu9sPjKNhLPM-4LwkLvWJt26jwqz48L3Hg964jSYgnRBeVSrMQRqqJGid91I65TPQaQYkXA8DCgX-MLOYZdvsIhCukdTfc_1FPF-Gx6HgPcw4s55dqPp1o";

  Future<bool> callOnFcmApiSendPushNotifications(List <String> userToken , String sendBy , String mess) async {



    final postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "registration_ids" : userToken,
      "collapse_key" : "type_a",
      "notification" : {
        "title": sendBy,
        "body" : mess,
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': "key=AAAAAjpMZn0:APA91bE2LiwoRFKAc3WXimpMQ-6cuhuGC63DizIV2JN_5hpXmMwviFSdtjrtPgObFFRG-73jlRBHbgQkNpPceDiBw9BMkNMf5GmZCiCbHLwn1XvObKHro5WG_UX62yJzAkXPjPnEqral"// 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }
}

void sendAlert(String name, String message) async{

  String uid = FirebaseAuth.instance.currentUser.uid;

  print(uid);
  var db= FirebaseFirestore.instance.collection("FCMToken");
//  var db= FirebaseFirestore.instance.doc("FCMToken/$uid");


  var snap = db.doc(uid).snapshots();
  snap.first.then((value){
    print(value.get('token').toString() + "    : val");

    Notifications().callOnFcmApiSendPushNotifications([value.get('token').toString() ], name, message);

  });



}