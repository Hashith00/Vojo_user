import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class newStripePage extends StatefulWidget {
  const newStripePage({super.key});

  @override
  State<newStripePage> createState() => _newStripePageState();
}

class _newStripePageState extends State<newStripePage> {
  static String secriteKey = "sk_test_51OSCmFCem4pjyRAz5OhZmED0AujarN6IZNC62KngWTVdffXTjlfHVLsZQNbsbA9hoJoZwnkyVWt7vECKjJ9bp1GQ00aeEzSmFa";
  static String publishableKey = "pk_test_51OSCmFCem4pjyRAzDzsny1yS8fm8RQRjqQDNryrarztSx6kxpvty3SZMx3jaWcCE54pyo4Zmtv3DWMfzNa65V5HH00p1wiVzRu";
  Map<String,dynamic>? paymentIntent;

  void makepayment()async{
    try{
      paymentIntent =await createPaymentIntent();
      print(paymentIntent!['client_secret']);

      await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent!['client_secret'],
        style: ThemeMode.dark,
        merchantDisplayName: "Vojo Development"
      ));
      dispalyPaymentSheet();

    }catch(e){
      throw Exception(e.toString());
    }
  }

  void dispalyPaymentSheet()async{
    try{
      await Stripe.instance.presentPaymentSheet();
      print("Done");
    }catch(e){
      throw Exception(e.toString());
    }
  }



   createPaymentIntent()async{
    try{
      Map<String, dynamic> body = {
        "amount" : "100",
        "currency" : "USD"
      };
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            'Authorization' : 'Bearer $secriteKey',
            "Content-Type" : "application/x-www-form-urlencoded"
          }
      );

      return json.decode(response.body);

    }catch(e){
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onTap: (){
              print("object");
              makepayment();
            },
            child: Container(
              height: 50,
              width: 150,
              color: Colors.black,
              child: Text("hello", style: TextStyle(color: Colors.white),),
            ),
          ),
        ),
      ),
    );
  }
}
