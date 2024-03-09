import 'package:flutter/material.dart';

class HotelDetailsProvider extends ChangeNotifier{
  late int Price;

  HotelDetailsProvider({this.Price = 100});

  void changePrice({required int HotelPrice}){
    Price = HotelPrice;
    notifyListeners();
  }

}

class RiderDetailsProvider extends ChangeNotifier{
  late String startLocation;
  late String endLocation;
  late String intermediateLocation;
  late String startDate;
  late String endDate;
  late String mode;
  late String userId;
  late String riderId;
  late String vehicle;

  RiderDetailsProvider({this.startLocation = "", this.endLocation = "", this.intermediateLocation = "", this.endDate = "", this.startDate = "", this.mode ="", this.vehicle = ""});

  void changeStartLocation({required String start}){
    startLocation = start;
    notifyListeners();
  }

  void chageEndLocation({required String end}){
    endLocation = end;
    notifyListeners();
  }

  void changeIntermediateLocation({required String midLocation}){
    intermediateLocation = midLocation;
    notifyListeners();
  }

  void changeStartDate({required String startD}){
    startDate = startD;
    notifyListeners();
  }

  void changeEndDate({required String endD}){
    endDate = endD;
    notifyListeners();
  }

  void changeMode({required String modeOfTheTrip}){
    mode = modeOfTheTrip;
    notifyListeners();
  }

  void changeUserId({required String userID}){
    userId = userID;
    notifyListeners();
  }

  void chageRiderId({required String selectedRiderId}){
    riderId = selectedRiderId;
    notifyListeners();
  }

  void changeVehicle({required String selectedVehicle}){
    vehicle = selectedVehicle;
    notifyListeners();
  }
}