import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vojo/Conatants/Constans.dart';
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
  int totalAvailableCars = 0;
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
        body: Container(
          color: Colors.grey.shade200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20, 30, 20, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.grey.shade300
                        ),
                        child: Icon(Icons.arrow_back, color: Colors.black87,),

                      ),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                    GestureDetector(
                      onTap: (){
                        Provider.of<RiderDetailsProvider>(context, listen: false).changeStartLocation(start: "");
                        Provider.of<RiderDetailsProvider>(context, listen: false).chageEndLocation(end: "");
                        Provider.of<RiderDetailsProvider>(context, listen: false).changeIntermediateLocation(midLocation: "");
                        Provider.of<RiderDetailsProvider>(context, listen: false).changeStartDate(startD: "");
                        Provider.of<RiderDetailsProvider>(context, listen: false).changeEndDate(endD: "");
                        Provider.of<RiderDetailsProvider>(context, listen: false).changeMode(modeOfTheTrip: "");
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPageWidget()));
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.grey.shade300
                        ),
                        child: Icon(Icons.close, color: Colors.black87,),
                      ),
                    )
                  ],
                ),
              ),
               Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Available Vehicles',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.0),
                    Text(
                      '2 vehicles found',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.grey,
                        fontWeight: FontWeight.w300
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
                              final vehicleData = message.data() as Map<String, dynamic>; // Explicit cast
                              var messageText = vehicleData["end_date"];
                              //messagesList.add(Text('$messageText'));

                              final carCard = Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              child: Image(image: AssetImage('assets/images/Tesla_logo.png'),),
                                            ),
                                            SizedBox(width: 10,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("${vehicleData["brand"]}", style: TextStyle(color: Colors.black87, fontSize: 23, fontWeight: FontWeight.w600),),
                                                Text("${vehicleData["model"]}", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w400),),
                                              ],
                                            )
                                          ],
                                        ),
                                        Text("\$5 / 1 km",style: TextStyle(fontSize: 15, color: Colors.grey),)
                                      ],
                                    ),
                                    SizedBox(height: 30,),
                                    Container(
                                      width: double.infinity,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/car_tesla.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 50,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Text("Fual", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black),),
                                            Text("${vehicleData["fuel_type"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black38),),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Passengers", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black),),
                                            Text("${vehicleData["max_passenger"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black38),),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Vehical No.", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black),),
                                            Text("${vehicleData["vehicle_no"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black38),),
                                          ],
                                        )
                                      ],
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => RidersBookingPage(vehicleDeatils: vehicleData),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Center(
                                                child: Text(
                                                  "Select This ",
                                                  style:
                                                  TextStyle(color: Colors.white, fontSize: 17),
                                                ),
                                              ),
                                              height: 50,
                                              width: 300,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color: primaryColor,
                                              ),

                                            ),


                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );

                              print(category);
                              if(vehicleData["categoty"] == "$category"){
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
    );
  }
}



/*

final tripCard = Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.trip_origin_sharp, color: Colors.red,size: 23,),
                                                SizedBox(width: 10,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("${messageData["categoty"]}", style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w700),),
                                                    Text("${messageData["brand"]}", style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w700),),
                                                  ],
                                                )
                                              ],
                                            ),
                                            Text("\$299 / 1 km",style: TextStyle(fontSize: 15, color: Colors.grey),)
                                          ],
                                        ),
                                        SizedBox(height: 30,),
                                        Container(
                                          width: double.infinity,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/car.png'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 50,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text("Fual", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black),),
                                                Text("${messageData["fuel_type"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black38),),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("Passengers", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black),),
                                                Text("${messageData["max_passenger"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black38),),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text("Vehical No.", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black),),
                                                Text("${messageData["vehicle_no"]}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black38),),
                                              ],
                                            )
                                          ],
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Column(
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                child: GestureDetector(
                                                    onTap: () async{
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        "Edit Details",
                                                        style:
                                                        TextStyle(color: Colors.white, fontSize: 17),
                                                      ),
                                                    )),
                                                height: 50,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Colors.black,
                                                ),

                                              ),
                                              SizedBox(height: 15),
                                              GestureDetector(
                                                child: Container(
                                                  height: 50,
                                                  width: 300,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(15),
                                                    border: Border.all(width: 1,color: Colors.black),
                                                  ),
                                                  child:Center(
                                                    child: Text("Delete Vehicle", style: TextStyle(color: Colors.black),),
                                                  ) ,
                                                ),
                                              )

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

* */


/* Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => RidersBookingPage(vehicleDeatils: messageData),
                                            ),
                                          );
                                          */

