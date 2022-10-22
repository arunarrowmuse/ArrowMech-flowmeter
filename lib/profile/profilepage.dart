import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoad = false;
  var data;
  late SharedPreferences prefs;
  String? tokenvalue;
  TextEditingController company = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController standardtime = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repeatpassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    FetchProfile();
  }

  void FetchProfile() async {
    setState(() {
      isLoad = true;
    });
    prefs = await SharedPreferences.getInstance();
    tokenvalue = prefs.getString("token");
    final response = await http.get(
      Uri.parse('${Constants.weblink}GetProfileshowSingleView'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
    );
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print("Fetch Profile");
      print(data);
      company.text = data['company_name'];
      email.text = data['email'];
      number.text = data['mobile_no'];
      _timeController.text = data['standartime'];
      print(_timeController.text);
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

  void UpdateProfile(String id) async {
    print(tokenvalue);
    final response = await http.post(
      Uri.parse('${Constants.weblink}ProfileUpdateSingle/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
      body: jsonEncode(<String, String>{
        '_method': 'PUT',
        'firstname':data['firstname'],
        'surname':data['surname'],
        'email':email.text,
        'company_name':company.text,
        'mobile_code':data['mobile_code'],
        'mobile_no':number.text,
        'address':data['address'],
        'standartime':_timeController.text,
      }),
    );
    if (response.statusCode == 200) {
      // data = jsonDecode(response.body);
      Constants.showtoast("Profile Updated!");
      // _textFieldController.clear();
      FetchProfile();
    } else {
      print(response.statusCode);
      print(response.body);
      Constants.showtoast("Error Fetching Data.");
    }
  }
  String _setTime = "";
  String _hour = "", _minute = "", _time = "" ;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _timeController = TextEditingController();
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ':' + _minute + ":00";
        _timeController.text = _time;
        // _timeController.text = formatDate(
        //     DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
        //     [hh, ':', nn, " ", am]).toString();

        print("_timecontroller");
        print(_timeController.text);
      });
    }}

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery
        .of(context)
        .size
        .height;
    final w = MediaQuery
        .of(context)
        .size
        .width;
    return RefreshIndicator(
      onRefresh: (){
        return Future(() => FetchProfile());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: SizedBox(
              height: 45, child: Image.asset("assets/icons/Arrowmech.png")),
          centerTitle: true,
          elevation: 0,
          leading: Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child:
              Icon(Icons.arrow_back_outlined, color: Colors.black, size: 25),
            );
          }),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Text(
                  "PROFILE",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: Constants.semibold,
                  ),
                ),
              ),
              (isLoad == true)
                  ? Container(
                height: 500,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Constants.mainTheme,
                  ),
                ),
              )
                  : Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Company Name :",
                            style: TextStyle(
                                fontFamily: Constants.regular,
                                // color: Constants.textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                          SizedBox(height: 7),
                          SizedBox(
                            height: 35,
                            width: w * 0.9,
                            child: TextField(
                              controller: company,
                              style: TextStyle(
                                fontFamily: Constants.regular,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 10.0, left: 10.0),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Constants.mainTheme,
                                        width: 2.0),
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontFamily: Constants.regular,
                                  ),
                                  hintText: "company name",
                                  fillColor: Colors.white70),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email :",
                            style: TextStyle(
                                fontFamily: Constants.regular,
                                // color: Constants.textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                          SizedBox(height: 7),
                          SizedBox(
                            height: 35,
                            width: w * 0.9,
                            child: TextField(
                              controller: email,
                              style: TextStyle(
                                fontFamily: Constants.regular,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 10.0, left: 10.0),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Constants.mainTheme,
                                        width: 2.0),
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontFamily: Constants.regular,
                                  ),
                                  hintText: "enter email",
                                  fillColor: Colors.white70),
                            ),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Phone Number",
                            style: TextStyle(
                                fontFamily: Constants.semibold,
                                color: Colors.black,
                                // fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 30,
                                width: w * 0.12,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8.0)),
                                ),
                                child: Center(
                                  child: Text(
                                    "+91",
                                    style: TextStyle(
                                        fontFamily: Constants.regular,
                                        // color: Colors.grey[700],
                                        fontSize: 16),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 35,
                                width: w * 0.70,
                                child: TextField(
                                  controller: number,
                                  style: TextStyle(
                                    fontFamily: Constants.regular,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.only(
                                          bottom: 10.0, left: 10.0),
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 1.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Constants.mainTheme,
                                            width: 2.0),
                                        borderRadius:
                                        BorderRadius.circular(8.0),
                                      ),
                                      filled: true,
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontFamily: Constants.regular,
                                      ),
                                      hintText: "9000090000",
                                      fillColor: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pick your time for daily report",
                                style: TextStyle(
                                    fontFamily: Constants.regular,
                                    // color: Constants.textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12),
                              ),
                              SizedBox(height: 7),
                              GestureDetector(
                                onTap:(){
                                  _selectTime(context);
                                },
                                child: SizedBox(
                                  height: 35,
                                  width: w * 0.9,
                                  child: TextField(
                                    controller: _timeController,
                                    enabled: false,
                                    style: TextStyle(
                                      fontFamily: Constants.regular,
                                      color: Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.only(
                                            bottom: 10.0, left: 10.0),
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                          borderSide: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 1.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Constants.mainTheme,
                                              width: 2.0),
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                        ),
                                        filled: true,
                                        hintStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontFamily: Constants.regular,
                                        ),
                                        prefixIcon: Icon(Icons.timelapse),
                                        prefixIconColor: Constants.mainTheme,
                                        hintText: "pick your time",
                                        fillColor: Colors.white70),
                                  ),
                                ),
                              )
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              UpdateProfile(data['id'].toString());
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Constants.mainTheme)),
                            child: const Text("       Save       "),
                          ),
                          // const SizedBox(height: 10),
                          const Divider(),
                          const SizedBox(height: 10),
                          Text(
                            "CHANGE PASSWORD",
                            style: TextStyle(
                                fontFamily: Constants.regular,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "New Password :",
                            style: TextStyle(
                                fontFamily: Constants.semibold,
                                // color: Constants.textColor,
                                // fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                          SizedBox(height: 7),
                          SizedBox(
                            height: 35,
                            width: w * 0.9,
                            child: TextField(
                              style: TextStyle(
                                fontFamily: Constants.regular,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 10.0, left: 10.0),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Constants.mainTheme,
                                        width: 2.0),
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontFamily: Constants.regular,
                                  ),
                                  hintText: "enter password",
                                  fillColor: Colors.white70),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Repeat Password :",
                            style: TextStyle(
                                fontFamily: Constants.semibold,
                                // color: Constants.textColor,
                                // fontWeight: FontWeight.w600,
                                fontSize: 12),
                          ),
                          SizedBox(height: 7),
                          SizedBox(
                            height: 35,
                            width: w * 0.9,
                            child: TextField(
                              style: TextStyle(
                                fontFamily: Constants.regular,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 10.0, left: 10.0),
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1.0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Constants.mainTheme,
                                        width: 2.0),
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                  ),
                                  filled: true,
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontFamily: Constants.regular,
                                  ),
                                  hintText: "enter password again",
                                  fillColor: Colors.white70),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    Constants.mainTheme)),
                            child: const Text("Update Password"),
                          ),
                        ],
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
