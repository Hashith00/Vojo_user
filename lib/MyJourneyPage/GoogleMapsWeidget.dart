import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';

class GoogleMapsWeidget extends StatefulWidget {
  const GoogleMapsWeidget({super.key});

  @override
  State<GoogleMapsWeidget> createState() => _GoogleMapsWeidgetState();
}

class _GoogleMapsWeidgetState extends State<GoogleMapsWeidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: GoogleMapsWidget(
            apiKey: "AIzaSyC8XOXvvxImxyxY6dFnOKIMTlbOM3X58Yw",
            sourceLatLng: LatLng(40.484000837597925, -3.369978368282318),
            destinationLatLng: LatLng(40.48017307700204, -3.3618026599287987),
            routeWidth: 3,
            sourceMarkerIconInfo: MarkerIconInfo(
              assetPath: "assets/images/car.png",
            ),
            

          ),
        ),
      ),
    );
  }
}
