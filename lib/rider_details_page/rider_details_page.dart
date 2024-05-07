import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vojo/RiderPaymentPage/RiderPaymnetPage.dart';
import 'package:vojo/StateManagment/StateManagment.dart';
import 'package:vojo/backend/backend.dart';
import 'package:provider/provider.dart';


const IconData battery = IconData(0xe0d1, fontFamily: 'MaterialIcons');
const IconData fuel = IconData(0xea8e, fontFamily: 'MaterialIcons');
const IconData speed = IconData(0xe5e0, fontFamily: 'MaterialIcons');
const IconData time = IconData(0xee2d, fontFamily: 'MaterialIcons');

class RidersBookingPage extends StatefulWidget {

  var vehicleDeatils;


  RidersBookingPage({super.key, required this.vehicleDeatils});

  @override
  State<RidersBookingPage> createState() => _RidersBookingPageState();
}

class _RidersBookingPageState extends State<RidersBookingPage> {
  var rider;
  var docid;
  late String dirverName;
  late String dirverLocation;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Get Doc Id of the trip
    void GetdocId()async{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? docId = prefs.getString('docId');
      print(docId);
      docid = docId;
    }

    // getting the rider details using the rider_id
    void getMassages()async{
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final employees =  await _firestore.collection("serviceUser").get();
      for(var massage in employees.docs){
        if(massage.data()["uid"] == widget.vehicleDeatils["rider_id"]){
          setState(() {
            rider = massage.data();
          });

          break;
        }
        //print(massage.data()["uid"].runtimeType);
      }
      //print(rider["display_name"]);
      //print("Whated Uid is ${widget.vehicleDeatils["rider_id"].runtimeType}");
    }
    getMassages();
    GetdocId();
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RiderDetailsProvider())
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.fromLTRB(5, 10, 10, 20),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.grey.shade200
                  ),
                  child: Icon(Icons.arrow_back, color: Colors.black87,),

                ),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
               Text(
                '${widget.vehicleDeatils["brand"]} ${widget.vehicleDeatils["model"]}',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              const Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ),
                  Text('4.2'),
                  SizedBox(width: 10.0),
                  Text('(378 Reviews)'),
                ],
              ),
              const SizedBox(height: 16.0),
              Image.asset(
                "assets/images/car_tesla.png",
                height: 160.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Specifications',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildBoxShort(
                    'Engine ',
                    '${widget.vehicleDeatils["capaity"]}',
                    battery,
                  ),
                  buildBoxShort(
                    'Fuel',
                    '${widget.vehicleDeatils["fuel_type"]}',
                    fuel,
                  ),
                  buildBoxShort(
                    'Max Speed',
                    '230kph',
                    speed,
                  ),

                ],
              ),
              const SizedBox(height: 25.0),
              const Text(
                'Features',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16.0),
              Column(
                children: [
                  buildBoxLong('Brand', '${widget.vehicleDeatils["brand"]}'),
                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 20,
                    endIndent: 0,
                    color: Colors.grey,
                  ),
                  buildBoxLong('Color', '${widget.vehicleDeatils["color"]}'),
                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 20,
                    endIndent: 0,
                    color: Colors.grey,
                  ),
                  buildBoxLong('Vehicle Number', '${widget.vehicleDeatils["vehicle_no"]}'),
                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 20,
                    endIndent: 0,
                    color: Colors.grey,
                  ),
                  buildBoxLong('Passengers', '${widget.vehicleDeatils["max_passenger"]}'),
                ],
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Driver Details',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
               Row(
                children: [
                  const SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://vmnts.com/nueva/wp-content/uploads/2019/01/person6.jpg'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${rider?['display_name']}',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                              Text('${rider?['phone_number']}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Text('4.9'),
                              SizedBox(width: 10.0),
                              Text('(531 Reviews)'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 150.0,
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF311B92),
                        padding: const EdgeInsets.all(12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150.0,
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: () async {
                        Provider.of<RiderDetailsProvider>(context, listen: false).chageRiderId(selectedRiderId: widget.vehicleDeatils["rider_id"]);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RiderPaymentPage()));
                        //Navigator.pushNamed(context, "/landing");

                      },
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF311B92),
                        padding: const EdgeInsets.all(12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Book',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildBoxLong(String label, String text) {
  return Container(
    width: 500,
    height: 50,
    margin: const EdgeInsets.all(2.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
    ),
    child: Row(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                label,
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                text,
                style: const TextStyle(fontSize: 18.0),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildBoxShort(String label, String text, IconData iconData) {
  return Container(
    width: 90,
    height: 90,
    margin: const EdgeInsets.all(2.0),
    decoration: BoxDecoration(

      borderRadius: BorderRadius.circular(5),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12.0),
        ),
        const SizedBox(height: 4.0),
        Icon(
          iconData,
          size: 24.0,
          color: const Color(0xFF311B92),
        ),
        const SizedBox(height: 4.0),
        Text(
          text,
          style: const TextStyle(fontSize: 12.0),
        ),
      ],
    ),
  );
}
