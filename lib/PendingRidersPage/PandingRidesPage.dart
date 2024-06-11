import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vojo/Conatants/Constans.dart';

import '../EditTrip_page/EditTrip_page.dart';
import '../backend/backend.dart';

class PendingRidesPage extends StatefulWidget {
  const PendingRidesPage({super.key});

  @override
  State<PendingRidesPage> createState() => _PendingRidesPageState();
}

class _PendingRidesPageState extends State<PendingRidesPage> {
  final _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool IstherePendingRiders = false;


  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey.shade300
                      ),
                      child: Icon(Icons.arrow_back, color: Colors.black,),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(15, 10, 0, 5),
                      child: Text("Pending Trips", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, fontFamily: primaryFontFamilty),)),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection("temptrip")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // Use hasData instead of != null
                        final messages = snapshot.data!.docs;
                        List<Widget> rides = [];

                        for (var message in messages) {
                          final tripData = message.data() as Map<
                              String, dynamic>; // Explicit cast
                          //var messageText = messageData["end_date"];
                          //messagesList.add(Text('$messageText'));
                          String docId = message.id;

                          final tripCard = Container(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: const Color(0xFF311B92),
                                  width: 2.0,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey
                                        .withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                children: [
                                  ListTile(
                                    title: Text(
                                      "${tripData["start_location"]} to  ${tripData["end_location"]}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Padding(
                                      padding:
                                      const EdgeInsets.only(
                                          top: 8.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.person,
                                              size: 16.0),
                                          const SizedBox(
                                              width: 8.0),
                                          Text(
                                              "Booked a  ${tripData["travelling_Mode"]}"),
                                        ],
                                      ),
                                    ),
                                    trailing: AvatarGlow(
                                        glowColor:
                                        Color(0xFF311B92),
                                        child: Icon(
                                          Icons.circle,
                                          color: Color(0x1A311B92),
                                        )),
                                    //onTap: onTap,
                                  ),
                                  const SizedBox(height: 4.0),
                                  Container(
                                    margin:
                                    const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: TextButton(
                                      onPressed: () async {
                                        showPopup(context, docId);
                                        //RequestDeleteTrip(docId: docId);
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                        Color(0xFFFFFFFF),
                                        padding:
                                        const EdgeInsets.all(
                                            12.0),
                                        side: BorderSide(
                                          color: Color(0xFF311B92), // your color here
                                          width: 1,
                                        ),
                                        shape:
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              8.0),
                                        ),
                                      ),
                                      child: const Text(
                                        'Remove Booking',
                                        style: TextStyle(
                                            color:
                                            Color(0xFF311B92)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6.0),
                                ],
                              ),
                            ),
                          );
                          //print(category);
                          if (tripData["is_confirmed"] == false &&
                              (tripData['user_id'] ==
                                  _auth.currentUser?.uid) ) {
                            rides.add(tripCard);
                          }
                        }

                        return SingleChildScrollView(
                          child: Column(
                            children: rides,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        // Handle the error case
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
        ),
      ),
    );
  }
}


void showPopup(BuildContext context, documentId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Attention: Journey Deletion Confirmation'),
        content: Text('Are you sure you want to delete your journey? This action is irreversible and will require admin authorization for full deletion. Once authorized, your journey will be permanently deleted from our system.Additionally, please note that a refund will be processed within 7 working days from the date of deletion confirmation.'),
        actions: [
          TextButton(
            onPressed: ()async {
              RequestDeleteTrip(docId: documentId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added to Admin Approval'),
                  duration: Duration(seconds: 2), // Adjust the duration as needed
                  action: SnackBarAction(
                    label: 'OK',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    },
                  ),
                ),
              );
            },
            child: Text('OK'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}