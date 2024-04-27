

import 'package:flutter/material.dart';
import 'package:google_maps_widget/google_maps_widget.dart';
import 'package:dio/dio.dart';
import 'package:vojo/Conatants/Constans.dart';

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
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  height: 400,
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
                SizedBox(height: 25,),
                Container(
                  width: double.infinity,
                  height: 200,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Trip Details ", style: TextStyle(fontSize: 21, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w700),),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Distance ", style: TextStyle(fontSize: 17, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500),),
                          Text("${widget.distance}", style: TextStyle(fontSize: 15, fontFamily: primaryFontFamilty, color: Colors.grey),),

                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Trip Time", style: TextStyle(fontSize: 17, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500),),
                          Text("${widget.duration}", style: TextStyle(fontSize: 15, fontFamily: primaryFontFamilty, color: Colors.grey),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Cost", style: TextStyle(fontSize: 17, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500),),
                          Text("${widget.cost } USD", style: TextStyle(fontSize: 15, fontFamily: primaryFontFamilty, color: Colors.grey),),
                        ],
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryColor
                    ),
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Center(
                      child: Text("Back", style: TextStyle(fontFamily: primaryFontFamilty, color: Colors.white),),
                    ),
                  ),
                )
              ],

            ),
          ),
        ),
      ),
    );
  }
}
