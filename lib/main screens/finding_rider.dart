import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import '../models/active_nearby_available_drivers.dart';

class FindingRiderScreen extends StatefulWidget {
  const FindingRiderScreen({super.key});

  @override
  State<FindingRiderScreen> createState() => _FindingRiderScreenState();
}

class _FindingRiderScreenState extends State<FindingRiderScreen> {
  double bottomPaddingOfMap = 0;
  CameraPosition? _initialPosition;
  Position? userCurrentPosition;
  String userName = "your Name";
  String userEmail = "your Email";
  Set<Polyline> polyLineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            userCurrentPosition!, context);
    print("this is your address = " + humanReadableAddress);

    if (userModelCurrentInfo != null) {
      userName = userModelCurrentInfo!.name!;
      userEmail = userModelCurrentInfo!.email!;
    }

    setState(() {
      _initialPosition = cameraPosition;
    });
  }

  @override
  void initState() {
    locateUserPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<dynamic>(
          stream: FirebaseDatabase.instance
              .ref()
              .child("requestRides")
              .child(currentFirebaseUser!.uid)
              .onValue,
          builder: (context, snapshot) {
            return _initialPosition == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GoogleMap(
                    padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: true,
                    initialCameraPosition: _initialPosition!,
                    markers: Set.from(markersSet),
                    circles: circlesSet,
                    onMapCreated: (GoogleMapController controller) {
                      _controllerGoogleMap.complete(controller);
                      newGoogleMapController = controller;
                      // Future.delayed(const Duration(milliseconds: 200), () {
                      //   controller.animateCamera(CameraUpdate.newLatLngBounds(
                      //       MapUtils.boundsFromLatLngList(
                      //           markersSet.map((loc) => loc.position).toList()),
                      //       1));
                      // });
                      // blackThemeGoogleMap();

                      setState(() {
                        bottomPaddingOfMap = 240;
                      });
                    },
                  );
          }),
    );
  }
}
