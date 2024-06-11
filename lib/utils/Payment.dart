
class PaymentProcess{
  static double getThePriceInDollers({
    required double distance,
    required String vehicleType,
    String? carType,
    required String startDate,
    required String endDate
}){
    double? fixedPrice;
    int? totalDaysOfTrip;
    double? priceForDays;
    double totalPrice = 0;
    double currentDollarRate = 300;

    print("distance: $distance");

    if(vehicleType == "car"){
      if(carType == "sedan") {
        fixedPrice = distance * 150;
      }else if(carType == "miniSuv"){
        fixedPrice = distance * 200;
      }else if(carType == "shuttle"){
        fixedPrice = distance * 180;
      }else{
        fixedPrice = distance * 120;
        print("Hello");
      }
    }else if(vehicleType == 'van'){
      fixedPrice = distance * 250;
    }else if (vehicleType == 'bike'){
      fixedPrice = distance * 100;
    }else{
      fixedPrice = distance * 50;
    }

    int startMonth = int.parse(startDate.substring(5, 7));
    int startDay = int.parse(startDate.substring(8, 10));
    int endMonth = int.parse(endDate.substring(5, 7));
    int endDay= int.parse(endDate.substring(8, 10));

    if(startMonth == endMonth){
      totalDaysOfTrip = endDay - startDay;
    }else{
      if(endMonth - startMonth == 1){
        totalDaysOfTrip = (30 - startDay) + endDay;
      }
      else{
        totalDaysOfTrip = ((30 - startDay) + endDay) + (endMonth - startMonth -1);
      }
    }

    priceForDays = totalDaysOfTrip * 2000;

      totalPrice = priceForDays + fixedPrice;

    print(priceForDays);
    print(fixedPrice);
    return totalPrice / currentDollarRate;

  }
}