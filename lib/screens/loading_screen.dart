import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  
Position position;
  void initState(){
    super.initState();
    getLocation();
  }

  Future<Position> getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;
  double longitude;
  double latitude;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately. 
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
  latitude=position.latitude;
  longitude=position.longitude;
  print('Latitude: $latitude');
  print('Longitude: $longitude');
  return await Geolocator.getCurrentPosition();
  }

  void getData() async {
    http.Response response = await http.get(Uri.parse('https://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=b6907d829e10d714a6e88b30761fae22'));
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      // body: Center(
      //   child: TextButton(
      //     onPressed: () {
      //       //Get the current location
      //       getLocation();
      //       print(position);
      //     },
      //     child: Text('Get Location'),
      //   ),
      // ),
    );
  }
}
