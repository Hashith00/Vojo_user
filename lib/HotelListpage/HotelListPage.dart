import 'package:flutter/material.dart';
import 'package:vojo/Conatants/Constans.dart';
import 'package:vojo/HotelDetailsPage/HotelDetailsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vojo/HotelListpage/HotelLsitPageModel.dart';

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
   getHotels();

  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var NumberOfHotels;
  getHotels()async{
    var hotels = await HotelListPageModel.getHotelCount();
    setState(() {
      NumberOfHotels =hotels;
    });
  }

  @override
  Widget build(BuildContext context) {
    int hotelCount = 0;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Container(
                     margin: EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Available Hotels',
                              style: TextStyle(
                                fontSize: 33.0,
                                fontWeight: FontWeight.w600,
                                fontFamily: primaryFontFamilty
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Colors.grey.shade200
                              ),
                              child: Center(child: Icon(Icons.add, size: 24,color: Colors.black54,),),
                            )
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          '$NumberOfHotels Hotels found',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Top Rated 🔥",
                          style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),),
                        Text("See more",
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),),

                    ],),
                  ),
                  Container(
                      child: SingleChildScrollView(
                        child: Column(
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

                                    final carCard = GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Hoteldetailspage(hotelData: hotelData, startDate: startDate, endDate: endDate, hotelImageUrl: hotelData["photourl"],hotelDescription: hotelData["description"],location:hotelData["location"] ,),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 320,
                                        width: 320,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage("${hotelData["photourl"]}"),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(20.0),
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    color: Colors.grey.shade200
                                                ),
                                                child: Center(child: Icon(Icons.heart_broken, size: 20,color: Colors.black54,),),
                                              ),
                                              SizedBox(height: 200,),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                height: 50,
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${hotelData["hotelName"]} ",
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                            fontSize: 25
                                                          ),
                                                        ),
                                                        Text(
                                                          "${hotelData["location"]} ",
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 15
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          " ${hotelData["price"]} ",
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w800,
                                                              fontSize: 17
                                                          ),
                                                        ),
                                                        Text(
                                                          "1D / 2P",
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 15
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    if(hotelData['availability'] == true){
                                      card.add(carCard);
                                    }

                                  }


                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
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
                  SizedBox(height: 40,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Recently Booked  📍",
                          style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),),
                        Text("See more",
                          style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w700,
                              fontSize: 15),),

                      ],),
                  ),
                  Container(
                      child: SingleChildScrollView(
                        child: Column(
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

                                    final carCard = GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Hoteldetailspage(hotelData: hotelData, startDate: startDate, endDate: endDate, hotelImageUrl: hotelData["photourl"],hotelDescription: hotelData["description"],location:hotelData["location"] ,),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 320,
                                        width: 320,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage("${hotelData["photourl"]}"),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.circular(20.0),
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    color: Colors.grey.shade200
                                                ),
                                                child: Center(child: Icon(Icons.heart_broken, size: 20,color: Colors.black54,),),
                                              ),
                                              SizedBox(height: 200,),
                                              Container(
                                                padding: EdgeInsets.symmetric(horizontal: 10),
                                                height: 50,
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${hotelData["hotelName"]} ",
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w700,
                                                              fontSize: 25
                                                          ),
                                                        ),
                                                        Text(
                                                          "${hotelData["location"]} ",
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 15
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          " ${hotelData["price"]} ",
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w800,
                                                              fontSize: 17
                                                          ),
                                                        ),
                                                        Text(
                                                          "1D / 2P",
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                              fontSize: 15
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    if(hotelData['availability'] == true){
                                      card.add(carCard);
                                    }

                                  }


                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
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
      ),
    );
  }
}
