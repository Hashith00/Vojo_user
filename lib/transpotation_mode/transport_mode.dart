import 'package:flutter/material.dart';
import 'package:vojo/StateManagment/StateManagment.dart';
import 'package:vojo/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:vojo/rider_list_page/rider_list_page.dart';

var selectedMode;
class TransportModePage extends StatefulWidget {
  const TransportModePage({super.key});

  @override
  State<TransportModePage> createState() => _TransportModePageState();
}

class _TransportModePageState extends State<TransportModePage> {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RiderDetailsProvider())
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF311B92),
          title: const Text('Select your transport'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          elevation: 5.0,
        ),
        body: Column(
          children: [
            const SizedBox(height: 50.0),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Select your transport type',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                padding: const EdgeInsets.all(16.0),
                children: [
                  GestureDetector(
                    child: buildButton('bicycle', 'assets/images/cycle.png'),
                    onTap: () async{

                    },
                  ),
                  GestureDetector(
                    child: buildButton('bike', 'assets/images/bike.png'),
                    onTap: () {

                    },
                  ),
                  GestureDetector(
                    child: buildButton('car', 'assets/images/car.png'),
                    onTap: () {

                    },
                  ),
                  GestureDetector(
                    child: buildButton('van', 'assets/images/van.png'),
                    onTap: () {

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String buttonText, String imagePath) {
    return ElevatedButton(
      onPressed: ()async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final String? action = prefs.getString('docId');


        final SharedPreferences prefsin = await SharedPreferences.getInstance();
        await prefsin.setString('transportMode', buttonText);
        String docId = "";
        if(action != null){
          docId = action;
        }
        print(action);
        switch(buttonText) {
          case "bicycle":
            setState(() {
              selectedMode = "push_bike";
            });
            break; // The switch statement must be told to exit, or it will execute every case.
          case "bike":
            setState(() {
              selectedMode = "moter_bike";
            });
            break;
          case "car":
            setState(() {
              selectedMode = "car";
            });
            break;
          case "van":
            setState(() {
              selectedMode = "van";
            });
            break;
          default:
            print('choose a different number!');
        }
        print(selectedMode);
        Provider.of<RiderDetailsProvider>(context, listen: false).changeVehicle(selectedVehicle: selectedMode);
        //var responce  = await updateTravellingMode(travallingMode: selectedMode, docId: docId);
        //print(responce);
        Navigator.push(context, MaterialPageRoute(builder: (context) => RidersListPage()));

      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        minimumSize: const Size(150.0, 150.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
            color: Color(0xFF311B92),
            width: 2.0,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 80.0,
            height: 80.0,
          ),
          const SizedBox(height: 8.0),
          Text(
            buttonText,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
