import 'package:flutter/material.dart';
import 'package:vojo/DateSelector_page/DateSelectorEnd_page.dart';
import 'package:vojo/DateSelector_page/DateSelector_page.dart';
import 'package:vojo/backend/backend.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:vojo/index.dart';

class EditTrip extends StatefulWidget {
  const EditTrip({Key? key, required this.id}) : super(key: key);

  final String id;


  @override
  State<EditTrip> createState() => _EditTripState();
}

class _EditTripState extends State<EditTrip> {
  var startLocation;
  var endLocation;
  var startDate;
  var endDate;
  var tripDetails;
  TextEditingController contoller = TextEditingController();
  gettrip() async {
    tripDetails = await getTripDetails(docId: widget.id);
    if(tripDetails['start_location'] != null){
      setState(() {
        startLocation = tripDetails['start_location'];
        endLocation = tripDetails['end_location'];
        startDate = tripDetails['start_date'];
        endDate = tripDetails['end_date'];
      });
    };
  }

  OpenDialogBoxStr() =>showDialog(context: context, builder: (context)=>AlertDialog(
    title: Text("Change Start Location"),
    content: TextField(
      controller: contoller,
      decoration: InputDecoration(hintText: 'Enter New Start Location'),
    ),
    actions: [
      TextButton(onPressed: ()async{
        Response res = Response();
        print(contoller.text);
        res = await updateTripStartLocation(docId: widget.id, startLocation: contoller.text);
        if(res.code == 200){
          Navigator.of(context).pop();
        }
  }, child: Text("Save"))
    ],
  ));

  OpenDialogBoxEnd() =>showDialog(context: context, builder: (context)=>AlertDialog(
    title: Text("Change Start Location"),
    content: TextField(
      controller: contoller,
      decoration: InputDecoration(hintText: 'Enter New Ending Location'),
    ),
    actions: [
      TextButton(onPressed: ()async{
        Response res = Response();
        print(contoller.text);
        res = await updateTripEndLocation(docId: widget.id, endLocation: contoller.text);
        if(res.code == 200){
          Navigator.of(context).pop();
        }
      }, child: Text("Save"))
    ],
  ));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettrip();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            color: Colors.grey.shade100,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Text(
                              "Your Journey",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,

                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade400),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.grey.shade600),
                                child: Center(
                                    child: Text(
                                  "H",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                )),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Hashith Sithuruwan",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Passenger",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    alignment: Alignment.topCenter,
                                    image: AssetImage("assets/images/car.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                height: 100,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        child: GestureDetector(
                                          onTap: (){
                                            OpenDialogBoxStr();
                                          },
                                          child: Column(
                                            children: [
                                              Text(
                                                "$startLocation",
                                                style: TextStyle(
                                                    color: Colors.orange,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Text(
                                                "Start",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                          ),
                                        ),
                                      ),
                                      Column(children: [
                                        Container(
                                          alignment: Alignment.topCenter,
                                          height: 30,
                                          width: 50,
                                          child:
                                              Image.asset('assets/images/car.png'),
                                        ),
                                        Text("1h 10m", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),)
                                      ]),
                                      GestureDetector(
                                        onTap: (){
                                          OpenDialogBoxEnd();
                                        },
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "$endLocation",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Text(
                                                "End",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                height: 100,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) =>  DateSelector(id: widget.id),
                                          ),);
                                        },
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "$startDate",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Text(
                                                "Starting Date",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (context) =>  DateSelectorEnd(id: widget.id),
                                          ),);
                                          // Chaing the End date
                                        },
                                        child: Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "$endDate",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              Text(
                                                "Ending Date",
                                                style: TextStyle(
                                                    color: Colors.black54,
                                                    fontSize: 13),
                                              ),
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue
                    ),
                    child: Center(child: Text("save", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),),
                  ),
                  GestureDetector(
                    onTap: (){

                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>  LandingPageWidget(),
                      ),);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 50,
                      width: 350,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red.shade100
                      ),
                      child: Center(child: Text("Delete Ticket", style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w600),),),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: AssetImage("assets/images/cargif.gif"),
                        fit: BoxFit.cover,
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
