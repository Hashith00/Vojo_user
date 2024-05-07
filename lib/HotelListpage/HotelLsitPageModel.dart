import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;


class HotelListPageModel{
  static Future<int> getHotelCount()async{
    int numberOfHotels = 0;
    final hotels =  await _firestore.collection("hotels").get();
    for(var hotel in hotels.docs){
      if(hotel.data()["availability"] == true){
        numberOfHotels++;
      }
    }
    print(numberOfHotels);
    return numberOfHotels;
  }
}