import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class HotelDetailsProvider extends ChangeNotifier{
  static final DateTime _defaultDateTime = DateTime.now();
  late int Price;
  late String userId;
  late DateTime startDate;
  late DateTime endDate;
  late String hotelName;
  late String hotelUserId;
  late int numberOfRooms;
  double? hotelLatitude;
  double? hotelLongitude;

  HotelDetailsProvider({this.Price = 100, this.userId = "", this.hotelUserId = "", this.hotelName ="", this.numberOfRooms = 1});

  void changePrice({required int HotelPrice}){
    Price = HotelPrice;
    notifyListeners();
  }

  void changeStartDate({required DateTime StartDate}){
    startDate = StartDate;
    notifyListeners();
  }

  void changeEndDate({required DateTime EndDate}){
    endDate = EndDate;
    notifyListeners();
  }

  void changeUserId({required String UserId}){
    userId = UserId;
    notifyListeners();
  }

  void changeHotelUserId({required String HotelUserId}){
    hotelUserId = HotelUserId;
    notifyListeners();
  }

  void changeHotelName({required String HotelName}){
    hotelName = HotelName;
    notifyListeners();
  }

  void changeHotelRooms({required int NumberOfRooms}){
    numberOfRooms = NumberOfRooms;
    notifyListeners();
  }

  void changeHotelLatitude({required double latitude}){
    hotelLatitude = latitude;
    notifyListeners();
  }

  void changeHotelLongitude({required double longitude}){
    hotelLongitude= longitude;
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
  double? startLocationLatitude;
  double? startLocationLongitude;
  double? endLocationLatitude;
  double? endLocationLongitude;
  double? intermediateLocationLatitude;
  double? intermediateLocationLongitude;



  RiderDetailsProvider({this.startLocation = "", this.endLocation = "", this.intermediateLocation = "", this.endDate = "", this.startDate = "", this.mode ="", this.vehicle = "" });

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

  void changeStartLocationLat({required double StartCor}){
    startLocationLatitude = StartCor;
    notifyListeners();
  }

  void changeStartLocationLng({required double StartCor}){
    startLocationLongitude = StartCor;
    notifyListeners();
  }

  void changeEndLocationLat({required double EndCor}){
    endLocationLatitude = EndCor;
    notifyListeners();
  }

  void changeEndLocationLng({required double EndCor}){
    endLocationLongitude = EndCor;
    notifyListeners();
  }

  void changeIntermediateLocationLat({required double InterCor}){
    intermediateLocationLatitude = InterCor;
    notifyListeners();
  }

  void changeIntermediateLocationLng({required double InterCor}){
    intermediateLocationLongitude = InterCor;
    notifyListeners();
  }
}


class TempDetailsProvider extends ChangeNotifier{
  late String startLocation;
  double? lat;
  double? long;

  TempDetailsProvider({this.startLocation = ""});

  void ChageLocation({required String location}){
    startLocation = location;
    notifyListeners();
  }

  void ChageLat({required double latitide}){
    lat = latitide;
    notifyListeners();
  }

  void Chagelng({required double longitude}){
    long = longitude;
    notifyListeners();
  }

}