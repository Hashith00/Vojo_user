import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RiderListModel{
  static Future<int> numberofVehicles({
    required String type
})async{
    int vehicleCount = 0;
    final vehicles =  await _firestore.collection("vehicles").get();
    for(var vehicle in vehicles.docs){
      if(vehicle.data()["categoty"] == type){
        vehicleCount++;
      }

    }
    print("Hello");
    return vehicleCount;
  }
}