import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class ViewReport extends StatefulWidget {
  const ViewReport({Key? key}) : super(key: key);

  @override
  State<ViewReport> createState() => _ViewReportState();
}

const double width = 300.0;
const double height = 45.0;
const double fullday = -1;
const double shiftday = 1;
const Color selectedColor = Colors.white;
const Color normalColor = Colors.black54;

class _ViewReportState extends State<ViewReport> {
  var selectedDate = DateTime.now();
  bool isLoadfull = true;
  bool isLoadshiftone = true;
  bool isLoadshifttwo = true;
  var fulldaydata;
  var shiftday1data;
  var shiftday2data;
  late SharedPreferences prefs;
  String? tokenvalue;
  String? picktimevalue;
  late double xAlign;
  late Color fulldayColor;
  late Color shiftdayColor;
  var nowtime = DateTime.now();
  TextEditingController _fromdate = TextEditingController();
  TextEditingController _todate = TextEditingController();
  TextEditingController _fromtime = TextEditingController();
  TextEditingController _totime = TextEditingController();
  TextEditingController _fromshift1date = TextEditingController();
  TextEditingController _toshift1date = TextEditingController();
  TextEditingController _fromshift1time = TextEditingController();
  TextEditingController _toshift1time = TextEditingController();
  TextEditingController _fromshift2date = TextEditingController();
  TextEditingController _toshift2date = TextEditingController();
  TextEditingController _fromshift2time = TextEditingController();
  TextEditingController _toshift2time = TextEditingController();

  @override
  void initState() {
    super.initState();
    xAlign = fullday;
    fulldayColor = selectedColor;
    shiftdayColor = normalColor;
    print("nowtime");
    print(nowtime.toString().split(" ")[0]);
    FetchData();
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
      FetchData();
    }
  }

  Future<void> FetchData() async {
    prefs = await SharedPreferences.getInstance();
    picktimevalue = prefs.getString("picktime");
    // print("picktime is this ");
    // print(picktimevalue);

    /// Full Day Report
    if (nowtime.toString().split(" ")[0] ==
        selectedDate.toString().split(" ")[0]) {
      /// Same Date Data
      _fromdate.text = nowtime.toString().split(" ")[0];
      _fromtime.text = picktimevalue!; // default time
      _todate.text = nowtime.toString().split(" ")[0];
      _totime.text = nowtime.toString().split(" ")[1];
      FetchFullDayReport();
    } else {
      /// Different Date Data
      var newdate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);
      _fromdate.text = selectedDate.toString().split(" ")[0];
      _fromtime.text = picktimevalue!; //default time
      _todate.text = newdate.toString().split(" ")[0];
      _totime.text = picktimevalue!; // default time.
      FetchFullDayReport();
    }

    /// Shift Day Report
    if (nowtime.toString().split(" ")[0] ==
        selectedDate.toString().split(" ")[0]) {
      /// same date data
      var newdate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);

      ///shift one
      _fromshift1date.text = nowtime.toString().split(" ")[0];
      _fromshift1time.text = "09:00:00"; // default time
      _toshift1date.text = nowtime.toString().split(" ")[0];
      _toshift1time.text = nowtime.toString().split(" ")[1];

      /// shift two
      _fromshift2date.text = nowtime.toString().split(" ")[0];
      _fromshift2time.text = "21:00:00"; // default time
      _toshift2date.text = newdate.toString().split(" ")[0];
      _toshift2time.text = "09:00:00";
      FetchShiftDay1Report();
      FetchShiftDay2Report();
    } else {
      ///different date data
      var newdate =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day + 1);

      ///shift one
      _fromshift1date.text = selectedDate.toString().split(" ")[0];
      _fromshift1time.text = "09:00:00"; // default time
      _toshift1date.text = selectedDate.toString().split(" ")[0];
      _toshift1time.text = "21:00:00";

      ///shift two
      _fromshift2date.text = selectedDate.toString().split(" ")[0];
      _fromshift2time.text = "21:00:00"; // default time
      _toshift2date.text = newdate.toString().split(" ")[0];
      _toshift2time.text = "09:00:00";
      FetchShiftDay1Report();
      FetchShiftDay2Report();
    }
  }

  /// full day
  void FetchFullDayReport() async {
    setState(() {
      isLoadfull = true;
    });
    prefs = await SharedPreferences.getInstance();
    tokenvalue = prefs.getString("token");
    final response = await http.post(
      Uri.parse('${Constants.weblink}report'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
      body: jsonEncode(<String, String>{
        // "date": selectedDate.toString().split(" ")[0],
        "fdate": _fromdate.text,
        "ftime": _fromtime.text,
        "tdate": _todate.text,
        "ttime": _totime.text,
      }),
    );
    if (response.statusCode == 200) {
      fulldaydata = jsonDecode(response.body);
      print("Report List");
      print(fulldaydata);
      setState(() {
        isLoadfull = false;
      });
    } else {
      print("response.body");
      print(response.body);
      setState(() {
        isLoadfull = false;
      });
      Constants.showtoast("Error Fetching Data.");
    }
  }

  /// shiftone 9 am to 9 pm
  void FetchShiftDay1Report() async {
    setState(() {
      isLoadshiftone = true;
    });
    prefs = await SharedPreferences.getInstance();
    tokenvalue = prefs.getString("token");
    final response = await http.post(
      Uri.parse('${Constants.weblink}report'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
      body: jsonEncode(<String, String>{
        // "date": selectedDate.toString().split(" ")[0],
        "fdate": _fromshift1date.text,
        "ftime": _fromshift1time.text,
        "tdate": _toshift1date.text,
        "ttime": _toshift1time.text,
      }),
    );
    if (response.statusCode == 200) {
      shiftday1data = jsonDecode(response.body);
      print("Shift Day one List");
      print(shiftday1data);
      setState(() {
        isLoadshiftone = false;
      });
    } else {
      print("response.body");
      print(response.body);
      setState(() {
        isLoadshiftone = false;
      });
      Constants.showtoast("Error Fetching Data.");
    }
  }

  /// shifttwo 9 pm to 9 am
  void FetchShiftDay2Report() async {
    setState(() {
      isLoadshifttwo = true;
    });
    prefs = await SharedPreferences.getInstance();
    tokenvalue = prefs.getString("token");
    final response = await http.post(
      Uri.parse('${Constants.weblink}report'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
      body: jsonEncode(<String, String>{
        // "date": selectedDate.toString().split(" ")[0],
        "fdate": _fromshift2date.text,
        "ftime": _fromshift2time.text,
        "tdate": _toshift2date.text,
        "ttime": _toshift2time.text,
      }),
    );
    if (response.statusCode == 200) {
      shiftday2data = jsonDecode(response.body);
      print("Shift Day 2 List");
      print(shiftday2data);
      setState(() {
        isLoadshifttwo = false;
      });
    } else {
      print("response.body");
      print(response.body);
      setState(() {
        isLoadshifttwo = false;
      });
      Constants.showtoast("Error Fetching Data.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          return Future(() {
            FetchData();
            FetchFullDayReport();
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
                        "Report",
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
              Center(
                child: Container(
                  width: width * 1.1,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Constants.mainTheme),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        alignment: Alignment(xAlign, 0),
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          width: width * 0.5,
                          height: height,
                          decoration: BoxDecoration(
                            color: Constants.mainTheme,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(50.0),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            xAlign = fullday;
                            fulldayColor = selectedColor;
                            shiftdayColor = normalColor;
                          });
                        },
                        child: Align(
                          alignment: const Alignment(-1, 0),
                          child: Container(
                            width: width * 0.5,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(
                              'Full Day',
                              style: TextStyle(
                                color: fulldayColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            xAlign = shiftday;
                            shiftdayColor = selectedColor;
                            fulldayColor = normalColor;
                          });
                        },
                        child: Align(
                          alignment: const Alignment(1, 0),
                          child: Container(
                            width: width * 0.5,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: Text(
                              'Shift Wise',
                              style: TextStyle(
                                color: shiftdayColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              (xAlign == shiftday) ? shiftWise(context) : fullDay(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget fullDay(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return (isLoadfull == true)
        ? Container(
            height: 500,
            child: Center(
              child: CircularProgressIndicator(
                color: Constants.mainTheme,
              ),
            ),
          )
        : (fulldaydata['data']['report'].length == 0)
            ? Container(
                height: 400,
                // color: Colors.red,
                child: const Center(
                  child: Text(
                    "Please add machine in the machine list.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      // fontFamily:
                      // Constants.semibold
                    ),
                  ),
                ),
              )
            : Expanded(
                child: Scaffold(
                  body: ListView.builder(
                    itemCount: fulldaydata['data']['report'].length,
                    itemBuilder: (context, index) {
                      // print(fulldaydata['data']['report'].length);
                      var main = fulldaydata['data']['report'][index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 10, top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey,
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: w / 2.5,
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 8, bottom: 8),
                                      child: Text(
                                        main['category_name'].toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontFamily: Constants.semibold),
                                      ),
                                    ),
                                    Container(
                                      width: w / 2,
                                      padding: const EdgeInsets.only(
                                          right: 15, top: 8, bottom: 8),
                                      child: Center(
                                        child: Text("Water Consumption",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontFamily:
                                                    Constants.semibold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                itemCount: fulldaydata['data']['report'][index]
                                        ['sub_category']
                                    .length,
                                itemBuilder: (context, sindex) {
                                  var submain = fulldaydata['data']['report']
                                      [index]['sub_category'][sindex];
                                  return Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, top: 10, left: 20),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: w / 3,
                                          child: Text(
                                            submain['sub_category_name']
                                                .toString(),
                                            style: TextStyle(
                                                fontFamily: Constants.regular,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                            // height: 32,
                                            width: w / 2.2,
                                            // color: Colors.red,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.red,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            child: Center(
                                              child: Text(
                                                submain['sub_total'].toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily:
                                                        Constants.regular),
                                              ),
                                            )),
                                      ],
                                    ),
                                  );
                                },
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                              ),
                              Container(
                                color: const Color(0xFFE7E7E7),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, top: 8, bottom: 8),
                                      child: Text(
                                        "Total",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: Constants.semibold),
                                      ),
                                    ),
                                    Container(
                                      width: w / 4,
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      child: Text(
                                        main['category_total'].toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontFamily: Constants.semibold),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
  }

  Widget shiftWise(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return (isLoadshiftone == true && isLoadshifttwo == true)
        ? Container(
            height: 500,
            child: Center(
              child: CircularProgressIndicator(
                color: Constants.mainTheme,
              ),
            ),
          )
        : (fulldaydata['data']['report'].length == 0)
            ? Container(
                height: 400,
                // color: Colors.red,
                child: const Center(
                  child: Text(
                    "Please add machine in the machine list.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      // fontFamily:
                      // Constants.semibold
                    ),
                  ),
                ),
              )
            : Expanded(
                child: Scaffold(
                  body: ListView.builder(
                    itemCount: shiftday1data['data']['report'].length,
                    itemBuilder: (context, index) {
                      // print(fulldaydata['data']['report'].length);
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 10, top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey,
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: w / 4.5,
                                      padding: const EdgeInsets.only(
                                          left: 25, top: 8, bottom: 8),
                                      child: Text(
                                        shiftday1data['data']['report'][index]
                                                ['category_name']
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: Constants.semibold),
                                      ),
                                    ),
                                    Container(
                                      width: w / 4.5,
                                      child: Center(
                                        child: Text("Shift 1",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    Constants.semibold)),
                                      ),
                                    ),
                                    Container(
                                      width: w / 4.5,
                                      child: Center(
                                        child: Text("Shift 2",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily:
                                                    Constants.semibold)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ListView.builder(
                                itemCount: shiftday1data['data']['report']
                                        [index]['sub_category']
                                    .length,
                                itemBuilder: (context, sindex) {
                                  var shiftone = shiftday1data['data']['report']
                                      [index]['sub_category'][sindex];
                                  var shifttwo = shiftday2data['data']['report']
                                      [index]['sub_category'][sindex];
                                  return Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, top: 10, left: 20),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: w / 4,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            shiftone['sub_category_name'],
                                            style: TextStyle(
                                                fontFamily: Constants.regular,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Container(
                                            width: w / 4,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            decoration: BoxDecoration(
                                                // color: Colors.red,
                                                border: Border.all(
                                                  color: Colors.red,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            child: Center(
                                              child: Text(
                                                shiftone['sub_total']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        Constants.regular),
                                              ),
                                            )),
                                        Container(
                                            // height: 32,
                                            width: w / 4,
                                            // color: Colors.red,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.red,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            child: Center(
                                              child: Text(
                                                shifttwo['sub_total']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        Constants.regular),
                                              ),
                                            )),
                                      ],
                                    ),
                                  );
                                },
                                // itemCount: 2,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                              ),
                              Container(
                                color: const Color(0xFFE7E7E7),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 32,
                                      width: w / 4,
                                      // color: Colors.red,
                                      padding: const EdgeInsets.only(
                                          left: 25, top: 5, bottom: 5),
                                      // padding: const EdgeInsets.only(
                                      //     left: 25, top: 8, bottom: 8),
                                      child: Text(
                                        "Total",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontFamily: Constants.semibold),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: w / 4,
                                      // color: Colors.red,
                                      // padding: const EdgeInsets.only(left: 0 , top: 5 , bottom: 5),
                                      // padding: const EdgeInsets.only(
                                      //     right: 80, top: 8, bottom: 8),
                                      child: Center(
                                        child: Text(
                                          shiftday1data['data']['report'][index]
                                                  ['category_total']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: Constants.semibold),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 32,
                                      width: w / 4,
                                      // color: Colors.red,
                                      // padding: const EdgeInsets.only(left: 20 , top: 5 , bottom: 5),
                                      // padding: const EdgeInsets.only(
                                      //     right: 80, top: 8, bottom: 8),
                                      child: Center(
                                        child: Text(
                                          shiftday2data['data']['report'][index]
                                                  ['category_total']
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                              fontFamily: Constants.semibold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
  }
}
