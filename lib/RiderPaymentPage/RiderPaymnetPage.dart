import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vojo/PaymentErrorPage/PaymentErrorPage.dart';
import 'package:vojo/RiderPaymentPage/RiderPaymentModel.dart';
import 'package:vojo/StateManagment/StateManagment.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:vojo/index.dart';
import 'package:vojo/backend/backend.dart';

class RiderPaymentPage extends StatefulWidget {
  const RiderPaymentPage({super.key});

  @override
  State<RiderPaymentPage> createState() => _RiderPaymentPageState();
}

class _RiderPaymentPageState extends State<RiderPaymentPage> {
   double distance = 0.0;
   double cost = 0;
   bool isCostCalculated = false;


  getDetails()async{
    double dis = await RiderPaymentModel.calculateDistance(StartLocation: Provider.of<RiderDetailsProvider>(context, listen: false).startLocation, EndLocation: Provider.of<RiderDetailsProvider>(context, listen: false).endLocation);
    setState(() {
      if(dis != 0.0)  distance = dis;
          cost = RiderPaymentModel.calculateCost(TransportationMode: "car", distance: distance);
          isCostCalculated = true;
    });

  }

  @override
  void initState() {
    super.initState();
    getDetails();

  }
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RiderDetailsProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("Start Location : ${Provider.of<RiderDetailsProvider>(context, listen: false).startLocation}"),
                      SizedBox(width: 40,),
                      Text("End Location : ${Provider.of<RiderDetailsProvider>(context, listen: false).endLocation}")
                    ],
                  ),
                  Container(
                    child: isCostCalculated ? Column(
                      children: [
                        const SizedBox(height: 30,),
                        Text("Total Distance : $distance"),
                        const SizedBox(height: 30,),
                        Text("Total Cost : $cost"),
                        const SizedBox(height: 30,),
                        GestureDetector(
                          onTap: ()async{
                            bool nn =await RiderPaymentModel.MakeStripePayment(cost*100);
                            if(nn){
                              var responce = await addTrip(uid: Provider.of<RiderDetailsProvider>(context, listen: false).userId, type: Provider.of<RiderDetailsProvider>(context, listen: false).mode, startDate: Provider.of<RiderDetailsProvider>(context, listen: false).startDate, endDate: Provider.of<RiderDetailsProvider>(context, listen: false).endDate, startLocation: Provider.of<RiderDetailsProvider>(context, listen: false).startLocation, endLocation: Provider.of<RiderDetailsProvider>(context, listen: false).endLocation, riderId: Provider.of<RiderDetailsProvider>(context, listen: false).riderId, travellingMode:Provider.of<RiderDetailsProvider>(context, listen: false).vehicle );
                              print(responce);
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
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentErrorPage()));
                            }

                          },
                          child: Container(
                            height: 50,
                            width: 100,
                            color: Color(0xFF311B92),
                            child: Center(child: Text("Pay Now", style: TextStyle(color: Colors.white),),),
                          ),
                        )
                      ],
                    ) : Container(
                      height: 100,
                      width: 100,
                      child: const LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          colors: [Color(0xFF311B92)],
                          strokeWidth: 2,
                          backgroundColor: Colors.white,
                          pathBackgroundColor: Colors.black
                      ),
                    ),
                  ),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
