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
  List<dynamic>? places;
  bool isLoaded = false;
  var _loading = true;

  @override
  void initState() {
    super.initState();
    getNearByLocation();
  }

  Future<void> getNearByLocation() async {
    try {
      var res = await fetchData("http://10.0.2.2:5000/places?latitude=40.7128&longitude=-74.0060&radius=100");
      Map<String, dynamic> decodedResponse = jsonDecode(res);
      places = decodedResponse['results'];

      if (places != null) {
        for (var place in places!) {
          double latitude = place['geometry']['location']['lat'];
          double longitude = place['geometry']['location']['lng'];
          var photoRes = await fetchData("http://10.0.2.2:5000/get_place_photo?latitude=$latitude&longitude=$longitude");
          var photoData = jsonDecode(photoRes);
          place['photo_url'] = photoData['photo_url'];
        }
      }

      setState(() {
        _loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> fetchData(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : places != null
          ? SafeArea(
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
                    children: [],
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
                  var rating = place['rating'] ?? 0.00;
                  String locationType = place["types"][0] ?? 'No location type';
                  String vicinity = place["vicinity"] ?? 'No vicinity';
                  String photoUrl = place['photo_url'] ?? 'https://via.placeholder.com/400';

                  // Display place details
                  return ListTile(
                    subtitle: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white10,
                      ),
                      height: 350,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Image.network(
                              photoUrl,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(name, style: TextStyle(fontSize: 22, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500)),
                          SizedBox(height: 5),
                          Wrap(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on, color: Colors.black),
                                        SizedBox(width: 8), // Add some spacing between the icon and text
                                        Expanded(
                                          child: Text(
                                            '$vicinity',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontFamily: primaryFontFamilty,
                                              fontWeight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: CupertinoColors.systemYellow),
                                      Text('$rating'),
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
      )
          : Container(child: Text('No places found')),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}