import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vojo/backend/backend.dart';
import 'package:vojo/index.dart';

class Hoteldetailspage extends StatefulWidget {
  var hotelData;
  var startDate;
  var endDate;
  Hoteldetailspage({super.key, required this.hotelData, required this.startDate, required this.endDate});

  @override
  State<Hoteldetailspage> createState() => _HoteldetailspageState();
}

class _HoteldetailspageState extends State<Hoteldetailspage> {

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

  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                GestureDetector(
                  onTap: ()async{
                     Response res = await CreateBooking(uid: _auth.currentUser!.uid, startDate: widget.startDate, endDate: widget.endDate, hotelName: hotelDeatils['hotelName'], hotelUserId: hotelDeatils['hotelUserId'], numberOfRooms: 5);
                    print(res.code);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPageWidget()));
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
    );
  }
}

