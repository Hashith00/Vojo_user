import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vojo/Conatants/Constans.dart';
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
  late double price;
  bool isPayButtonClicked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => HotelDetailsProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 15,),
                        Icon(Icons.add_circle, color: Colors.green,),
                        SizedBox(width: 15,),
                        DootedLineWidget(width: 100,),
                        SizedBox(width: 15,),
                        Icon(Icons.add_circle, color: Colors.green,),
                        SizedBox(width: 15,),
                        DootedLineWidget(width: 100,),
                        SizedBox(width: 15,),
                        Icon(Icons.add_circle, color: Colors.grey,),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 10,),
                        Text("Select", style: TextStyle(fontFamily: primaryFontFamilty),),

                       SizedBox(width: 100,),

                        Text("Cheackout"),
                        SizedBox(width: 110,),
                        Text("Pay"),
                      ],
                    ),
                    SizedBox(height: 40,),
                    Text("Booking Details", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 20, fontWeight: FontWeight.w700),),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Container(
                          height: 120,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage("${Provider.of<HotelDetailsProvider>(context, listen: false).hotelUrl}"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${Provider.of<HotelDetailsProvider>(context, listen: false).startDate}", style: TextStyle(fontSize: 14, fontFamily: primaryFontFamilty, color: Colors.grey),),
                            SizedBox(height: 3,),
                            Text("${Provider.of<HotelDetailsProvider>(context, listen: false).hotelName}", style: TextStyle(fontSize: 19, fontFamily: primaryFontFamilty, color: Colors.black),),
                            SizedBox(height: 15,),
                            Container(
                              child: Row(children: [
                                Icon(Icons.star, size: 15,color: Colors.amber,),
                                SizedBox(width: 3,),
                                Text("5.00"),
                                SizedBox(width: 3,),
                                Text("( 32 Reviews )"),

                              ],),
                            )
                          ],
                        ))
                      ],
                    ),
                    SizedBox(height: 20,),
                    Divider(thickness: 1,color: Colors.grey.shade300,),
                    SizedBox(height: 20,),
                    Text("Payment Details", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 20, fontWeight: FontWeight.w700),),
                    SizedBox(height: 20,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${Provider.of<HotelDetailsProvider>(context, listen: false).numberOfRooms} Night X  \$${context.watch<HotelDetailsProvider>().Price/(100 * Provider.of<HotelDetailsProvider>(context, listen: false).numberOfRooms)}", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey),),
                          Text("\$${context.watch<HotelDetailsProvider>().Price/100 }", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 16, fontWeight: FontWeight.w500,color: Colors.grey),),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sub Total (USD)", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),),
                          Text("\$${context.watch<HotelDetailsProvider>().Price/100 }", style: TextStyle(fontFamily: primaryFontFamilty, fontSize: 16, fontWeight: FontWeight.w500,color: Colors.black87),),
                        ],
                      ),
                    ),
                  SizedBox(height: 250,),
                    GestureDetector(
                      onTap: ()async{
                        setState(() {
                          isPayButtonClicked = true;
                        });
                        bool nn =await HotelPaymentModle.MakeStrpePayment(Provider.of<HotelDetailsProvider>(context, listen: false).Price.round());
                        if(nn){
                          var res = await CreateBooking(uid: Provider.of<HotelDetailsProvider>(context, listen: false).userId, startDate: Provider.of<HotelDetailsProvider>(context, listen: false).startDate, endDate: Provider.of<HotelDetailsProvider>(context, listen: false).endDate, hotelName: Provider.of<HotelDetailsProvider>(context, listen: false).hotelName, hotelUserId: Provider.of<HotelDetailsProvider>(context, listen: false).hotelUserId, numberOfRooms: Provider.of<HotelDetailsProvider>(context, listen: false).numberOfRooms,locationLat: Provider.of<HotelDetailsProvider>(context, listen: false).hotelLatitude, locationLng: Provider.of<HotelDetailsProvider>(context, listen: false).hotelLongitude, price: (Provider.of<HotelDetailsProvider>(context, listen: false).Price)/100, hotelPhotoUrl: Provider.of<HotelDetailsProvider>(context, listen: false).hotelUrl!,hotelLocation: Provider.of<HotelDetailsProvider>(context, listen: false).hotelLocation);
                          print(res.code);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => LandingPageWidget()));
                          final snackBar = SnackBar(
                              content: const Text('Payment is Successful!'),
                              backgroundColor: Color(0xFF311B92),
                              action: SnackBarAction(
                                label: 'Ok',
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
                      child: isPayButtonClicked == false ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryColor,
                        ),
                        height: 50,
                        width: double.infinity,

                        child: Center(child: Text("Pay \$${context.watch<HotelDetailsProvider>().Price/100 }", style: TextStyle(color: Colors.white, fontFamily: primaryFontFamilty, fontSize: 18),)),
                      ) :
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0x76311B92),
                        ),
                        height: 50,
                        width: double.infinity,

                        child: Center(child: Text("Paying ...", style: TextStyle(color: Colors.white, fontFamily: primaryFontFamilty, fontSize: 18),)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//
class DootedLineWidget extends StatelessWidget {
  final double width;
  const DootedLineWidget({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final boxWidth = constraints.constrainWidth();
          const dashWidth = 10.0;
          final dashHeight = 1;
          final dashCount = (1.5*boxWidth / (2 * dashWidth)).floor();
          return Flex(
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashWidth,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                ),
              );
            }),
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            direction: Axis.horizontal,
          );
        },
      ),
    );
  }
}
