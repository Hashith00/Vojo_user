import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:geocode/geocode.dart';

class MyJourneyPage extends StatefulWidget {
  const MyJourneyPage({super.key});

  @override
  State<MyJourneyPage> createState() => _MyJourneyPageState();
}

class _MyJourneyPageState extends State<MyJourneyPage> {

  // Add the Specific Lognitude and latitiude
  static const LatLng initialPos = LatLng(-25.35042, -49.18715);
  static const LatLng finalPoint = LatLng(37.33429383, -122.06600055);
  static const LatLng KandyPoint = LatLng(7.2915, 80.63051);
  static late LatLng userpos = LatLng(7.0854, 79.99405);

  // making map is not visible when start
  late bool locationadd = false;

  // Add custom Icon - Not working
  BitmapDescriptor initailLocationIcon = BitmapDescriptor.defaultMarker;

  // Adding polyline corrdinates
  List<LatLng> polylineCoordinates = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> getLocation() async {
    late LatLng newlocation;
    GeoCode geoCode = GeoCode(apiKey: "135158425259448e15921900x20274");

    try {
      Coordinates coordinates = await geoCode.forwardGeocoding(
          address: "Gampaha");

      setState(() {
        userpos = LatLng((coordinates.latitude)!.toDouble(), (coordinates.longitude)!.toDouble());
      });

      print("Latitude: ${userpos.latitude}");
      print("Longitude: ${userpos.longitude}");
    } catch (e) {
      print(e);
    }
    setState(() {
      locationadd = true;
    });

  }

  void setCoustomMarkerIcon(){
    BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), "images/hs.jpeg")
        .then(
          (icon) {
        setState(() {
          initailLocationIcon = icon;
          print(initailLocationIcon == BitmapDescriptor.defaultMarker);
        });
      },
    );
  }


  void getPolyline() async {
    final googleApiKey = "AIzaSyBDN7sI0dPanW0CqV374hRLQB7WdzVk50s"; // Ensure this is securely stored
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(initialPos.latitude, initialPos.longitude),
        PointLatLng(finalPoint.latitude, finalPoint.longitude));

    if (result.points.isNotEmpty) {
      setState(() {
        polylineCoordinates = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
      });
    }
    //print(polylineCoordinates.length);
  }

  // Initialized the state
  @override
  void initState() {
    super.initState();
    getPolyline();
    setCoustomMarkerIcon();
    getLocation();


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
                      width: double.infinity,
                      height: 500,
                      child: locationadd ?
                      Container(
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: userpos,
                            zoom: 9,
                          ),
                          zoomControlsEnabled: true,
                          markers: {
                            Marker(
                                markerId: MarkerId('initialPos'),
                                icon: BitmapDescriptor.defaultMarker,
                                position: userpos),
                            Marker(
                                markerId: MarkerId('finalPoint'),
                                icon: BitmapDescriptor.defaultMarker,
                                position: KandyPoint),
                          },
                          polylines: {
                            Polyline(
                              polylineId: PolylineId('route'),
                              points: polylineCoordinates,
                              color: Colors.blue, // Specify the polyline color
                              width: 5, // Specify the polyline width
                            ),
                          },
                        ),
                      ):
                      Container(
                        child: Text("Loading"),
                      )
                  ),
                  const SizedBox(height: 20,),
                   Container(
                     margin: EdgeInsets.only(left: 10),
                     child: SingleChildScrollView(
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Your Hotels", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                          StreamBuilder<QuerySnapshot>(
                            stream: _firestore.collection("bookings").snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final bookings = snapshot.data!.docs;
                                List<Widget> bookingWidgets = []; // List to store booking widgets
                                for (var booking in bookings) {
                                  final bookingData = booking.data() as Map<String, dynamic>;
                                  String dateAndTime = (DateTime.parse(bookingData["start_date"].toDate().toString())).toString();
                                  List<String> dateSplitted = dateAndTime.split(" ");
                                  final bookingWidget = Container(
                                    padding: EdgeInsets.all(8),
                                    height: 210,
                                    width: 180,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.shade300
                                    ),
                                    margin: EdgeInsets.only(right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image(image: NetworkImage("https://images.unsplash.com/photo-1625244724120-1fd1d34d00f6?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aG90ZWxzfGVufDB8fDB8fHww")),
                                        SizedBox(height: 5,),
                                        Text("${bookingData["hotel"]}"),
                                        SizedBox(height: 3,),
                                        Text("${dateSplitted[0]}"),
                                        Text("to"),
                                        Text("${dateSplitted[0]}"),
                                      ],
                                    ),
                                  );
                                  if(_auth.currentUser!.uid == bookingData["user_id"]){
                                    bookingWidgets.add(bookingWidget);
                                  }
                                  // Add the container to the list
                                }
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: bookingWidgets, // Display all booking containers
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else {
                                return CircularProgressIndicator(); // Show a loading indicator
                              }
                            },
                          ),

                          SizedBox(height: 20,),
                          Text("Your Rides", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                          StreamBuilder<QuerySnapshot>(
                            stream: _firestore.collection("bookings").snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final bookings = snapshot.data!.docs;
                                List<Widget> bookingWidgets = []; // List to store booking widgets
                                for (var booking in bookings) {
                                  final bookingData = booking.data() as Map<String, dynamic>;
                                  String dateAndTime = (DateTime.parse(bookingData["start_date"].toDate().toString())).toString();
                                  List<String> dateSplitted = dateAndTime.split(" ");
                                  final bookingWidget = Container(
                                    padding: EdgeInsets.all(8),
                                    height: 210,
                                    width: 180,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.grey.shade300
                                    ),
                                    margin: EdgeInsets.only(right: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Image(image: NetworkImage("https://images.unsplash.com/photo-1625244724120-1fd1d34d00f6?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aG90ZWxzfGVufDB8fDB8fHww")),
                                        SizedBox(height: 5,),
                                        Text("${bookingData["hotel"]}"),
                                        SizedBox(height: 3,),
                                        Text("${dateSplitted[0]}"),
                                        Text("to"),
                                        Text("${dateSplitted[0]}"),
                                      ],
                                    ),
                                  );
                                  bookingWidgets.add(bookingWidget); // Add the container to the list
                                }
                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: bookingWidgets, // Display all booking containers
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              } else {
                                return CircularProgressIndicator(); // Show a loading indicator
                              }
                            },
                          ),

                        ],

                  ),
                     ),
                   ),

                ],
              ),
            ),
          )
      )
    );
  }
}
