import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vojo/stripPage/newStripe.dart';
import 'package:firebase_core/firebase_core.dart';
import '../backend/backend.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _CollectionBooking = _firestore.collection("bookings");




class HotelPaymentModle{
  static void printHello(){
    print("Hello");
  }

  static Future<bool> MakeStrpePayment(int price) async{
    StripePayment newPayment = new StripePayment();
    bool ispayment =  await newPayment.makePayment(price);
    return ispayment;
  }

  // static void UpdateThePayment({required double price, required String bookingId, required double distance}) async{
  //   Response response = Response();
  //   DocumentReference documentReferencer =
  //   _CollectionBooking.doc();
  //
  //   Map<String, dynamic> data = <String, dynamic>{
  //     "travelling_mode": price,
  //     "distance" : distance
  //   };
  //
  //
  // }
}