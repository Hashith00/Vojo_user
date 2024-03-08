import 'package:flutter/material.dart';

class HotelDetailsProvider extends ChangeNotifier{
  late int Price;

  HotelDetailsProvider({this.Price = 100});

  void changePrice({required int HotelPrice}){
    Price = HotelPrice;
    notifyListeners();
  }

}