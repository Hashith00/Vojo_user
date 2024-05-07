import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vojo/Conatants/Constans.dart';
import 'package:vojo/backend/backend.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart' as gmaps;


class SingleHotelDetailsPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String hotelName;
  final String hotelDocId;
  final String hotelId;
  final Timestamp startingDate;
  final Timestamp endingDate;
  final String photoUrl;
  const SingleHotelDetailsPage({super.key, required this.latitude, required this.longitude, required this.hotelName, required this.hotelDocId, required this.hotelId, required this.startingDate, required this.endingDate, required this.photoUrl});

  @override
  State<SingleHotelDetailsPage> createState() => _SingleHotelDetailsPageState();
}

class _SingleHotelDetailsPageState extends State<SingleHotelDetailsPage> {
  late GoogleMapController mapController;
  var hotelUrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hotelUrl = getHotelDetails(hotelId: widget.hotelDocId);
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: NetworkImage("${widget.photoUrl}"),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.4),
                        BlendMode.darken
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${widget.hotelName}", style: TextStyle(fontSize: 20, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w700),),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.grey,size: 17,),
                        SizedBox(width: 10,),
                        Text("4.9 ( 194 Reviews )", style: TextStyle(fontSize: 17, fontFamily: primaryFontFamilty,color: Colors.grey ),),
                      ],
                    )
                  ],
                ),
              ),

              Divider(thickness: 1,color: Colors.grey,),
              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Hilton hotel gruop", style: TextStyle(fontSize: 17, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500),),
                        SizedBox(height: 5,),
                        Text("Hosted by Mr. Thilina", style: TextStyle(fontSize: 15, fontFamily: primaryFontFamilty, color: Colors.grey ),)
                      ],
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                          image: NetworkImage("https://img.freepik.com/free-photo/luxury-classic-modern-bedroom-suite-hotel_105762-1787.jpg"),
                          fit: BoxFit.fill,

                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1,color: Colors.grey,),
              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                height: 100,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Booking Details ", style: TextStyle(fontSize: 17, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500),),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Check In ", style: TextStyle(fontSize: 17, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500),),
                        Text("${(DateTime.fromMicrosecondsSinceEpoch(widget.startingDate.microsecondsSinceEpoch)).toString().split(" ")[0]}", style: TextStyle(fontSize: 15, fontFamily: primaryFontFamilty, color: Colors.grey),),

                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Check out", style: TextStyle(fontSize: 17, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500),),
                        Text("${(DateTime.fromMicrosecondsSinceEpoch(widget.endingDate.microsecondsSinceEpoch)).toString().split(" ")[0]}", style: TextStyle(fontSize: 15, fontFamily: primaryFontFamilty, color: Colors.grey),),
                      ],
                    ),
                     ],
                ),
              ),
              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric( horizontal: 20),
                child: Text("Location Details ", style: TextStyle(fontSize: 17, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500),),
              ),
              Container(
                width: double.infinity,
                height: 200,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Container(
                  child: GoogleMap(
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    initialCameraPosition: CameraPosition(
                      target: gmaps.LatLng(widget.latitude, widget.longitude), // Initial map position (San Francisco)
                      zoom: 12.0,
                    ),
                    markers: {Marker(
                      markerId: MarkerId('marker2'),
                      position: gmaps.LatLng(widget.latitude, widget.longitude), // Another location in San Francisco
                      infoWindow: InfoWindow(
                        title: 'Marker 2',
                        snippet: 'Description for Marker 2',
                      ),
                    )},
                  ),
                ),
              ),

              SizedBox(height: 20,),
              Container(
                  width: double.infinity,
                  height: 70,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryColor
                    ),
                    child: Center(
                      child: Text("Go Back", style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }
}
