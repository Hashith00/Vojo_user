import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vojo/Conatants/Constans.dart';
import 'package:vojo/PaymentErrorPage/PaymentErrorPage.dart';
import 'package:vojo/RiderPaymentPage/RiderPaymentModel.dart';
import 'package:vojo/StateManagment/StateManagment.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:vojo/index.dart';
import 'package:vojo/backend/backend.dart';
import 'package:dio/dio.dart';
import 'package:vojo/utils/Payment.dart';

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
   var intermidiareLocation;
   var calculatedCost;
   var response;
   var returnResponse;
   var distanceUsingIntermidiate;
   var downTripTime;


   Future<void> getDetails() async {
     try {
       final provider = Provider.of<RiderDetailsProvider>(context, listen: false);
       final dio = Dio();

       var response;
       var returnResponse;

       if (provider.intermediateLocation.isEmpty) {
         response = await dio.get(
           'https://maps.googleapis.com/maps/api/distancematrix/json',
           queryParameters: {
             'destinations': '${provider.endLocationLatitude},${provider.endLocationLongitude}',
             'origins': '${provider.startLocationLatitude},${provider.startLocationLongitude}',
             'key': 'AIzaSyC8XOXvvxImxyxY6dFnOKIMTlbOM3X58Yw',
           },
         );
       } else {
         response = await dio.get(
           'https://maps.googleapis.com/maps/api/distancematrix/json',
           queryParameters: {
             'destinations': '${provider.intermediateLocationLatitude},${provider.intermediateLocationLongitude}',
             'origins': '${provider.startLocationLatitude},${provider.startLocationLongitude}',
             'key': 'AIzaSyC8XOXvvxImxyxY6dFnOKIMTlbOM3X58Yw',
           },
         );

         returnResponse = await dio.get(
           'https://maps.googleapis.com/maps/api/distancematrix/json',
           queryParameters: {
             'destinations': '${provider.endLocationLatitude},${provider.endLocationLongitude}',
             'origins': '${provider.intermediateLocationLatitude},${provider.intermediateLocationLongitude}',
             'key': 'AIzaSyC8XOXvvxImxyxY6dFnOKIMTlbOM3X58Yw',
           },
         );
       }

       if (response.statusCode == 200 && (returnResponse == null || returnResponse.statusCode == 200)) {
         final responseData = response.data;
         final returnResponseData = returnResponse?.data;

         String distanceText = responseData['rows'][0]['elements'][0]['distance']['text'];
         String duration = responseData['rows'][0]['elements'][0]['duration']['text'];
         String downTripTime = returnResponseData != null ? returnResponseData['rows'][0]['elements'][0]['duration']['text'] : "";

         int distanceUsingIntermediate;
         if (provider.intermediateLocation.isEmpty) {
           distanceUsingIntermediate = responseData['rows'][0]['elements'][0]['duration']['value'];
         } else {
           distanceUsingIntermediate = responseData['rows'][0]['elements'][0]['duration']['value'] + returnResponseData['rows'][0]['elements'][0]['duration']['value'];
         }

         setState(() {
           distanceInKM = distanceText;
           durationTime = duration;
           distance = distanceUsingIntermediate / 1000; // Assuming 'distance' is in meters
           calculatedCost = PaymentProcess.getThePriceInDollers(
               distance: distanceUsingIntermediate / 1000,
               vehicleType: "car",
               startDate: provider.startDate,
               endDate: provider.endDate
           );
           cost = calculatedCost.toInt();
           isCostCalculated = true;
           intermidiareLocation = provider.intermediateLocation;
         });
       } else {
         print("Error: ${response.statusCode} ${response.statusMessage}");
         if (returnResponse != null) {
           print("Error: ${returnResponse.statusCode} ${returnResponse.statusMessage}");
         }
       }
     } catch (e) {
       print(e);
     }
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
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Color(0xFFFAF9F6),
            title: Center(child: Text("Confirm & Pay", style: TextStyle(color: Colors.black,fontSize: 14, fontFamily: primaryFontFamilty),)),
            leading:
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black,),
                tooltip: 'Back',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

          ),
          body: SafeArea(
            child: Container(
              color: Color(0xFFFAF9F6),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: isCostCalculated? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Journey Method", style: TextStyle(color: Colors.black,fontSize: 19, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w700)),
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.all(15),
                    height: 150,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                          width: 120.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage("https://t3.ftcdn.net/jpg/04/49/73/64/360_F_449736488_IAGo58o7DloC8Os5S5v9vppX3BIxzK4S.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 15,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Start Location", style: TextStyle(fontFamily: primaryFontFamilty, fontWeight: FontWeight.w600),),
                            Text("${Provider.of<RiderDetailsProvider>(context, listen: false).startLocation}", style: TextStyle(color: Colors.black54),),
                            intermidiareLocation != "" ?
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10,),
                                    Text("Intermidiate Location", style: TextStyle(fontFamily: primaryFontFamilty, fontWeight: FontWeight.w600),),
                                    Text("${Provider.of<RiderDetailsProvider>(context, listen: false).intermediateLocation}"),
                                  ],
                                ) : Container(),
                            SizedBox(height: 10,),
                            Text("End Location", style: TextStyle(fontFamily: primaryFontFamilty, fontWeight: FontWeight.w600),),
                            Text("${Provider.of<RiderDetailsProvider>(context, listen: false).endLocation}"),

                          ],
                        ))
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Trip Details", style: TextStyle(color: Colors.black,fontSize: 18, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w700)),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Distance ", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 15),),
                            Text("$distance km", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 15),),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Up Trip Time ", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 15),),
                            Text("$durationTime ", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 15),)
                          ],
                        ),
                        SizedBox(height: 10,),
                        downTripTime != null ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Down Trip Time ", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 15),),
                            Text("$downTripTime ", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 15),)
                          ],
                        ) : Container(),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Payment Details", style: TextStyle(color: Colors.black,fontSize: 18, fontFamily: primaryFontFamilty, fontWeight: FontWeight.w700)),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Payment for Trip ", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 15),),
                            Text( " $cost USD", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 15),)
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Discounts ", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 15),),
                            Text( " 0 USD", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 15),)
                          ],
                        ),
                        SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Total Payment", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 16, fontWeight: FontWeight.w700),),
                            Text( " $cost USD", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 15, fontWeight: FontWeight.w700),)
                          ],
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 80,),
                  GestureDetector(
                    onTap: ()async{
                      bool nn =await RiderPaymentModel.MakeStripePayment(cost*100);
                      if(nn){
                        var responce = await addTrip(uid: Provider.of<RiderDetailsProvider>(context, listen: false).userId, type: Provider.of<RiderDetailsProvider>(context, listen: false).mode, startDate: Provider.of<RiderDetailsProvider>(context, listen: false).startDate, endDate: Provider.of<RiderDetailsProvider>(context, listen: false).endDate, startLocation: Provider.of<RiderDetailsProvider>(context, listen: false).startLocation, endLocation: Provider.of<RiderDetailsProvider>(context, listen: false).endLocation, riderId: Provider.of<RiderDetailsProvider>(context, listen: false).riderId, travellingMode:Provider.of<RiderDetailsProvider>(context, listen: false).vehicle , cost: cost, distance: distance, startLocationLatitude: Provider.of<RiderDetailsProvider>(context, listen: false).startLocationLatitude, startLocationLongitude: Provider.of<RiderDetailsProvider>(context, listen: false).startLocationLongitude, endLocationLatitude: Provider.of<RiderDetailsProvider>(context, listen: false).endLocationLatitude, endLocationLongitude: Provider.of<RiderDetailsProvider>(context, listen: false).endLocationLongitude, duration: durationTime, intermidiateLocation: Provider.of<RiderDetailsProvider>(context, listen: false).intermediateLocation, intermediateLocationLatitude: Provider.of<RiderDetailsProvider>(context, listen: false).intermediateLocationLatitude, intermediateLocationLongitude: Provider.of<RiderDetailsProvider>(context, listen: false).intermediateLocationLongitude);
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF311B92),
                      ),

                      child: Center(child: Text("Confirm & Pay $cost USD", style: TextStyle(color: Colors.white),),),
                    ),
                  )



                ],
              ) : Center(
                child: Container(
                  height: 100,
                 width: double.infinity,
                  child: const LoadingIndicator(
                      indicatorType: Indicator.ballPulse,
                      colors: [Color(0xFF311B92)],
                      strokeWidth: 2,
                      backgroundColor: Colors.white,
                      pathBackgroundColor: Colors.black
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentDetailsWidget extends StatelessWidget {
  const PaymentDetailsWidget({
    super.key,
    required this.distanceInKM,
    required this.cost,
    required this.distance,
    required this.durationTime,
  });

  final  distanceInKM;
  final int cost;
  final  distance;
  final  durationTime;

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
