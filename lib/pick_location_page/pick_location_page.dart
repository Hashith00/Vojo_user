import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${name}',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  CircleAvatar(
                    backgroundColor: Color(0xFF311B92),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Tab(
                  child: Row(
                    children: [
                      Icon(Icons.change_circle_rounded),
                      SizedBox(width: 8),
                      Text(
                        'Return Trip',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Tab(
                  child: Row(
                    children: [
                      Icon(Icons.directions),
                      SizedBox(width: 8),
                      Text(
                        'One Way Trip',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Start Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('Start Date',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 16.0),

                      // End Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('End Date',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 16.0),

                      // Start Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('Start Time',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 16.0),

                      // Form
                      Form(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF311B92),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                onTap: () async {
                                  final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LocationSearchPage()));
                                  setState(() {
                                    _startLocationContollerForReturnTrip.text =
                                        result;
                                    _startLocation = result;
                                  });
                                },
                                controller:
                                    _startLocationContollerForReturnTrip,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.play_circle),
                                  labelText: 'Start Destination',
                                  labelStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
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
                                  prefixIcon: Icon(Icons.pause_circle),
                                  labelText: 'Intermediate Destination',
                                  labelStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
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
                                    _endlocationControllerForReturnTrip.text =
                                        result;
                                    _endlocation = result;
                                  });
                                },
                                controller: _endlocationControllerForReturnTrip,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.stop_circle),
                                  labelText: 'End Destination',
                                  labelStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
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
                                  _endlocation != "" &&
                                  _intermidatelocation != "") {
                                print(splitString(_startDate.toString()));
                                print(splitString(_endDate.toString()));
                                print((_auth.currentUser?.uid).toString());

                                LatLng startPos =
                                    await getLocation(location: _startLocation);
                                LatLng endPos =
                                    await getLocation(location: _endlocation);
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
                                    .changeStartLocation(start: _startLocation);
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
                                        startD:
                                            splitString(_startDate.toString()));
                                Provider.of<RiderDetailsProvider>(context,
                                        listen: false)
                                    .changeEndDate(
                                        endD: splitString(_endDate.toString()));
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
                                // Navigator.pushNamed(context, "/transport");
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setString('docId', "res");
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        const Text('Enter Correct Details.'),
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
                              backgroundColor: Color(0xFF311B92),
                            ),
                            child: const Text(
                              'Confirm',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // One Way Trip
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Start Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('Start Date',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 16.0),

                      // End Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('End Date',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 16.0),

                      // Start Time
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text('Start Time',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
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
                      const SizedBox(height: 16.0),

                      // Form
                      Form(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF311B92),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                onTap: () async {
                                  final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LocationSearchPage()));
                                  setState(() {
                                    _startLocationContollerForOnewayTrip.text =
                                        result;
                                    _startLocation = result;
                                  });
                                },
                                controller:
                                    _startLocationContollerForOnewayTrip,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.play_circle),
                                  labelText: 'Start Destination',
                                  labelStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
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
                                controller: _endlocationControllerForOnewayTrip,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.stop_circle),
                                  labelText: 'End Destination',
                                  labelStyle: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
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

                                LatLng startPos =
                                    await getLocation(location: _startLocation);
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
                                    .changeStartLocation(start: _startLocation);
                                Provider.of<RiderDetailsProvider>(context,
                                        listen: false)
                                    .chageEndLocation(end: _endlocation);
                                Provider.of<RiderDetailsProvider>(context,
                                        listen: false)
                                    .changeStartDate(
                                        startD:
                                            splitString(_startDate.toString()));
                                Provider.of<RiderDetailsProvider>(context,
                                        listen: false)
                                    .changeEndDate(
                                        endD: splitString(_endDate.toString()));
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
                              backgroundColor: Color(0xFF311B92),
                            ),
                            child: const Text(
                              'Confirm',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
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
            ],
          ),
        ),
      ),
    );
  }
}
