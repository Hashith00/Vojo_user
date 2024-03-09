import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vojo/StateManagment/StateManagment.dart';
import 'package:vojo/index.dart';
import 'package:vojo/rider_details_page/rider_details_page.dart';
import 'package:provider/provider.dart';

class RidersListPage extends StatefulWidget {


  @override
  State<RidersListPage> createState() => _RidersListPageState();
}

class _RidersListPageState extends State<RidersListPage> {

  var category;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getvehicletype ()async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      //print("${prefs.getString('transportMode')} is the transpotation mode");
      category = prefs.getString('transportMode');
    }
    getvehicletype();



  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RiderDetailsProvider())
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF311B92),
          title: const Text('Select a Rider'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          elevation: 5.0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Text(
                    'Available Vehicles for Ride',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '5 vehicles found',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection("vehicles").snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) { // Use hasData instead of != null
                          final messages = snapshot.data!.docs;
                          List<Text> messagesList = []; // Use camelCase for variable names
                          List<Widget> card = [];

                          for (var message in messages) {
                            final messageData = message.data() as Map<String, dynamic>; // Explicit cast
                            var messageText = messageData["end_date"];
                            //messagesList.add(Text('$messageText'));

                            final carCard = Container(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                    color: const Color(0xFF311B92),
                                    width: 2.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    ListTile(
                                      title: Text(
                                        "${messageData["brand"]} ${messageData["model"]}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.person, size: 16.0),
                                            const SizedBox(width: 8.0),
                                            Text("Maximum Passengers ; ${messageData["max_passenger"]}"),
                                          ],
                                        ),
                                      ),
                                      trailing: Icon(Icons.abc),
                                      //onTap: onTap,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => RidersBookingPage(vehicleDeatils: messageData),
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: const Color(0xFF311B92),
                                          padding: const EdgeInsets.all(12.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: const Text(
                                          'View',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                  ],
                                ),
                              ),
                            );
                              print(category);
                            if(messageData["categoty"] == "$category"){
                              card.add(carCard);
                            }

                          }


                          return SingleChildScrollView(
                            child: Column(
                              children: card,
                            ),
                          );
                        } else if (snapshot.hasError) { // Handle the error case
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return CircularProgressIndicator(); // Show a loading indicator
                        }
                      },
                    ),
                  ],
                ),
              )
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 16.0),
              child: TextButton(
                onPressed: () {

                  Provider.of<RiderDetailsProvider>(context, listen: false).changeStartLocation(start: "");
                  Provider.of<RiderDetailsProvider>(context, listen: false).chageEndLocation(end: "");
                  Provider.of<RiderDetailsProvider>(context, listen: false).changeIntermediateLocation(midLocation: "");
                  Provider.of<RiderDetailsProvider>(context, listen: false).changeStartDate(startD: "");
                  Provider.of<RiderDetailsProvider>(context, listen: false).changeEndDate(endD: "");
                  Provider.of<RiderDetailsProvider>(context, listen: false).changeMode(modeOfTheTrip: "");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPageWidget()));
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF311B92),
                  padding: const EdgeInsets.all(12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Cancel The Ride',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



