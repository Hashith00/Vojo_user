import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vojo/Conatants/Constans.dart';
import 'package:vojo/HotelPaymentPage/HotelPayment.dart';
import 'package:vojo/StateManagment/StateManagment.dart';
import 'package:vojo/backend/backend.dart';
import 'package:vojo/index.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart' as gmaps;


class Hoteldetailspage extends StatefulWidget {
  var hotelData;
  var startDate;
  var endDate;
  String hotelImageUrl;
  String hotelDescription;
  String location;
  Hoteldetailspage({super.key, required this.hotelData, required this.startDate, required this.endDate, required this.hotelImageUrl, required this.hotelDescription, required this.location});

  @override
  State<Hoteldetailspage> createState() => _HoteldetailspageState();
}

class _HoteldetailspageState extends State<Hoteldetailspage> {
  late GoogleMapController mapController;
  int numberOfRooms = 1;
  late double price;
  late double basePrice;
  late var hoteluser;
  late var hotelDeatils;
  late FirebaseAuth _auth;
  void getHotelUser()async{
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final employees =  await _firestore.collection("serviceUser").get();
    for(var user in employees.docs){
      if(user.data()["uid"] == widget.hotelData["hotelUserId"]){
        setState(() {
          hoteluser = user.data();
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
    print("Price ${hotelDeatils['price']}");
    setState(() {
      price = (hotelDeatils["price"] as num).toDouble();
      basePrice = (hotelDeatils["price"] as num).toDouble();
    });

  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => HotelDetailsProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      height: 350,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage("${hotelDeatils["photourl"]}"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        GestureDetector(
                            child: Icon(Icons.arrow_back, color: Colors.white,),onTap: (){ Navigator.pop(context);},)
                      ],)
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Colors.white, size: 14,),
                                SizedBox(width: 10,),
                                Text("4.1 Rating", style: TextStyle(color: Colors.white, fontFamily: primaryFontFamilty, fontSize: 14),),
                              ],
                            ),
                            padding: EdgeInsets.all(5),
                            color: Colors.yellow.shade600,
                          ),
                          SizedBox(height: 14,),
                          Text("${hotelDeatils['hotelName']}", style: TextStyle(fontSize: 25, fontFamily: primaryFontFamilty, color: Colors.black, fontWeight: FontWeight.w700),),
                          SizedBox(height: 3,),
                          Text("${hotelDeatils['location']}", style: TextStyle(fontSize: 18, fontFamily: primaryFontFamilty, color: Colors.black, fontWeight: FontWeight.w400),),
                          SizedBox(height: 3,),
                          Text("${hotelDeatils['description']}", style: TextStyle(fontSize: 15, fontFamily: primaryFontFamilty, color: Colors.black, fontWeight: FontWeight.w300,),),
                          SizedBox(height: 30,),
                          Container(
                            height: 150,
                            child: GoogleMap(
                              onMapCreated: (GoogleMapController controller) {
                                mapController = controller;
                              },
                              initialCameraPosition: CameraPosition(
                                target: gmaps.LatLng(hotelDeatils['locationLat'], hotelDeatils['locationLng']), // Initial map position (San Francisco)
                                zoom: 12.0,
                              ),
                              markers: {Marker(
                                markerId: MarkerId('marker2'),
                                position: gmaps.LatLng(hotelDeatils['locationLat'], hotelDeatils['locationLng']), // Another location in San Francisco
                                infoWindow: InfoWindow(
                                  title: 'Marker 2',
                                  snippet: 'Description for Marker 2',
                                ),
                              )},
                            ),
                          ),
                          SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                child: Image(image: AssetImage('assets/images/bar.png'),)
                              ),
                              Column(
                                children: [
                                  Container(
                                      height: 50,
                                      width: 50,
                                      child: Image(image: AssetImage('assets/images/coffe.png'),)
                                  ),
                                ],
                              ),
                              Container(
                                  height: 50,
                                  width: 50,
                                  child: Image(image: AssetImage('assets/images/wifi.png'),)
                              ),
                            ],
                          ),
                          SizedBox(height: 30,),
                          Text("Booking", style: TextStyle(fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500, fontSize: 20),),
                          SizedBox(height: 10,),
                          Container(

                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.grey.shade300)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Rooms"),
                                Row(
                                  children: [
                                    GestureDetector(
                                        child: Icon(Icons.add_circle_outline, color: Colors.grey,size: 25,),
                                      onTap: (){
                                        setState(() {
                                          price = price + basePrice;
                                          numberOfRooms++;
                                        });
                                      },
                                    ),
                                    SizedBox(width: 10,),
                                    Text("$numberOfRooms" , style: TextStyle(fontSize: 15),),
                                    SizedBox(width: 10,),
                                    GestureDetector(
                                        child: Icon(Icons.remove_circle_outline, color: Colors.grey,size: 25,),
                                    onTap: (){
                                      if(price >= basePrice && numberOfRooms >= 1){
                                        setState(() {
                                          price = price - basePrice;
                                          numberOfRooms--;
                                        });
                                      }
                                    },),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 40,),
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("\$ $price", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, ),),
                                  Text("Sub Total", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, ),),
                                ],
                              ),
                                width: 100,
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: (){
                                    Provider.of<HotelDetailsProvider>(context, listen: false).changeUserId(UserId: _auth.currentUser!.uid);
                                    Provider.of<HotelDetailsProvider>(context, listen: false).changeStartDate(StartDate: widget.startDate);
                                    Provider.of<HotelDetailsProvider>(context, listen: false).changeEndDate(EndDate: widget.endDate);
                                    Provider.of<HotelDetailsProvider>(context, listen: false).changeHotelName(HotelName: hotelDeatils['hotelName']);
                                    Provider.of<HotelDetailsProvider>(context, listen: false).changeHotelUserId(HotelUserId: hotelDeatils['hotelUserId']);
                                    Provider.of<HotelDetailsProvider>(context, listen: false).changeHotelRooms(NumberOfRooms: numberOfRooms);
                                    Provider.of<HotelDetailsProvider>(context, listen: false).changeHotelLatitude(latitude: hotelDeatils['locationLat']);
                                    Provider.of<HotelDetailsProvider>(context, listen: false).changeHotelLongitude(longitude: hotelDeatils['locationLng']);
                                    Provider.of<HotelDetailsProvider>(context, listen: false).chageHotelPhotoUrl(hotelPhotoUrl: hotelDeatils['photourl']);
                                    Provider.of<HotelDetailsProvider>(context, listen: false).chageHotelLocation(location:  hotelDeatils['location']);


                                    Provider.of<HotelDetailsProvider>(context, listen: false).changePrice(HotelPrice: price*100);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => HotelPayment()));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: primaryColor,
                                    ),
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    height: 60,
                                    child: Center(child: Text("Book Now", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white ),),),

                                  ),
                                ),
                              )
                            ],
                          )

                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

