import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePayment {
  static String _secriteKey =
      "sk_test_51OSCmFCem4pjyRAz5OhZmED0AujarN6IZNC62KngWTVdffXTjlfHVLsZQNbsbA9hoJoZwnkyVWt7vECKjJ9bp1GQ00aeEzSmFa";
  static String _publishableKey =
      "pk_test_51OSCmFCem4pjyRAzDzsny1yS8fm8RQRjqQDNryrarztSx6kxpvty3SZMx3jaWcCE54pyo4Zmtv3DWMfzNa65V5HH00p1wiVzRu";
  static Map<String, dynamic>? _paymentIntent;

  Future<bool> makePayment(int price) async {
    try {
      _paymentIntent = await createPaymentIntent(price);
      print(_paymentIntent!['client_secret']);

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: _paymentIntent!['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: "Vojo Development"));
      return displayPaymentSheet();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true; // Payment successful
    } catch (e) {
      return false;
      throw Exception(e.toString());

    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent(int price) async {
    try {
      Map<String, dynamic> body = {"amount": "${price}", "currency": "USD"};
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            'Authorization': 'Bearer $_secriteKey',
            "Content-Type": "application/x-www-form-urlencoded"
          });
      print(json.decode(response.body));
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
