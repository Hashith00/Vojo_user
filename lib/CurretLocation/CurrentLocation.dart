import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CurrentLocation extends StatefulWidget {
  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
   var _currentPosition;
   var _loading = true;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
  requestLocationPermission();
  _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Skeletonizer(
        enabled: _loading,
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "LAT: ${_currentPosition?.latitude}, LNG: ${_currentPosition?.longitude}"
              ),
                TextButton(
                  child: Text("Get location"),
                  onPressed: () {
                    _getCurrentLocation();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getCurrentLocation() {
    Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _loading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }
}

void requestLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    // Permissions are denied or denied forever, let's request it!
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Location permissions are still denied");
    } else if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied");
    } else {
      // Permissions are granted (either can be whileInUse, always, restricted).
      print("Location permissions are granted after requesting");
    }
  }
}