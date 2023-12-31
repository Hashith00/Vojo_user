
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vojo/backend/backend.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  backgroundColor: Theme.of(context).primaryColor,
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
            Tab(text: 'Return Trip'),
            Tab(text: 'One Way Trip'),
          ],
        ),
      ),
      body: TabBarView(
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        color: Colors.grey, // Set the background color to cyan
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Return Trip',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Start Destination',
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            onChanged: (context) {
                              _startLocation = context;
                            },
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Intermediate Destination',
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            onChanged: (context) {
                              _intermidatelocation = context;
                            },
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'End Destination',
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            onChanged: (context) {
                              _endlocation = context;
                            },
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
                        onPressed: ()async {
                          if(_startDate.compareTo(DateTime.now()) == 1 &&
                              _endDate.compareTo(DateTime.now()) == 1 &&
                              _startLocation != "" &&
                              _endlocation != "" && _intermidatelocation != ""){
                            print(splitString(_startDate.toString()));
                            print(splitString(_endDate.toString()));
                            print((_auth.currentUser?.uid).toString());
                            var res = await addTrip(
                                uid: (_auth.currentUser?.uid).toString(),
                                type: "two_way",
                                startDate: splitString(_startDate.toString()),
                                endDate: splitString(_endDate.toString()),
                                startLocation: _startLocation,
                                endLocation: _endlocation,
                                intermidiateLocation: _intermidatelocation);
                            print(res);
                            Navigator.pushNamed(context, "/transport");
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('docId', res);
                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Enter correct details'),
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
                          backgroundColor: Color(0xFF4B39EF),
                        ),
                        child: const Text('Confirm', style: TextStyle(fontSize: 17),),
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        color: Colors.grey, // Set the background color to cyan
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'One Way Trip',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Start Destination',
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            onChanged: (context) {
                              _startLocation = context;
                            },
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'End Destination',
                              fillColor: Colors.white,
                              filled: true,
                            ),
                            onChanged: (context) {
                              _endlocation = context;
                            },
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
                        onPressed: () async{
                          if (_startDate.compareTo(DateTime.now()) == 1 &&
                              _endDate.compareTo(DateTime.now()) == 1 &&
                              _startLocation != "" &&
                              _endlocation != "") {
                            print(splitString(_startDate.toString()));
                            print(splitString(_endDate.toString()));
                            var res = await addTrip(
                                uid: (_auth.currentUser?.uid).toString(),
                                type: "one_way",
                                startDate: splitString(_startDate.toString()),
                                endDate: splitString(_endDate.toString()),
                                startLocation: _startLocation,
                                endLocation: _endlocation);
                            print(res);
                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('docId', res);
                            Navigator.pushNamed(context, "/transport");
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Enter correct details'),
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
                          backgroundColor: Color(0xFF4B39EF),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 100,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
