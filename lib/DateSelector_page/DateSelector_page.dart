import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:vojo/backend/backend.dart';
class DateSelector extends StatefulWidget {
  const DateSelector({super.key, required this.id});
  final String id;

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int _currentValueDate = 3;
  int _currentValueMonth = 3;
  int _currentValueYear = 2024;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.only(top: 250),
            width: double.infinity,

            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: <Widget>[
                        Text('Date'),
                        NumberPicker(
                          value: _currentValueDate,
                          minValue: 1,
                          maxValue: 31,
                          onChanged: (value) => setState(() => _currentValueDate = value),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('Month'),
                        NumberPicker(
                          value: _currentValueMonth,
                          minValue: 1,
                          maxValue: 12,
                          onChanged: (value) => setState(() => _currentValueMonth = value),
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text('Year'),
                        NumberPicker(
                          value: _currentValueYear,
                          minValue: 2024,
                          maxValue: 2026,
                          onChanged: (value) => setState(() => _currentValueYear = value),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: ()async{
                    String startdate = "$_currentValueYear-$_currentValueMonth-$_currentValueDate";
                    Response r1 = Response();
                    r1 =await updateTripStartDate(docId: widget.id, date: startdate);
                    print(r1.code);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 30),
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue
                    ),
                    child: Center(child: Text("Set Starting Date", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),),
                  ),
                ),
                GestureDetector(
                  onTap: ()async{
                    String startdate = "$_currentValueYear-$_currentValueMonth-$_currentValueDate";
                    Response r1 = Response();
                    r1 =await updateTripEndDate(docId: widget.id, date: startdate);
                    print(r1.code);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 50,
                    width: 350,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black
                    ),
                    child: Center(child: Text("Go Back", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),),),
                  ),
                ),
              ],
            ),


          )
          ),
        ),
    );
  }
}
