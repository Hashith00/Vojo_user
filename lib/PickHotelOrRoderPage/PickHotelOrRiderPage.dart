import 'package:flutter/material.dart';
import 'package:vojo/HotelDateSelectorPage/HotelDetaSelectionPage.dart';
import 'package:vojo/pick_location_page/pick_location_page.dart';

class PickHotelOrRider extends StatefulWidget {
  const PickHotelOrRider({super.key});

  @override
  State<PickHotelOrRider> createState() => _PickHotelOrRiderState();
}

class _PickHotelOrRiderState extends State<PickHotelOrRider> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => PickLocationPage()));
                  },
                  child: Container(
                    height: 200,
                    width: 200,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: Colors.grey)
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          height: 100,
                            width: 100,
                            child: Image(image: AssetImage('assets/images/cycle.png'))),
                        Text("Book a Rider", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),)
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HotelDateSelectingPage()));
                  },
                  child: Container(
                    height: 200,
                    width: 200,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.grey)
                    ),
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(bottom: 20),
                            height: 100,
                            width: 100,
                            child: Image(image: AssetImage('assets/images/car.png'))),
                        Text("Book a Hotel", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),)
                      ],
                    ),
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
