import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'ViewReport.dart';

bool _9amto10ambool = false;
bool _10amto11ambool = false;
bool _11amto12ambool = false;
bool _12amto1pmbool = false;
bool _1pmto2pmbool = false;
bool _2pmto3pmbool = false;
bool _3pmto4pmbool = false;
bool _4pmto5pmbool = false;
bool _5pmto6pmbool = false;
bool _6pmto7pmbool = false;
bool _7pmto8pmbool = false;
bool _8pmto9pmbool = false;
bool _9pmto10pmbool = false;
bool _10pmto11pmbool = false;
bool _11pmto12pmbool = false;
bool _12pmto1ambool = false;
bool _1amto2ambool = false;
bool _2amto3ambool = false;
bool _3amto4ambool = false;
bool _4amto5ambool = false;
bool _5amto6ambool = false;
bool _6amto7ambool = false;
bool _7amto8ambool = false;
bool _8amto9ambool = false;

///////
var _9amto10am;
var _10amto11am;
var _11amto12am;
var _12amto1pm;
var _1pmto2pm;
var _2pmto3pm;
var _3pmto4pm;
var _4pmto5pm;
var _5pmto6pm;
var _6pmto7pm;
var _7pmto8pm;
var _8pmto9pm;
var _9pmto10pm;
var _10pmto11pm;
var _11pmto12pm;
var _12pmto1am;
var _1amto2am;
var _2amto3am;
var _3amto4am;
var _4amto5am;
var _5amto6am;
var _6amto7am;
var _7amto8am;
var _8amto9am;

class HourlyReport extends StatefulWidget {
  final int index;
  final String subcategory;
  final String name;

  const HourlyReport(
      {Key? key,
      required this.index,
      required this.subcategory,
      required this.name})
      : super(key: key);

  @override
  State<HourlyReport> createState() => _HourlyReportState();
}

class _HourlyReportState extends State<HourlyReport> {
  var selectedDate = DateTime.now();

  late SharedPreferences prefs;
  String? tokenvalue;

  @override
  void initState() {

    fetchclocks();
    super.initState();
  }

  List<String> timeList = [
    '9 AM to 10 AM',
    '10 AM to 11 AM',
    '11 AM to 12 AM',
    '12 AM to 1 PM',
    '1 PM to 2 PM',
    '2 PM to 3 PM',
    '3 PM to 4 PM',
    '4 PM to 5 PM',
    '5 PM to 6 PM',
    '6 PM to 7 PM',
    '7 PM to 8 PM',
    '8 PM to 9 PM',
    '9 PM to 10 PM',
    '10 PM to 11 PM',
    '11 PM to 12 PM',
    '12 PM to 1 AM',
    '1 AM to 2 AM',
    '2 AM to 3 AM',
    '3 AM to 4 AM',
    '4 AM to 5 AM',
    '5 AM to 6 AM',
    '6 AM to 7 AM',
    '7 AM to 8 AM',
    '8 AM to 9 AM',
  ];
  List timeBool = [
    _9amto10ambool,
    _10amto11ambool,
    _11amto12ambool,
    _12amto1pmbool,
    _1pmto2pmbool,
    _2pmto3pmbool,
    _3pmto4pmbool,
    _4pmto5pmbool,
    _5pmto6pmbool,
    _6pmto7pmbool,
    _7pmto8pmbool,
    _8pmto9pmbool,
    _9pmto10pmbool,
    _10pmto11pmbool,
    _11pmto12pmbool,
    _12pmto1ambool,
    _1amto2ambool,
    _2amto3ambool,
    _3amto4ambool,
    _4amto5ambool,
    _5amto6ambool,
    _6amto7ambool,
    _7amto8ambool,
    _8amto9ambool,
  ];
  List timeData = [
    _9amto10am,
    _10amto11am,
    _11amto12am,
    _12amto1pm,
    _1pmto2pm,
    _2pmto3pm,
    _3pmto4pm,
    _4pmto5pm,
    _5pmto6pm,
    _6pmto7pm,
    _7pmto8pm,
    _8pmto9pm,
    _9pmto10pm,
    _10pmto11pm,
    _11pmto12pm,
    _12pmto1am,
    _1amto2am,
    _2amto3am,
    _3amto4am,
    _4amto5am,
    _5amto6am,
    _6amto7am,
    _7amto8am,
    _8amto9am,
  ];
  List starttime = [
    "09:00:00.00",
    "10:00:00.00",
    "11:00:00.00",
    "12:00:00.00",
    "13:00:00.00",
    "14:00:00.00",
    "15:00:00.00",
    "16:00:00.00",
    "17:00:00.00",
    "18:00:00.00",
    "19:00:00.00",
    "20:00:00.00",
    "21:00:00.00",
    "22:00:00.00",
    "23:00:00.00",
    "00:00:00.00",
    "01:00:00.00",
    "02:00:00.00",
    "03:00:00.00",
    "04:00:00.00",
    "05:00:00.00",
    "06:00:00.00",
    "07:00:00.00",
    "08:00:00.00",
  ];
  List endtime = [
    "10:00:00.00",
    "11:00:00.00",
    "12:00:00.00",
    "13:00:00.00",
    "14:00:00.00",
    "15:00:00.00",
    "16:00:00.00",
    "17:00:00.00",
    "18:00:00.00",
    "19:00:00.00",
    "20:00:00.00",
    "21:00:00.00",
    "22:00:00.00",
    "23:00:00.00",
    "24:00:00.00",
    "01:00:00.00",
    "02:00:00.00",
    "03:00:00.00",
    "04:00:00.00",
    "05:00:00.00",
    "06:00:00.00",
    "07:00:00.00",
    "08:00:00.00",
    "09:00:00.00",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          return Future(() {

            fetchclocks();
          });
        },
        child: Scaffold(
          body: Column(
            children: [
              Container(
                  padding: const EdgeInsets.only(left: 20, top: 15, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Hourly Report",
                        style: TextStyle(
                            fontSize: 30, fontFamily: Constants.semibold),
                      ),
                      GestureDetector(
                        onTap: chooseDate,
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          height: 30,
                          decoration: BoxDecoration(
                              border: Border.all(color: Constants.mainTheme),
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            children: [
                              ClipRRect(
                                child: Image.asset(
                                  'assets/icons/calendar.png',
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                DateFormat("dd-MM-yyyy")
                                    .format(selectedDate)
                                    .toString(),
                                style: TextStyle(
                                  fontFamily: Constants.regular,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              ClipRRect(
                                child: Image.asset(
                                  'assets/icons/downarrow.png',
                                  height: 20,
                                  width: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Row(
                  children: [
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              const SizedBox(
                height: 10,
              ),
              hourlyList(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> chooseDate() async {
    DateTime? picked = await showDatePicker(
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2050, 12),
        context: context,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Constants.mainTheme,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        });
    if (picked != null) {
      setState(() => selectedDate = picked);
      // FetchData();
      fetchclocks();
    }
  }

  hourlyList() {
    final w = MediaQuery.of(context).size.width;
    return Expanded(
      child: ListView.builder(
        itemCount: timeList.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.only(left: 25, right: 15, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: w / 3,
                  child: Text(
                    timeList[index],
                    style:
                        TextStyle(fontFamily: Constants.regular, fontSize: 16),
                  ),
                ),
                Container(
                    width: w / 2.2,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Center(
                      child: (timeBool[index] == true)
                          ? const CircularProgressIndicator()
                          : Text(
                              timeData[index].toString(),
                              style: TextStyle(
                                  fontSize: 18, fontFamily: Constants.regular),
                            ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }

  /// all the functions

  void fetchclocks() async {
    _9amto10am = '';
    _10amto11am = '';
    _11amto12am = '';
    _12amto1pm = '';
    _1pmto2pm = '';
    _2pmto3pm = '';
    _3pmto4pm = '';
    _4pmto5pm = '';
    _5pmto6pm = '';
    _6pmto7pm = '';
    _7pmto8pm = '';
    _8pmto9pm = '';
    _9pmto10pm = '';
    _10pmto11pm = '';
    _11pmto12pm = '';
    _12pmto1am = '';
    _1amto2am = '';
    _2amto3am = '';
    _3amto4am = '';
    _4amto5am = '';
    _5amto6am = '';
    _6amto7am = '';
    _7amto8am = '';
    _8amto9am = '';
    prefs = await SharedPreferences.getInstance();
    tokenvalue = prefs.getString("token");
    for (int j = 0; j < 24; j++) {
      print("DOING THE $j hour");
      setState(() {
        timeData[j] = true;
      });
      print(selectedDate);
      final response = await http.post(
        Uri.parse('${Constants.weblink}report'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $tokenvalue',
        },
        body: jsonEncode(<String, String>{
          "fdate": selectedDate.toString().split(" ")[0],
          "ftime": starttime[j], //hh:mm:ss.ssss
          "tdate": selectedDate.toString().split(" ")[0],
          "ttime": endtime[j],
        }),
      );
      if (response.statusCode == 200) {
        timeData[j] = jsonDecode(response.body);
        print("${timeList[j]}  Report List");
        print(timeData[j]);
        String gotvalue = '';
        for (int i = 0;
            i <
                timeData[j]['data']['report'][widget.index]['sub_category']
                    .length;
            i++) {
          if (widget.subcategory ==
              timeData[j]['data']['report'][widget.index]['sub_category'][i]
                  ['sub_category_id']) {
            gotvalue = timeData[j]['data']['report'][widget.index]
                ['sub_category'][i]['sub_total'];
          }
        }
        timeData[j] = gotvalue;
        setState(() {
          timeBool[j] = false;
        });
      } else {
        print("response.body");
        print(response.body);
        Constants.showtoast("Error Fetching Data.");
        setState(() {
          timeBool[j] = false;
        });
      }
    }
  }
}
