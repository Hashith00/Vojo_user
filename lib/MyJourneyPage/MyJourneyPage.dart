import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:geocode/geocode.dart';
import 'package:vojo/Conatants/Constans.dart';
import 'package:vojo/MyJourneyPage/SingleHotelDetailsPage.dart';
import 'package:vojo/MyJourneyPage/SingleTripMapPage.dart';
import 'package:vojo/PickHotelOrRoderPage/PickHotelOrRiderPage.dart';

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
              child: Container(
               color: Colors.grey.shade100,
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
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 20, 20, 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Icon(Icons.remove, color: Colors.black,),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white
                                    ),
                                    height: 40,
                                    width: 40,
                                  ),
                                  Container(
                                    child: Icon(Icons.search_off_sharp, color: Colors.black,),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white
                                    ),
                                    height: 40,
                                    width: 40,
                                  )
                                ],
                              )
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 20, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Unlocking ", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w400, fontFamily: primaryFontFamilty)),
                                  Text("Luxury with Vojo ", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w400, fontFamily: primaryFontFamilty)),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Your Hotels", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, fontFamily: primaryFontFamilty),),
                                  Container(
                                    child: GestureDetector(
                                        child: Icon(Icons.arrow_circle_up_rounded),
                                      onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => PickHotelOrRider()));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                                    final bookingWidget = HotelBookingCard(bookingData: bookingData, booking: booking, dateSplitted: dateSplitted);
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
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 20, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Your Rides", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, fontFamily: primaryFontFamilty),),
                                  Container(
                                    child: GestureDetector(
                                        child: Icon(Icons.arrow_circle_up_rounded),
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => PickHotelOrRider()));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                                    final bookingWidget = RiderCard(bookingData: bookingData);
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
            ),
          )
      )
    );
  }
}

class RiderCard extends StatelessWidget {
  const RiderCard({
    super.key,
    required this.bookingData,
  });

  final Map<String, dynamic> bookingData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SingleTripMapPage(startLat: bookingData["startLocationLatitude"], startLng: bookingData["startLocationLongitude"], endLat: bookingData["endLocationLatitude"], endLng: bookingData["endLocationLongitude"], distance: bookingData["distance"],cost: bookingData["cost"],duration: bookingData["duration"],)));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        height: 280,
        width: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white
        ),
        margin: EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(image: NetworkImage("https://t3.ftcdn.net/jpg/04/49/73/64/360_F_449736488_IAGo58o7DloC8Os5S5v9vppX3BIxzK4S.jpg"),
              ),
            ),
            SizedBox(height: 10,),
            Row(

              children: [
                Text("${bookingData["start_location"]} ", style: TextStyle(fontSize: 22, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500)),
                SizedBox(width: 40,),
                Icon(Icons.arrow_forward, color: Colors.black12,),
                SizedBox(width: 40,),
                Text("${bookingData["end_location"]}", style: TextStyle(fontSize: 22, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500)),
                //getTravelModePicture(travelMode: "${bookingData["travelling_mode"]}"),
              ],
            ),

            SizedBox(height: 5,),
            Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.red,),
                SizedBox(width: 10,),
                Text("${bookingData["start_date"]}"),
              ],
            ),
            // Text("${bookingData["end_date"]}"),
          ],
        ),
      ),
    );
  }
}

class HotelBookingCard extends StatelessWidget {
  const HotelBookingCard({
    super.key,
    required this.bookingData,
    required this.booking,
    required this.dateSplitted,
  });

  final Map<String, dynamic> bookingData;
  final QueryDocumentSnapshot<Object?> booking;
  final List<String> dateSplitted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      Navigator.push(context, MaterialPageRoute(builder: (context) => SingleHotelDetailsPage(latitude: bookingData["hotelLat"], longitude: bookingData["hotelLng"], hotelName: bookingData["hotel"], hotelDocId: booking.id)));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        height: 280,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white
        ),
        margin: EdgeInsets.only(right: 35, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image(image: NetworkImage("https://images.unsplash.com/photo-1625244724120-1fd1d34d00f6?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aG90ZWxzfGVufDB8fDB8fHww"),
              ),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${bookingData["hotel"]}", style: TextStyle(fontSize: 22, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500),),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white70,
                  ),

                  height: 30,
                  width: 50,
                  child: Center(child: Text("Booked", style: TextStyle(color: primaryColor, fontSize: 10),),),
                )
              ],
            ),
            SizedBox(height: 3,),
            Row(
              children: [
                Icon(Icons.calendar_month, color: Colors.red,),
                SizedBox(width: 10,),
                Text("${dateSplitted[0]}")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
