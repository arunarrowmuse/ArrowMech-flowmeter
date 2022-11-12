import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;

class CustomReport extends StatefulWidget {
  const CustomReport({Key? key}) : super(key: key);

  @override
  State<CustomReport> createState() => _CustomReportState();
}

class _CustomReportState extends State<CustomReport> {
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  TextEditingController _fromdate = TextEditingController();
  TextEditingController _todate = TextEditingController();
  TextEditingController _fromtime = TextEditingController();
  TextEditingController _totime = TextEditingController();
  bool dateselected = false;
  var fromdateformat;
  var todateformat;
  bool isLoad = false;
  var data;
  late SharedPreferences prefs;
  String? tokenvalue;

  @override
  void initState() {
    super.initState();
    // FetchCustomReport();
    Future.delayed(
      Duration(milliseconds: 5),
      () => _selectDate(),
    );
  }

  void FetchCustomReport() async {
    setState(() {
      isLoad = true;
    });
    print("Report1");
    prefs = await SharedPreferences.getInstance();
    tokenvalue = prefs.getString("token");
    print("Report2");
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
      data = jsonDecode(response.body);
      print("Custom  Report List");
      print(data);
      setState(() {
        isLoad = false;
      });
    } else {
      print("response.body");
      print(response.body);
      setState(() {
        isLoad = false;
      });
      Constants.showtoast("Error Fetching Data.");
    }
  }

  Future<void> _selectDate() async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      type: OmniDateTimePickerType.dateAndTime,
      primaryColor: Constants.mainTheme,
      backgroundColor: Colors.white,
      calendarTextColor: Colors.black,
      tabTextColor: Colors.black,
      unselectedTabBackgroundColor: Colors.grey[500],
      buttonTextColor: Constants.mainTheme,
      timeSpinnerTextStyle:
          TextStyle(color: Colors.red.withOpacity(0.5), fontSize: 18),
      timeSpinnerHighlightedTextStyle: TextStyle(
          color: Constants.mainTheme,
          fontSize: 24,
          fontFamily: Constants.regular),
      is24HourMode: false,
      isShowSeconds: false,
      startInitialDate: DateTime.now(),
      startFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      startLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      endInitialDate: DateTime.now(),
      endFirstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      endLastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      borderRadius: const Radius.circular(16),
    );
    print("dateTimeList");
    print(dateTimeList);
    setState(() {
      if (dateTimeList != null) {
        _fromdate.text = dateTimeList[0].toString().split(" ")[0];
        _fromtime.text = dateTimeList[0].toString().split(" ")[1];
        _todate.text = dateTimeList[1].toString().split(" ")[0];
        _totime.text = dateTimeList[1].toString().split(" ")[1];
        fromdateformat = DateFormat.yMMMd().add_jm().format(dateTimeList[0]);
        todateformat = DateFormat.yMMMd().add_jm().format(dateTimeList[1]);
        dateselected = true;
        FetchCustomReport();
      } else {
        print("no date selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () {
          return Future(() => FetchCustomReport());
        },
        child: Scaffold(
            body: Center(
                child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "Custom Report",
                      style: TextStyle(
                          fontFamily: Constants.semibold,
                          color: Colors.black,
                          fontSize: 24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _selectDate();
                },
                child: Container(
                  height: 40,
                  width: w,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red,
                      ),
                      borderRadius:
                          const BorderRadius.all(const Radius.circular(20))),
                  child: Center(
                    child: (dateselected == false)
                        ? Text(
                            "Select Date and Time",
                            style: TextStyle(
                                fontFamily: Constants.medium,
                                // color: Constants.textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          )
                        : Row(
                            children: [
                              const SizedBox(width: 10),
                              Icon(
                                Icons.calendar_month,
                                color: Constants.mainTheme,
                              ),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    " From ",
                                    style: TextStyle(
                                        fontFamily: Constants.medium,
                                        // color: Constants.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "$fromdateformat",
                                    style: TextStyle(
                                        fontFamily: Constants.medium,
                                        // color: Constants.textColor,
                                        // fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "  |  To ",
                                    style: TextStyle(
                                        fontFamily: Constants.medium,
                                        // color: Constants.textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Text(
                                    "$todateformat",
                                    style: TextStyle(
                                        fontFamily: Constants.medium,
                                        // color: Constants.textColor,
                                        // fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              (dateselected == false)
                  ? Container()
                  : (isLoad == true)
                      ? Container(
                          height: 500,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Constants.mainTheme,
                            ),
                          ),
                        )
                      : (data['data']['report'].length == 0)
                          ? Container(
                              height: 400,
                              // color: Colors.red,
                              child: Center(
                                child: Text(
                                  "No Reports Currently.",
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
                                  itemCount: data['data']['report'].length,
                                  itemBuilder: (context, index) {
                                    var main = data['data']['report'][index];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          bottom: 10,
                                          top: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey,
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 45,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: w / 3,
                                                    // color: Colors.red,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: Center(
                                                      child: Text(
                                                        main['category_name']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                Constants
                                                                    .semibold),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: w / 2.2,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 15,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Water Consumption",
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors
                                                                      .black,
                                                                  fontFamily:
                                                                      Constants
                                                                          .semibold)),
                                                          // Text(
                                                          //   "11:11 AM",
                                                          //   style: TextStyle(
                                                          //       fontSize: 14,
                                                          //       color: Colors.black,
                                                          //       fontFamily:
                                                          //           Constants.regular),
                                                          // ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ListView.builder(
                                              itemCount: data['data']['report']
                                                      [index]['sub_category']
                                                  .length,
                                              itemBuilder: (context, sindex) {
                                                var submain = data['data']
                                                        ['report'][index]
                                                    ['sub_category'][sindex];
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10,
                                                          top: 10,
                                                          left: 20),
                                                  color: Colors.white,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        width: w / 3,
                                                        child: Text(
                                                          submain['sub_category_name']
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  Constants
                                                                      .regular,
                                                              fontSize: 16),
                                                        ),
                                                      ),
                                                      Container(
                                                          height: 32,
                                                          width: w / 2.2,
                                                          // color: Colors.red,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              20))),
                                                          child: Center(
                                                            child: Text(
                                                              submain['sub_total']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontFamily:
                                                                      Constants
                                                                          .regular),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                );
                                              },
                                              shrinkWrap: true,
                                              physics:
                                                  const ClampingScrollPhysics(),
                                            ),
                                            Container(
                                              color: const Color(0xFFE7E7E7),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: Text(
                                                      "Total",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontFamily: Constants
                                                              .semibold),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 80,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: Text(
                                                      main['category_total']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontFamily: Constants
                                                              .semibold),
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
                            ),
            ],
          ),
        ))),
      ),
    );
  }
}
