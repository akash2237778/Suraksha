import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewUser extends StatefulWidget {
  final String beaconKey;

  ViewUser({Key key, this.beaconKey}) : super(key: key);

  @override
  _ViewUserState createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.528973, 77.3304438),
    zoom: 18.4746,
  );

  DatabaseReference _location_firebase;
  String lat;
  String long;
  bool isSafe = true;
  double speedFromOBD = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final FirebaseDatabase database = FirebaseDatabase();
    _location_firebase =
        database.reference().child('userLocation/' + widget.beaconKey);

    _location_firebase.onValue.listen((event) {
      setState(() {
        var _counter = event.snapshot.value ?? 0;

        _add(_counter['lat'].toString(), _counter['long'].toString(), "");

        lat = _counter['lat'].toString();
        long = _counter['long'].toString();
        isSafe = _counter['isSafe'];
        speedFromOBD = double.parse(_counter['speed']);
        //log("View Beacon pressed " + _counter['lat'].toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _launchMapsUrl(double.parse(lat), double.parse(long));
              },
              backgroundColor: Colors.yellow,
              child: Icon(Icons.directions),
            ),
            appBar: AppBar(
              title: Text(
                'User\'s Location',
                style: TextStyle(fontSize: 15),
              ),
            ),
            body: SafeArea(
                child: Container(
                    child: Stack(children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: Set<Marker>.of(markers.values),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: isSafe ? Colors.blue : Colors.red,
                  //height: 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Latitude : $lat',
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        Text('Latitude : $long',
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        Text('isSafe : $isSafe',
                            style:
                                TextStyle(fontSize: 15, color: Colors.white)),
                        Container(
                            height: 250,
                            child: SfRadialGauge(
                                title: GaugeTitle(
                                    text: 'Speed',
                                    textStyle: const TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.bold)),
                                axes: <RadialAxis>[
                                  RadialAxis(
                                      minimum: 0,
                                      maximum: 150,
                                      ranges: <GaugeRange>[
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
                                      ],
                                      pointers: <GaugePointer>[
                                        NeedlePointer(
                                          value: speedFromOBD,
                                          enableAnimation: true,
                                        )
                                      ],
                                      annotations: <GaugeAnnotation>[
                                        GaugeAnnotation(
                                            widget: Container(
                                                child: Text(
                                                    speedFromOBD
                                                        .toInt()
                                                        .toString()
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            angle: 90,
                                            positionFactor: 0.5)
                                      ])
                                ])),
                      ],
                    ),
                  ),
                ),
              )
            ])))));
  }

  void _add(String latitude, String longitude, var markerIdVal) {
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        double.parse(latitude),
        double.parse(longitude),
      ),
      infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      onTap: () {
        // _onMarkerTapped(markerId);
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
