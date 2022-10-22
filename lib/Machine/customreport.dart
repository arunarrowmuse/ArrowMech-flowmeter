import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../constants.dart';

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

  @override
  void initState() {
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    List<DateTime>? dateTimeList = await showOmniDateTimeRangePicker(
      context: context,
      type: OmniDateTimePickerType.dateAndTime,
      primaryColor: Constants.mainTheme,
      backgroundColor: Colors.white,
      calendarTextColor: Colors.black,
      tabTextColor: Colors.black,
      unselectedTabBackgroundColor: Colors.grey[500],
      buttonTextColor: Constants.mainTheme,
      timeSpinnerTextStyle: TextStyle(color: Colors.red.withOpacity(0.5), fontSize: 18),
      timeSpinnerHighlightedTextStyle:
          TextStyle(color: Constants.mainTheme, fontSize: 24, fontFamily: Constants.regular),
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
        fromdateformat = DateFormat.yMMMMd().add_jm().format(dateTimeList[0]);
        todateformat = DateFormat.yMMMMd().add_jm().format(dateTimeList[1]);
        dateselected = true;
      } else {
        print("no date selected");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
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
              _selectDate(context);
            },
            child: Container(
              height: 40,
              width: w,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                  ),
                  borderRadius: const BorderRadius.all(const Radius.circular(20))),
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                " From  $fromdateformat  \n To  $todateformat",
                                style: TextStyle(
                                    fontFamily: Constants.medium,
                                    // color: Constants.textColor,
                                    fontWeight: FontWeight.w600,
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
              : Expanded(
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
                                  height: 55,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: w / 2.5,
                                        padding: const EdgeInsets.only(
                                            left: 15, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Main Machine 1",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      Constants.semibold),
                                            ),
                                            Text(
                                              "11-05-2022",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontFamily:
                                                      Constants.regular),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: w / 2,
                                        padding: const EdgeInsets.only(
                                            right: 15, top: 8, bottom: 8),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Water Consumption",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontFamily:
                                                          Constants.semibold)),
                                              Text(
                                                "11:11 AM",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontFamily:
                                                        Constants.regular),
                                              ),
                                            ],
                                          ),
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
                                                  fontFamily:
                                                      Constants.regular),
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
    )));
  }
}
