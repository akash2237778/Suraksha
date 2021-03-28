import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

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
    target: LatLng(28.3514345, 77.3304405),
    zoom: 18.4746,
  );

  DatabaseReference _location_firebase;

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

        //log("View Beacon pressed " + _counter['lat'].toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
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
}
