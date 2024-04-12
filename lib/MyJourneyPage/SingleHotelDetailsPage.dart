import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SingleHotelDetailsPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String hotelName;
  final String hotelDocId;
  const SingleHotelDetailsPage({super.key, required this.latitude, required this.longitude, required this.hotelName, required this.hotelDocId});

  @override
  State<SingleHotelDetailsPage> createState() => _SingleHotelDetailsPageState();
}

class _SingleHotelDetailsPageState extends State<SingleHotelDetailsPage> {
  late GoogleMapController mapController;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            Container(
              height: 500,
              child: GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.latitude, widget.longitude), // Initial map position (San Francisco)
                  zoom: 12.0,
                ),
                markers: {Marker(
                  markerId: MarkerId('marker2'),
                  position: LatLng(widget.latitude, widget.longitude), // Another location in San Francisco
                  infoWindow: InfoWindow(
                    title: 'Marker 2',
                    snippet: 'Description for Marker 2',
                  ),
                )},
              ),
            ),
            Text("${widget.latitude}"),
            Text("${widget.longitude}"),
            Text("${widget.hotelDocId}"),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: ()async{
              },
              child: Container(
                color: Colors.blue,
                height: 40,
                width: 300,
                child: Center(
                  child: Text("Cancel Booking"),
                ),
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.blue,
                height: 40,
                width: 300,
                child: Center(
                  child: Text("Back"),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
