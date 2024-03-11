import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vojo/HotelPaymentPage/HotelPaymentModel.dart';
import 'package:vojo/PaymentErrorPage/PaymentErrorPage.dart';
import 'package:vojo/StateManagment/StateManagment.dart';
import 'package:vojo/index.dart';
import 'package:vojo/backend/backend.dart';

class HotelPayment extends StatefulWidget {
  const HotelPayment({super.key});

  @override
  State<HotelPayment> createState() => _HotelPaymentState();
}

class _HotelPaymentState extends State<HotelPayment> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => HotelDetailsProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: Container(
              child: Column(
                children: [
                  Text("Price : ",),
                  Text("${context.watch<HotelDetailsProvider>().Price/100}"),
                  GestureDetector(
                    onTap: ()async{
                      bool nn =await HotelPaymentModle.MakeStrpePayment(Provider.of<HotelDetailsProvider>(context, listen: false).Price);
                      if(nn){
                        var res = await CreateBooking(uid: Provider.of<HotelDetailsProvider>(context, listen: false).userId, startDate: Provider.of<HotelDetailsProvider>(context, listen: false).startDate, endDate: Provider.of<HotelDetailsProvider>(context, listen: false).endDate, hotelName: Provider.of<HotelDetailsProvider>(context, listen: false).hotelName, hotelUserId: Provider.of<HotelDetailsProvider>(context, listen: false).hotelUserId, numberOfRooms: Provider.of<HotelDetailsProvider>(context, listen: false).numberOfRooms);
                        print(res.code);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPageWidget()));
                        final snackBar = SnackBar(
                            content: const Text('Payment is Successful!'),
                            backgroundColor: Color(0xFF311B92),
                            action: SnackBarAction(
                              label: 'Undo',
                              onPressed: () {
                                // Some code to undo the change.
                              },
                            ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      else{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentErrorPage()));
                      }
                      print(nn);

                    },
                    child: Container(
                      height: 50,
                      width: 200,
                      color: Colors.blue,
                      child: Text("Pay Now"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
