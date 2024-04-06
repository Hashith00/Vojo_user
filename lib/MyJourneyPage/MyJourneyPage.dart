import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:geocode/geocode.dart';
import 'package:vojo/MyJourneyPage/SingleTripMapPage.dart';

class MyJourneyPage extends StatefulWidget {
  const MyJourneyPage({super.key});

  @override
  State<MyJourneyPage> createState() => _MyJourneyPageState();
}

class _MyJourneyPageState extends State<MyJourneyPage> {


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var currentUser;



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



  // Initialized the state
  @override
  void initState() {
    super.initState();

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
                                  final bookingWidget = GestureDetector(
                                    onTap: (){


                                    },
                                    child: Container(
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
                                  final bookingWidget = GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleTripMapPage(startLat: bookingData["startLocationLatitude"], startLng: bookingData["startLocationLongitude"], endLat: bookingData["endLocationLatitude"], endLng: bookingData["endLocationLongitude"], distance: bookingData["distance"],cost: bookingData["cost"],duration: bookingData["duration"],)));
                                    },
                                    child: Container(
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
