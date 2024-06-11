import 'package:flutter/material.dart';
import 'package:vojo/Conatants/Constans.dart';
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 300),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.red
                      ),
                      child: Icon(Icons.close, size: 25, color: Colors.white,)),
                  const Text("Payment Unsuccessful", style: TextStyle(fontSize: 25, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w500),),
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
