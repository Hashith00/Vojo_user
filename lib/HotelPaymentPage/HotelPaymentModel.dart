import 'package:vojo/stripPage/newStripe.dart';

class HotelPaymentModle{
  static void printHello(){
    print("Hello");
  }

  static Future<bool> MakeStrpePayment(int price) async{
    StripePayment newPayment = new StripePayment();
    bool ispayment =  await newPayment.makePayment(price);
    return ispayment;
  }
}