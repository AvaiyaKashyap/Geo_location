import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  //LocationData? currentLocation;

  late String lat;
  late String long;
  late var lat2;
  late var long2;

  @override
  void initState() {
    liveLocation();
    //getCurrentLocation();
    // getCurrentLocation().then((value) {
    //   lat = '${value.latitude}';
    //   long = '${value.longitude}';
    //   print(lat);
    //   print(long);
    // });
    addCusTomIcon();
    super.initState();
  }

    void liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
          lat = position.latitude.toString();
          long = position.longitude.toString();
          setState(() {
            long2 = num.tryParse(long)?.toDouble();
            lat2 = num.tryParse(lat)?.toDouble();
          });
          print(long2);
          print(lat2);
    });
    }

    Future<Position> getCurrentLocation() async {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if(!serviceEnabled){
        return Future.error('Location services are disabled');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if(permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.denied) {
          return Future.error('Location permission are denied');
        }
      }
      if(permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied, we cannot request permission');
      }

      return await Geolocator.getCurrentPosition();
    }
  // void getCurrentLocation() {
  //   Location location = Location();
  //   location.getLocation().then((location) {
  //     currentLocation = location;
  //   });
  // }

  void addCusTomIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(), "assets/location_marker.png")
        .then((icon) {
      setState(() {
        markerIcon = icon;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat2,long2),
                zoom: 15,
              ),
              markers: {
                Marker(
                    markerId: MarkerId("My Location"),
                    position: LatLng(lat2,long2),
                    // draggable: true,
                    // onDragEnd: (value) {
                    //   print(value);
                    // },
                    icon: markerIcon),
              },
            ),
    );
  }
}
