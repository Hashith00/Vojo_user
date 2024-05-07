import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vojo/Conatants/Constans.dart';
import 'package:vojo/LocationSearchPage/LocationSearchPage.dart';
import 'package:vojo/StateManagment/StateManagment.dart';
import 'package:vojo/backend/backend.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vojo/transpotation_mode/transport_mode.dart';
import 'package:provider/provider.dart';
import 'package:geocode/geocode.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class PickLocationPage extends StatefulWidget {
  @override
  _PickLocationPageState createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage>
    with SingleTickerProviderStateMixin {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  late TabController _tabController;
  var _startLocation = '';
  var _endlocation = '';
  var _intermidatelocation = '';

  // Setting variable fot the current user details
  var userData;
  var _auth = FirebaseAuth.instance;
  var user;
  var name = "";
  var uid = '';

  // Get the current user
  getCurrentUer() async {
    try {
      user = _auth.currentUser;
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      CollectionReference users = _firestore.collection('users');
      DocumentSnapshot snapshot = await users.doc(user!.uid).get();
      userData = snapshot.data() as Map<String, dynamic>;
      setState(() {
        name = userData['display_name'];
        uid = userData['uid'];
        print(uid);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<LatLng> getLocation({required String location}) async {
    GeoCode geoCode = GeoCode(apiKey: "391946589145416636710x64221");
    late LatLng pos;

    try {
      Coordinates usercoordinate =
          await geoCode.forwardGeocoding(address: location);
      pos = LatLng((usercoordinate.latitude)!.toDouble(),
          (usercoordinate.longitude)!.toDouble());
    } catch (e) {
      print(e);
    }
    return pos;
  }

  String splitString(string) {
    final splitted = string.split(' ');
    return (splitted[0]);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    getCurrentUer();
    print(_auth.currentUser?.uid);
    _startLocationContollerForReturnTrip = TextEditingController();
    _intermidatelocationControllerForReturnTrip = TextEditingController();
    _endlocationControllerForReturnTrip = TextEditingController();
    _startLocationContollerForOnewayTrip = TextEditingController();
    _endlocationControllerForOnewayTrip = TextEditingController();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );

    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  bool _saving = false;
  late TextEditingController _startLocationContollerForReturnTrip;
  late TextEditingController _intermidatelocationControllerForReturnTrip;
  late TextEditingController _endlocationControllerForReturnTrip;
  late TextEditingController _startLocationContollerForOnewayTrip;
  late TextEditingController _endlocationControllerForOnewayTrip;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RiderDetailsProvider())
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF311B92),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Return Trip'),
              Tab(text: 'One Way Trip'),
            ],
          ),
        ),
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          color: Colors.black,
          blur: 3.5,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Return Trip
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage("https://i.stack.imgur.com/qDhQR.png"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Start Date
                          Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text('Start Date'),
                                const SizedBox(width: 16.0),
                                GestureDetector(
                                  onTap: () => _selectStartDate(context),
                                  child: Container(
                                    height: 40.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        const Icon(
                                          Icons.calendar_today,
                                          color: Color(0xFF311B92),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6.0),

                          // End Date
                          Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text('End Date'),
                                const SizedBox(width: 16.0),
                                GestureDetector(
                                  onTap: () => _selectEndDate(context),
                                  child: Container(
                                    height: 40.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        const Icon(
                                          Icons.calendar_today,
                                          color: primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6.0),

                          // Start Time
                          Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text('Start Time'),
                                const SizedBox(width: 16.0),
                                GestureDetector(
                                  onTap: () => _selectStartTime(context),
                                  child: Container(
                                    height: 40.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '${_startTime.hour}:${_startTime.minute}',
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                        const Icon(
                                          Icons.access_time,
                                          color: Color(0xFF311B92),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100.0),

                          // Form
                          Form(
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                // Set the background color to cyan
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8.0),
                                  TextFormField(
                                    onTap: () async {
                                      final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LocationSearchPage()));
                                      setState(() {
                                        _startLocationContollerForReturnTrip
                                            .text = result;
                                        _startLocation = result;
                                      });
                                    },
                                    controller:
                                        _startLocationContollerForReturnTrip,
                                    decoration: const InputDecoration(
                                      labelText: 'Start Destination',
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    onChanged: (context) {},
                                  ),
                                  const SizedBox(height: 8.0),
                                  TextFormField(
                                    onTap: () async {
                                      final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LocationSearchPage()));
                                      setState(() {
                                        _intermidatelocationControllerForReturnTrip
                                            .text = result;
                                        _intermidatelocation = result;
                                      });
                                    },
                                    controller:
                                        _intermidatelocationControllerForReturnTrip,
                                    decoration: const InputDecoration(
                                      labelText: 'Intermediate Destination',
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    onChanged: (context) {},
                                  ),
                                  const SizedBox(height: 8.0),
                                  TextFormField(
                                    onTap: () async {
                                      final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LocationSearchPage()));
                                      setState(() {
                                        _endlocationControllerForReturnTrip
                                            .text = result;
                                        _endlocation = result;
                                      });
                                    },
                                    controller:
                                        _endlocationControllerForReturnTrip,
                                    decoration: const InputDecoration(
                                      labelText: 'End Destination',
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    onChanged: (context) {},
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 15.0),

                          // Confirm Button
                          Center(
                            child: SizedBox(
                              width: 350.0,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _saving = true;
                                  });
                                  if (_startDate.compareTo(DateTime.now()) ==
                                          1 &&
                                      _endDate.compareTo(DateTime.now()) == 1 &&
                                      _startLocation != "" &&
                                      _endlocation != "" &&
                                      _intermidatelocation != "") {
                                    print(splitString(_startDate.toString()));
                                    print(splitString(_endDate.toString()));
                                    print((_auth.currentUser?.uid).toString());

                                    LatLng startPos = await getLocation(
                                        location: _startLocation);
                                    LatLng endPos = await getLocation(
                                        location: _endlocation);
                                    LatLng interPos = await getLocation(
                                        location: _intermidatelocation);
                                    print(startPos.longitude);

                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeStartLocationLat(
                                            StartCor: startPos.latitude);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeStartLocationLng(
                                            StartCor: startPos.longitude);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeEndLocationLat(
                                            EndCor: endPos.latitude);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeEndLocationLng(
                                            EndCor: endPos.longitude);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeIntermediateLocationLat(
                                            InterCor: interPos.latitude);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeIntermediateLocationLng(
                                            InterCor: interPos.longitude);

                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeStartLocation(
                                            start: _startLocation);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .chageEndLocation(end: _endlocation);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeIntermediateLocation(
                                            midLocation: _intermidatelocation);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeStartDate(
                                            startD: splitString(
                                                _startDate.toString()));
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeEndDate(
                                            endD: splitString(
                                                _endDate.toString()));
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeMode(modeOfTheTrip: "two_way");
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeUserId(
                                            userID: (_auth.currentUser?.uid)
                                                .toString());

                                    setState(() {
                                      _saving = false;
                                    });
                                    // print(res);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransportModePage()));

                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString('docId', "res");
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            const Text('Enter correct details'),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {
                                            // Code to execute.
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                ),
                                child: const Text(
                                  'Next',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // One Way Trip
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            NetworkImage("https://i.stack.imgur.com/qDhQR.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ]),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Start Date
                          Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text('Start Date'),
                                const SizedBox(width: 16.0),
                                GestureDetector(
                                  onTap: () => _selectStartDate(context),
                                  child: Container(
                                    height: 40.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const Icon(
                                          Icons.calendar_today,
                                          color: Color(0xFF311B92),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6.0),

                          // End Date
                          Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text('End Date'),
                                const SizedBox(width: 16.0),
                                GestureDetector(
                                  onTap: () => _selectEndDate(context),
                                  child: Container(
                                    height: 40.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const Icon(
                                          Icons.calendar_today,
                                          color: Color(0xFF311B92),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6.0),

                          // Start Time
                          Container(
                            margin: EdgeInsets.all(5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Text('Start Time'),
                                const SizedBox(width: 16.0),
                                GestureDetector(
                                  onTap: () => _selectStartTime(context),
                                  child: Container(
                                    height: 40.0,
                                    width: 200.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '${_startTime.hour}:${_startTime.minute}',
                                          style: const TextStyle(fontSize: 16.0),
                                        ),
                                        const Icon(
                                          Icons.access_time,
                                          color: Color(0xFF311B92),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 140.0),

                          // Form
                          Form(
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(

                                    // Set the background color to cyan
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  const SizedBox(height: 8.0),
                                  TextFormField(
                                    onTap: () async {
                                      final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LocationSearchPage()));
                                      setState(() {
                                        _startLocationContollerForOnewayTrip
                                            .text = result;
                                        _startLocation = result;
                                      });
                                    },
                                    controller:
                                        _startLocationContollerForOnewayTrip,
                                    decoration: const InputDecoration(
                                      labelText: 'Start Destination',
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    onChanged: (context) {},
                                  ),
                                  const SizedBox(height: 8.0),
                                  TextFormField(
                                    onTap: () async {
                                      final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LocationSearchPage()));
                                      setState(() {
                                        _endlocationControllerForOnewayTrip.text =
                                            result;
                                        _endlocation = result;
                                      });
                                    },
                                    controller:
                                        _endlocationControllerForOnewayTrip,
                                    decoration: const InputDecoration(
                                      labelText: 'End Destination',
                                      fillColor: Colors.white,
                                      filled: true,
                                    ),
                                    onChanged: (context) {},
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16.0),

                          // Confirm Button
                          Center(
                            child: SizedBox(
                              width: 350.0,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _saving = true;
                                  });
                                  if (_startDate.compareTo(DateTime.now()) == 1 &&
                                      _endDate.compareTo(DateTime.now()) == 1 &&
                                      _startLocation != "" &&
                                      _endlocation != "") {
                                    print(splitString(_startDate.toString()));
                                    print(splitString(_endDate.toString()));

                                    LatLng startPos = await getLocation(
                                        location: _startLocation);
                                    LatLng endPos =
                                        await getLocation(location: _endlocation);

                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeStartLocationLat(
                                            StartCor: startPos.latitude);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeStartLocationLng(
                                            StartCor: startPos.longitude);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeEndLocationLat(
                                            EndCor: endPos.latitude);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeEndLocationLng(
                                            EndCor: endPos.longitude);

                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeStartLocation(
                                            start: _startLocation);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .chageEndLocation(end: _endlocation);
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeStartDate(
                                            startD: splitString(
                                                _startDate.toString()));
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeEndDate(
                                            endD:
                                                splitString(_endDate.toString()));
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeMode(modeOfTheTrip: "One way");
                                    Provider.of<RiderDetailsProvider>(context,
                                            listen: false)
                                        .changeUserId(
                                            userID: (_auth.currentUser?.uid)
                                                .toString());

                                    if (_intermidatelocation != "") {
                                      Provider.of<RiderDetailsProvider>(context,
                                              listen: false)
                                          .changeIntermediateLocation(
                                              midLocation: _intermidatelocation);
                                    }
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString('docId', "res");
                                    setState(() {
                                      _saving = false;
                                    });
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TransportModePage()));
                                    // Navigator.pushNamed(context, "/transport");
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            const Text('Enter correct details'),
                                        action: SnackBarAction(
                                          label: 'Undo',
                                          onPressed: () {
                                            // Code to execute.
                                          },
                                        ),
                                      ),
                                    );
                                    //Navigator.pushNamed(context, "/transport");
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  // Change the color
                                  backgroundColor: primaryColor,
                                ),
                                child: const Text(
                                  'Next',
                                  style: TextStyle(fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
