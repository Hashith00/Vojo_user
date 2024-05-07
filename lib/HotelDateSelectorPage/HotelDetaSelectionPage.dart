import 'package:flutter/material.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vojo/Conatants/Constans.dart';
import 'package:vojo/HotelListpage/HotelListPage.dart';

class HotelDateSelectingPage extends StatefulWidget {
  const HotelDateSelectingPage({super.key});

  @override
  State<HotelDateSelectingPage> createState() => _HotelDateSelectingPageState();
}

class _HotelDateSelectingPageState extends State<HotelDateSelectingPage> {
  var startDate;
  var endDate;
  late CleanCalendarController calendarController;

  @override
  void initState() {
    super.initState();
    calendarController = CleanCalendarController(
      minDate: DateTime.now(),
      maxDate: DateTime.now().add(const Duration(days: 365)),
      onRangeSelected: (firstDate, secondDate) {
        updateSelectedDates(firstDate, secondDate);
      },
      onDayTapped: (date) {},
      onPreviousMinDateTapped: (date) {},
      onAfterMaxDateTapped: (date) {},
      weekdayStart: DateTime.monday,
    );
  }

  void updateSelectedDates(DateTime? start, DateTime? end) {
    setState(() {
      startDate = start;
      endDate = end;
    });
  }

  void onBookPressed() {
    if (startDate != null && endDate != null) {
      print('Start Date: $startDate');
      print('End Date: $endDate');
    } else {
      print('No date range selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF3F51B5),
          primaryContainer: Color(0xFF002984),
          secondary: Color(0xFFD32F2F),
          surface: Color(0xFFDEE2E6),
          background: Color(0xFFF8F9FA),
          error: Color(0xFF96031A),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.black,
          onBackground: Colors.black,
          onError: Colors.white,
          brightness: Brightness.light,
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Select the Dates",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      height: 600,
                      child: ScrollableCleanCalendar(
                        calendarController: calendarController,
                        layout: Layout.BEAUTY,
                        calendarCrossAxisSpacing: 0,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('startDate', startDate.toString());
                    await prefs.setString('endDate', endDate.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HotelListPage(
                                startDate: startDate, endDate: endDate)));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColor),
                    child: Center(
                      child: Text(
                        "Book",
                        style: TextStyle(color: Colors.white,),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
