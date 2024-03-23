import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocode/geocode.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:vojo/stripPage/newStripe.dart';



final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _CollectionTrips = _firestore.collection("trips");



class RiderPaymentModel{

   static Future<LatLng> getLocation({required String location}) async {
    late LatLng pos;
    GeoCode geoCode = GeoCode(apiKey: "135158425259448e15921900x20274");

      try{
        Coordinates usercoordinate = await geoCode.forwardGeocoding(address: location);
        LatLng pos = LatLng((usercoordinate.latitude)!.toDouble(), (usercoordinate.longitude)!.toDouble());
        return pos;
      }catch(e){
        print(e);
        return LatLng(0.0000, 0.0000);

      }
  }

   static Future<double> calculateDistance({required String StartLocation, required String EndLocation })async{
     print(EndLocation);
     print(StartLocation);
    LatLng startLocation = await getLocation(location: StartLocation);
    LatLng endLocation = await getLocation(location: EndLocation);

    if(startLocation != null){
      try {
        // Just for Testing
        double distance = (startLocation.longitude - endLocation.longitude).abs();
        print(startLocation.longitude);
        print(endLocation.longitude);
        // This is the actual code
        // var response = await Dio().get('https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${endLocation.latitude},${endLocation.longitude}&origins=${startLocation.latitude},${startLocation.longitude}&key=YOUR_API_KEY_HERE');
        // print(json.decode(response.data));
        distance = double.parse((distance).toStringAsFixed(2));
        print(distance);
        return distance;
      } catch (e) {
        print(e);
        return -1;
      }
    }
    return -1;
  }

  static double calculateCost({required String TransportationMode, required double distance}){
     switch (TransportationMode){
       case "car" :
         return 15 * distance;
       case "van" :
         return 20 * distance;
       case "bike" :
         return 10 * distance;
       case "tuk" :
         return 12 * distance;
     }
     return -1;
  }

   static Future<bool> MakeStripePayment(double cost) async{
     StripePayment newPayment = new StripePayment();
     bool ispayment =  await newPayment.makePayment(cost.toInt());
     return ispayment;
   }


}