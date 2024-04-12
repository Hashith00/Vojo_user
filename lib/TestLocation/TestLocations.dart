import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vojo/LocationSearchPage/LocationSearchPage.dart';
import 'package:vojo/StateManagment/StateManagment.dart';

class TestLocationService extends StatefulWidget {
  String? location;
  TestLocationService({super.key, this.location});

  @override
  State<TestLocationService> createState() => _TestLocationServiceState();
}

class _TestLocationServiceState extends State<TestLocationService> {
  late TextEditingController textController;// Define the TextEditingController
  late TextEditingController secoundTextController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();// Initialize the TextEditingController
    secoundTextController = TextEditingController();


  }



  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TempDetailsProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
            child: Column(
              children:[
                TextFormField(
                onTap: ()async{
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => LocationSearchPage()));
                  setState(() {
                    textController.text = result;
                  });
                },
                controller: textController,
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Email',
                ),
              ),
                SizedBox(height: 20,),
                TextFormField(
                  onTap: ()async{
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => LocationSearchPage()));
                    setState(() {
                      secoundTextController.text = result;
                    });
                  },
                  controller: secoundTextController,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: 'Email',
                  ),
                ),
          ]
            ),
          ),
        ),
      ),
    );
  }
}


