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

class _ViewReportState extends State<ViewReport> {
  var selectedDate = DateTime.now();
  bool isLoad = false;
  var data;
  late SharedPreferences prefs;
  String? tokenvalue;

  @override
  void initState() {
    super.initState();
    FetchReport();
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
      FetchReport();
    }
  }

  void FetchReport() async {
    setState(() {
      isLoad = true;
    });
    prefs = await SharedPreferences.getInstance();
    tokenvalue = prefs.getString("token");
    final response = await http.get(
      Uri.parse(
          '${Constants.weblink}ReportViewGetDaily/${selectedDate.toString().split(" ")[0]}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
    );
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print("Report List");
      print(data);
      setState(() {
        isLoad = false;
      });
    } else {
      setState(() {
        isLoad = false;
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
          return Future(() => FetchReport());
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
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        height: 30,
                        decoration: BoxDecoration(
                            border: Border.all(color: Constants.mainTheme),
                            borderRadius: BorderRadius.circular(50)),
                        child: GestureDetector(
                          onTap: chooseDate,
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
              Expanded(
                child: Scaffold(
                  body: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
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
                                        "Main Machine 1",
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
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, top: 10, left: 20),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: w / 3,
                                          child: Text(
                                            "Sub Machine ",
                                            style: TextStyle(
                                                fontFamily: Constants.regular,
                                                fontSize: 16),
                                          ),
                                        ),
                                        Container(
                                          height: 35,
                                          width: w / 2,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25),
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: Constants.regular),
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount: 2,
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 80, top: 8, bottom: 8),
                                      child: Text(
                                        "200",
                                        style: TextStyle(
                                            color: Colors.black,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
