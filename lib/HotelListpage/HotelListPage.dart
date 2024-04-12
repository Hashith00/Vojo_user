import 'package:flutter/material.dart';
import 'package:vojo/HotelDetailsPage/HotelDetailsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HotelListPage extends StatefulWidget {
 final DateTime startDate;
 final DateTime endDate;
  const HotelListPage({super.key, required this.startDate, required this.endDate});


  @override
  State<HotelListPage> createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   startDate = widget.startDate;
   endDate =widget.endDate;

  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
       appBar: AppBar(
         backgroundColor:Color(0xFF311B92),
       ),
        body: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),
                      Text(
                        'Available Hotels',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '10 Hotels found',
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
                            stream: _firestore.collection("hotels").snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) { // Use hasData instead of != null
                                final hotels = snapshot.data!.docs;
                                List<Text> messagesList = []; // Use camelCase for variable names
                                List<Widget> card = [];

                                for (var hotel in hotels) {
                                  final hotelData = hotel.data() as Map<String, dynamic>; // Explicit cast
                                  //var messageText = hotelData["end_date"];
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
                                              "${hotelData["hotelName"]} ",
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.location_city, size: 16.0),
                                                  const SizedBox(width: 8.0),
                                                  Text("${hotelData["location"]} "),
                                                ],
                                              ),
                                            ),
                                            trailing: Icon(Icons.abc),
                                            //onTap: onTap,
                                          ),
                                          const SizedBox(height: 4.0),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                            width: double.infinity,
                                            child: Image.network("${hotelData["photourl"]}"),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 16.0),
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Hoteldetailspage(hotelData: hotelData, startDate: startDate, endDate: endDate),
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
                                  if(hotelData['availability'] == true){
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

              ],
            ),
          ),
        ),
      ),
    );
  }
}
