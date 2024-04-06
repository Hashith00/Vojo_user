import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vojo/PaymentErrorPage/PaymentErrorPage.dart';
import 'package:vojo/RiderPaymentPage/RiderPaymentModel.dart';
import 'package:vojo/StateManagment/StateManagment.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:vojo/index.dart';
import 'package:vojo/backend/backend.dart';
import 'package:dio/dio.dart';

class RiderPaymentPage extends StatefulWidget {
  const RiderPaymentPage({super.key});

  @override
  State<RiderPaymentPage> createState() => _RiderPaymentPageState();
}

class _RiderPaymentPageState extends State<RiderPaymentPage> {
   var distanceInKM ;
   var distance;
   int cost = 0 ;
   var durationTime;
   bool isCostCalculated = false;


  getDetails()async{
    try {
      var response = await Dio().get('https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${Provider.of<RiderDetailsProvider>(context, listen: false).endLocationLatitude},${Provider.of<RiderDetailsProvider>(context, listen: false).endLocationLongitude}&origins=${Provider.of<RiderDetailsProvider>(context, listen: false).startLocationLatitude},${Provider.of<RiderDetailsProvider>(context, listen: false).startLocationLongitude}&key=AIzaSyC8XOXvvxImxyxY6dFnOKIMTlbOM3X58Yw');
      Map<String, dynamic> responseData = response.data;


      String distanceText = responseData['rows'][0]['elements'][0]['distance']['text'];
      String duration = responseData['rows'][0]['elements'][0]['duration']['text'];
      var distance2 = responseData['rows'][0]['elements'][0]['duration']['value'];
      print(distanceText);
      print(duration);

      setState(() {
        distanceInKM = distanceText;
        durationTime = duration;
        distance = distance2 / 1000;
        cost = (distance * 10).toInt();
        isCostCalculated = true;
      });

    } catch (e) {
      print(e);
    }

  }

  @override
  void initState() {
    super.initState();
    getDetails();
    setState(() {
    });

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
                        Text("Total Distance : $distanceInKM"),
                        const SizedBox(height: 30,),
                        Text("Total Cost : $cost LKR"),
                        const SizedBox(height: 30,),
                        GestureDetector(
                          onTap: ()async{
                            bool nn =await RiderPaymentModel.MakeStripePayment(cost*100);
                            if(nn){
                              var responce = await addTrip(uid: Provider.of<RiderDetailsProvider>(context, listen: false).userId, type: Provider.of<RiderDetailsProvider>(context, listen: false).mode, startDate: Provider.of<RiderDetailsProvider>(context, listen: false).startDate, endDate: Provider.of<RiderDetailsProvider>(context, listen: false).endDate, startLocation: Provider.of<RiderDetailsProvider>(context, listen: false).startLocation, endLocation: Provider.of<RiderDetailsProvider>(context, listen: false).endLocation, riderId: Provider.of<RiderDetailsProvider>(context, listen: false).riderId, travellingMode:Provider.of<RiderDetailsProvider>(context, listen: false).vehicle , cost: cost, distance: distance, startLocationLatitude: Provider.of<RiderDetailsProvider>(context, listen: false).startLocationLatitude, startLocationLongitude: Provider.of<RiderDetailsProvider>(context, listen: false).startLocationLongitude, endLocationLatitude: Provider.of<RiderDetailsProvider>(context, listen: false).endLocationLatitude, endLocationLongitude: Provider.of<RiderDetailsProvider>(context, listen: false).endLocationLongitude, duration: durationTime);
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
