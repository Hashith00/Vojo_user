import 'package:cloud_firestore/cloud_firestore.dart';

class SingleHotelDetailsModel{
  static  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static getHotelDetails({required String hotelId})async{
    CollectionReference trips = _firestore.collection('hotels');
    DocumentSnapshot snapshot = await trips.doc(hotelId).get();
    var userData = snapshot.data() as Map<String, dynamic>;

    return userData;
  }
}