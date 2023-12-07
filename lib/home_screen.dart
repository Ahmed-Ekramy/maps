import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeSCREEN extends StatefulWidget {
  HomeSCREEN({Key? key}) : super(key: key);

  @override
  State<HomeSCREEN> createState() => _HomeSCREENState();
}

class _HomeSCREENState extends State<HomeSCREEN> {
  var locationManger = Location();

  @override
  void initState() {
    super.initState();
    requestService();
    requestPermission();
    getUserLocation();
    trackUserLocation();
  }

  var meetAsas = const CameraPosition(
    target: LatLng(30.996729, 31.293697),
    zoom: 16,
  );
  Set<Marker> markerSet = {
    const Marker(
        markerId: MarkerId("Meet Asas"),
        position: LatLng(30.996729, 31.293697))
  };
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Maps"), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              markers: markerSet,
              mapType: MapType.normal,
              initialCameraPosition: meetAsas,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
                drawUserMarker();
              },
            ),
          ),
          ElevatedButton(onPressed: () {
            trackUserLocation();
          }, child: const Text("Start Tracking"))
        ],
      ),
    );
  }

  void drawUserMarker() async {
    var canGetLocation = await canUseGPS();
    if (!canGetLocation) return;
    var locationData = await locationManger.getLocation();
    _controller?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0), 16));
    markerSet.add(Marker(
      markerId: const MarkerId("user-marker"),
      position: LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0),
    ));
    setState(() {

    });
  }

  void getUserLocation() async {
    var canGetLocation = await canUseGPS();
    if (!canGetLocation) return;
    var locationData = await locationManger.getLocation();
    print(locationData.altitude);
    print(locationData.longitude);
  }

  StreamSubscription<LocationData>? trackServices = null;

  void trackUserLocation() async {
    var canGetLocation = await canUseGPS();
    if (!canGetLocation) return;
    locationManger.changeSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2000,
      interval: 10,
    );
    trackServices = locationManger.onLocationChanged.listen((locationData) {
      print(locationData.longitude);
      print(locationData.latitude);
      markerSet.add(Marker(
        markerId: const MarkerId("user-marker"),
        position: LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0),
      ));
      _controller?.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(locationData.latitude ?? 0, locationData.longitude ?? 0), 16));
      setState(() {

      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    trackServices?.cancel();
  }

  Future<bool> canUseGPS() async {
    var permissionGranted = await isPermissionGranted();
    if (!permissionGranted) {
      return false;
    }
    var locationServiceEnable = await isLocationServiceEnable();
    if (!locationServiceEnable) {
      return false;
    }
    return true;
  }

  Future<bool> isLocationServiceEnable() async {
    return await locationManger.serviceEnabled();
  }

  Future<bool> requestService() async {
    var enable = await locationManger.requestService();
    return enable;
  }

  Future<bool> isPermissionGranted() async {
    var permissionStatus = await locationManger.hasPermission();
    return permissionStatus == PermissionStatus.granted;
  }

  Future<bool> requestPermission() async {
    var permissionStatus = await locationManger.requestPermission();
    return permissionStatus == PermissionStatus.granted;
  }
}
