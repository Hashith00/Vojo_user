

import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:dio/dio.dart';

class SingleTripMapPage extends StatefulWidget {
  final String duration;
  final int cost;
  final double distance;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  const SingleTripMapPage({super.key, required this.startLat, required this.startLng, required this.endLat, required this.endLng, required this.distance, required this.cost, required this.duration});

  @override
  State<SingleTripMapPage> createState() => _SingleTripMapPageState();
}


class _SingleTripMapPageState extends State<SingleTripMapPage> {
  var distanceOfTrip;

@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 500,
                child: GoogleMapsWidget(
                  apiKey: "AIzaSyC8XOXvvxImxyxY6dFnOKIMTlbOM3X58Yw",
                  sourceLatLng: LatLng(widget.startLat, widget.startLng),
                  destinationLatLng: LatLng(widget.endLat, widget.endLng),
                  routeWidth: 3,
                  sourceMarkerIconInfo: MarkerIconInfo(
                    assetPath: "assets/images/car.png",
                  ),


                ),
              ),
              Column(
                children: [
                 Text("Cost : ${widget.cost}"),
                  Text("Distance : ${widget.distance}"),
                  Text("Duration : ${widget.duration}"),

                ],

              ),
              Container(

              )
            ],

          ),
        ),
      ),
    );
  }
}
