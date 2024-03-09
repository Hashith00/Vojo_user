import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vojo/HotelPaymentPage/HotelPayment.dart';
import 'package:vojo/StateManagment/StateManagment.dart';
import 'package:vojo/backend/backend.dart';
import 'package:vojo/index.dart';
import 'package:provider/provider.dart';

class Hoteldetailspage extends StatefulWidget {
  var hotelData;
  var startDate;
  var endDate;
  Hoteldetailspage({super.key, required this.hotelData, required this.startDate, required this.endDate});

  @override
  State<Hoteldetailspage> createState() => _HoteldetailspageState();
}

class _HoteldetailspageState extends State<Hoteldetailspage> {
  int numberOfRooms = 1;
  late int price;
  late int basePrice;
  late var hoteluser;
  late var hotelDeatils;
  late FirebaseAuth _auth;
  void getHotelUser()async{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final employees =  await _firestore.collection("serviceUser").get();
    for(var massage in employees.docs){
      if(massage.data()["uid"] == widget.hotelData["hotelUserId"]){
        setState(() {
          hoteluser = massage.data();
        });

        break;
      }

    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHotelUser();
    hotelDeatils = widget.hotelData;
    _auth = FirebaseAuth.instance;
    setState(() {
      price = hotelDeatils["price"];
      basePrice = hotelDeatils["price"]; // This variable is used to determined the base price of a hotel room.
    });

  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => HotelDetailsProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF311B92),
          ),
          body: SafeArea(
            child: Container(
              child: Column(
                children: [
                  Text("${hotelDeatils['hotelName']}"),
                  Text("Price : ${hotelDeatils['price']}"),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      FloatingActionButton(onPressed: (){
                        setState(() {
                          price = price + basePrice;
                          numberOfRooms++;
                        });
                      }, child: Icon(Icons.add)),
                      SizedBox(width: 30,),
                      Text("$price USD"),
                      SizedBox(width: 30,),
                      FloatingActionButton(onPressed: (){
                        if(price >= basePrice && numberOfRooms >= 1){
                          setState(() {
                            price = price - basePrice;
                            numberOfRooms--;
                          });
                        }
                      }, child: Icon(Icons.remove)),
                      SizedBox(width: 20,),
                      Text("Number of Rooms ; $numberOfRooms")
                    ],
                  ),
                  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){

                      Provider.of<HotelDetailsProvider>(context, listen: false).changeUserId(UserId: _auth.currentUser!.uid);
                      Provider.of<HotelDetailsProvider>(context, listen: false).changeStartDate(StartDate: widget.startDate);
                      Provider.of<HotelDetailsProvider>(context, listen: false).changeEndDate(EndDate: widget.endDate);
                      Provider.of<HotelDetailsProvider>(context, listen: false).changeHotelName(HotelName: hotelDeatils['hotelName']);
                      Provider.of<HotelDetailsProvider>(context, listen: false).changeHotelUserId(HotelUserId: hotelDeatils['hotelUserId']);
                      Provider.of<HotelDetailsProvider>(context, listen: false).changeHotelRooms(NumberOfRooms: numberOfRooms);


                       context.read<HotelDetailsProvider>().changePrice(HotelPrice: price*100);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HotelPayment()));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                      ),
                      height: 50,
                      width: double.infinity,

                      child: Center(child: Text("Book", style: TextStyle(fontSize: 18, color: Colors.white),),),
                    ),
                  ),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                  ),
                  height: 50,
                  width: double.infinity,

                  child: Center(child: Text("Back", style: TextStyle(fontSize: 18, color: Colors.white),),),
                ),
              )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

