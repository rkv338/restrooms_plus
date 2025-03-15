import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  bool _isLoading = true;
  StreamSubscription<Position>? _locationStream;
  late LatLng _center;
  Position? currPos;
  @override
  void initState() {
    super.initState();
    getLocation();
  }
  @override
  void dispose() {
    _locationStream?.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    // Position position = await Future.any([
    //   Geolocator.getCurrentPosition(
    //       desiredAccuracy: LocationAccuracy.high),
    //   Future.delayed(Duration(seconds: 5), () => Position(latitude: 0, longitude: 0)),
    // ]);
    // if (position == null) {
     Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    // }
    // _locationStream = Geolocator.getPositionStream().listen((p) {
    //   setState(() {
    //     _isLoading = false;
    //     currPos = p;
    //     _center = LatLng(currPos!.latitude, currPos!.longitude);
    //     mapController.animateCamera(
    //       CameraUpdate.newCameraPosition(
    //         CameraPosition(
    //           target: _center,
    //           zoom: 16,
    //         )
    //       )
    //     );
    //   });
    // });
    double lat = position.latitude;
    double long = position.longitude;

    LatLng location = LatLng(lat, long);

    setState(() {
      _center = location;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Restroom Reviewer'),
          elevation: 2,
        ),
        body: _isLoading ?
        Center(child:CircularProgressIndicator()): GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.0,
          ),
          markers: {
            Marker(
              markerId: const MarkerId('Current Location'),
              position: _center,
            )
          }

        ),
      ),
    );
  }
}
