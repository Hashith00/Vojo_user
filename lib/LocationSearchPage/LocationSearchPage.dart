import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:vojo/LocationSearchPage/ConvertPlaceId.dart';
import 'package:vojo/LocationSearchPage/PlaceAutocomplete.dart';
import 'package:vojo/LocationSearchPage/locationTitle.dart';
import 'package:vojo/LocationSearchPage/networkUtills.dart';
import 'package:vojo/TestLocation/TestLocations.dart';

import 'AutoCompletePrediction.dart';

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  String inputValue = "";
  String finalLocation = "";

  List<AutocompletePrediction> placePredictions = [];
  void placeAutoComplete(String location)async{
    Uri uri = Uri.https(
        "maps.googleapis.com",
      "maps/api/place/autocomplete/json",
      {
        "input" : location,
        "key" : "AIzaSyC8XOXvvxImxyxY6dFnOKIMTlbOM3X58Yw"
      }
    );
    String? responce = await NetworkUtills.fetchUrl(uri);

    if(responce != null) {
      PlaceAutocompleteResponse result = PlaceAutocompleteResponse.parseAutocompleteResult(responce);
      if(result.predictions != null){
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }
  TextEditingController? _tempTextController;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                TextFormField(
                  controller: _tempTextController,
                  onChanged: (value){
                      placeAutoComplete(value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search Locatioin",
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Icon(Icons.search, color: Colors.black54,),
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.black54,
                      ),
                    ),


                  ),
                ),
                Divider(
                  height: 4,
                    thickness: 4,
                    color: Color(0xFFF8F8F8),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: placePredictions.length,
                      itemBuilder: (context, index) =>
                      LocationListTile(
                          location: placePredictions[index].description!,
                          press: ()async{
                            print(placePredictions[index].placeId);
                            final coordinates = await ConvertPlaceId.getLatLngFromPlaceId(placePredictions[index].placeId!);
                            print('Latitude: ${coordinates['latitude']}');
                            print('Longitude: ${coordinates['longitude']}');
                            setState(() {
                              finalLocation = placePredictions[index].description!;
                            });

                          })),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context, finalLocation);
                  },
                  child: Container(
                    height: 45,
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]
                    ),
                    child: Center(child: Text("Set $finalLocation"),),
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
