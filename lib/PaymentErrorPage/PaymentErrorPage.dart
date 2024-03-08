import 'package:flutter/material.dart';
import 'package:vojo/index.dart';

class PaymentErrorPage extends StatefulWidget {
  const PaymentErrorPage({super.key});

  @override
  State<PaymentErrorPage> createState() => _PaymentErrorPageState();
}

class _PaymentErrorPageState extends State<PaymentErrorPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: Center(
              child: Column(
                children: [
                  const Text("Payment Unsuccessful"),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPageWidget()));
                  }, child: const Text("Back to Home"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
