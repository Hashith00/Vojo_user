import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vojo/Conatants/Constans.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PlacesSuggestionPage extends StatefulWidget {
  const PlacesSuggestionPage({Key? key}) : super(key: key);

  @override
  State<PlacesSuggestionPage> createState() => _PlacesSuggestionPageState();
}

class _PlacesSuggestionPageState extends State<PlacesSuggestionPage> {
  var res;
  List<dynamic>? places ;
  bool isLoaded = false;
  var _loading = true;
  getNearByLocation()async{
    print("Hello");
    try{
      res = await fectchData("http://10.0.2.2:5000/places?latitude=40.7128&longitude=-74.0060&radius=1000");
      print(jsonDecode(res));
      Map<String, dynamic> decodedResponse = jsonDecode(res);
      places = decodedResponse['results'];
      setState(() {
        _loading = false;
      });
    }catch(e){
      print(e);
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNearByLocation();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : places != null ?
      SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Find your", style: TextStyle(fontSize: 35, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w800)),
                  Text("Near By Places", style: TextStyle(fontSize: 35, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w800)),
                  Row(
                    children: [
                      
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: places?.length,
                itemBuilder: (context, index) {
                  // Extract place details
                  Map<String, dynamic> place = places?[index];
                  String name = place['name'];
                  double latitude = place['geometry']['location']['lat'];
                  double longitude = place['geometry']['location']['lng'];
                  var ration = place['rating'] ?? 0.00;
                  String locationType = place["types"][0] ?? 'No location type';
                  String vicinity = place["vicinity"] ?? 'No vicinity';

                  // Display place details
                  return ListTile(
                    subtitle: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white10
                      ),
                      height: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image(image: NetworkImage("https://img2.chinadaily.com.cn/images/202106/17/60cabadca31024adbdceb190.jpeg"),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(name, style: TextStyle(fontSize: 22, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500)),
                          //Text('Latitude: $latitude, Longitude: $longitude'),
                          SizedBox(height: 5,),
                          Wrap(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, color: Colors.black,),
                                      Text('$vicinity', style: TextStyle(fontSize: 15, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w400)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: CupertinoColors.systemYellow,),
                                      Text('$ration'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),


                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ) : Container(child: Text('No places found')) ,

    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}


fectchData(String url)async{
  http.Response responce =await http.get(Uri.parse(url));
  return responce.body;
}