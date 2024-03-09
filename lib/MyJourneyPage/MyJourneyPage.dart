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
  static late LatLng userpos;
  static late List<LatLng> requiredPossition = [];

  // making map is not visible when start
  late bool locationadd = false;

  // Add custom Icon - Not working
  BitmapDescriptor initailLocationIcon = BitmapDescriptor.defaultMarker;

  // Adding polyline coordinates
  List<LatLng> polylineCoordinates = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var currentUser;

  Future<void> getLocation() async {
    late LatLng newlocation;
    GeoCode geoCode = GeoCode(apiKey: "135158425259448e15921900x20274");
    for(String a in locations){
      try{
        Coordinates usercoordinate = await geoCode.forwardGeocoding(address: locations[1]);
        late LatLng pos = LatLng((usercoordinate.latitude)!.toDouble(), (usercoordinate.longitude)!.toDouble());
        requiredPossition.add(pos);
      }catch(e){
        print(e);
      }
    }

    try {
      Coordinates coordinates = await geoCode.forwardGeocoding(
          address: locations[1]);

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
  late Set<Marker> myMarkers ;
  Set<Marker> generateMarkers(List<LatLng> requiredPositions) {
    // Initialize a set for markers
    Set<Marker> markers = {};

    // Dynamically add markers based on requiredPositions
    for (LatLng position in requiredPositions) {
      markers.add(
        Marker(
          markerId: MarkerId(position.toString()), // Unique ID for each marker
          icon: BitmapDescriptor.defaultMarker,
          position: position,
        ),
      );
    }



    return markers;
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

  Widget getTravelModePicture({ required String travelMode})  {
    switch(travelMode){
      case "car":
        return Container(height: 100, width: 100, child: Image.asset("assets/images/car.png"));
        
      case "bike":
        return Container(height: 50, width: 50, child: Image.asset("assets/images/bike.png"));

      case "van":
        return Container(height: 50, width: 50, child: Image.asset("assets/images/van.png"));

      case "tuk":
        return Container(height: 50, width: 50, child: Image.asset("assets/images/tuk.png"));

      default:
        return Container(height: 50, width: 50, child: Image.asset("assets/images/car.png"));
    }
    return Text("");
  }
  List<String> locations = [];

  Future<void> getLocationData()async {
    final trips =  await _firestore.collection("temptrip").get();
    for(var trip in trips.docs){
      if(trip.data()["user_id"] == _auth.currentUser!.uid){
        locations.add("${trip.data()["start_location"]}");
        locations.add("${trip.data()["end_location"]}");
      }
    }
    for(String a in locations){
      print(a);
    }
  }

  // Initialized the state
  @override
  void initState() {
    super.initState();
    getPolyline();
    setCoustomMarkerIcon();
    getLocationData().then((value) => getLocation()).then((value) => generateMarkers(requiredPossition));
    //getLocation();


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
                            target: requiredPossition[0],
                            zoom: 8,
                          ),
                          zoomControlsEnabled: true,
                          markers: generateMarkers(requiredPossition),
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
                            stream: _firestore.collection("temptrip").snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final bookings = snapshot.data!.docs;
                                List<Widget> bookingWidgets = []; // List to store booking widgets
                                for (var booking in bookings) {
                                  final bookingData = booking.data() as Map<String, dynamic>;
                                  //String dateAndTime = (DateTime.parse(bookingData["start_date"].toDate().toString())).toString();
                                  //List<String> dateSplitted = dateAndTime.split(" ");
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
                                        getTravelModePicture(travelMode: "${bookingData["travelling_mode"]}"),
                                        SizedBox(height: 5,),
                                        Text("${bookingData["start_location"]} to ${bookingData["end_location"]}" ),
                                        SizedBox(height: 3,),
                                        Text("${bookingData["start_date"]}"),
                                        Text("to"),
                                        Text("${bookingData["end_date"]}"),
                                      ],
                                    ),
                                  );
                                  if(_auth.currentUser!.uid == bookingData["user_id"] && bookingData["is_confirmed"] == true){
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
