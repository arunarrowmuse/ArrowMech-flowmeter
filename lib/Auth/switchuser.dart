import 'dart:convert';
import 'package:arrowmech/Auth/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:arrowmech/profile/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../switchscreen.dart';
import 'adduser.dart';

class SwitchUser extends StatefulWidget {
  const SwitchUser({Key? key}) : super(key: key);

  @override
  State<SwitchUser> createState() => _SwitchUserState();
}

class _SwitchUserState extends State<SwitchUser> {
  var UserList;
  bool isload = false;
  String Currentname = "";
  String Currentid = "";
  String Currenttoken = "";
  late SharedPreferences prefs;
  bool isLoad = false;
  String UserName = '';

  @override
  void initState() {
    super.initState();
    getUserList();
    getUser();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      UserName = prefs.getString("name")!;
    });
  }

  void logoutUser() async {
    print("logout run");
    setState(() {
      isLoad = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tokenvalue = prefs.getString("token");
    print("tokenvalue");
    print(tokenvalue);
    final response = await http.post(
      Uri.parse(Constants.weblink+Routes.LOGOUT),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
      body: jsonEncode(<String, String>{
        'token': tokenvalue.toString(),
      }),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      //----------------------------------------------------
      String Currentname = "";
      String Currentid = "";
      String Currenttoken = "";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Currentid = prefs.getInt('userid').toString();
      Currenttoken = prefs.getString('token')!;
      Currentname = prefs.getString("name")!;
      String? data = prefs.getString("UserList");
      List UserList = jsonDecode(data!);
      for (int i = 0; i < UserList.length; i++) {
        if (UserList[i]['token'] == Currenttoken) {
          /// check if token matches
          UserList.remove(UserList[i]);

          /// delete if token matches
          prefs.setString("UserList", jsonEncode(UserList));

          /// save data
          String? data = prefs.getString("UserList");

          /// fetch data again
          UserList = jsonDecode(data!);

          /// store in a list
          /// RIGHT NOW LETS MAKE THE TOP USER ON THE LIST
          /// GIVE THE CURRENT USER POSITION AGAIN
          // UserList = jsonDecode(data);
          print("Look for the length of the data");
          print(UserList.length);
          print(UserList);
          if (UserList.length == 0) {
            prefs.setInt('userid', 0);
            prefs.setString('token', "");
            prefs.setString("name", "");
            Constants.showtoast("Logged Out Successfully!");
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          } else {
            prefs.setInt('userid', int.parse(UserList[0]['UserID']));
            prefs.setString('token', UserList[0]['token']);
            prefs.setString('name', UserList[0]['name']);
            Constants.showtoast(
                "User Logged Out! \n User Changed to ${UserList[0]['name']}!");
            setState(() {
              isLoad = false;
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Switcher(values: 0),
                ),
              );
            });
          }
        }
      }
    } else {
      setState(() {
        isLoad = false;
      });
      print(response.statusCode);
      print(response.body);
      Constants.showtoast("Error while Logout!");
    }
  }

  void getUserList() async {
    setState(() {
      isload = true;
    });
    prefs = await SharedPreferences.getInstance();
    // prefs.getString("UserList");
    String? data = prefs.getString("UserList");
    UserList = jsonDecode(data!);
    print(UserList);
    print(UserList.length);
    Currentid = prefs.getInt('userid').toString();
    Currenttoken = prefs.getString('token')!;
    Currentname = prefs.getString("name")!;
    print("Current Profile is");
    print(Currentid);
    print(Currentname);
    print(Currenttoken);
    setState(() {
      isload = false;
    });
    print(UserList.length);
  }

  @override
  Widget build(BuildContext context) {
    // final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: Text(
                  "Switch User",
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: Constants.semibold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    height: 70,
                                    child: Image.asset(
                                        "assets/icons/User-icon.png")),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Current User : ",
                                    style: TextStyle(
                                        // color: Colors.white,
                                        fontSize: 12,
                                        // fontWeight: FontWeight.w700,
                                        fontFamily: Constants.regular),
                                  ),
                                  Text(
                                    Currentname,
                                    style: TextStyle(
                                        // color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: Constants.regular),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProfilePage()));
                              },
                              child: Text(
                                "Account Settings",
                                style: TextStyle(
                                  // color: Colors.white,
                                  fontSize: 14,
                                  // fontWeight: FontWeight.w700,
                                  fontFamily: Constants.regular,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              LogoutUser();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                "Sign Out",
                                style: TextStyle(
                                  // color: Colors.white,
                                  fontSize: 14,
                                  // fontWeight: FontWeight.w700,
                                  fontFamily: Constants.regular,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Switch to",
                      style: TextStyle(
                        // color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: Constants.regular,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AddUser(),
                            ),
                          );
                          // loginUser(_email.text, _password.text, session);
                          // Navigator.pushNamed(context, '/ContactUs');
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Constants.mainTheme),
                        child: Center(
                            child: Text(
                          'Add New',
                          style: TextStyle(
                              fontFamily: Constants.regular, fontSize: 16),
                        ))),
                  ),
                ],
              ),
              (isload == true)
                  ? SizedBox(
                      height: 500,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Constants.mainTheme,
                        ),
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: ListView.builder(
                          itemCount: UserList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return (UserList.length == 1)
                                ? Container(
                                    height: 200,
                                    child: Center(
                                      child: Text(
                                        "No More User",
                                        style: TextStyle(
                                            // color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: Constants.regular),
                                      ),
                                    ),
                                  )
                                : (UserList[index]['token'] != Currenttoken)
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30.0, right: 30.0),
                                        child: Card(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                        height: 50,
                                                        child: Image.asset(
                                                            "assets/icons/User-icon.png")),
                                                  ),
                                                  Text(
                                                    UserList[index]['name'],
                                                    style: TextStyle(
                                                        // color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            Constants.regular),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                  color: Constants.mainTheme,
                                                  onPressed: () {
                                                    ChangerUser(
                                                        context,
                                                        UserList[index]
                                                            ['UserID'],
                                                        UserList[index]['name'],
                                                        UserList[index]
                                                            ['token']);
                                                    // prefs = await SharedPreferences.getInstance();
                                                    // prefs.setInt('userid', userid);
                                                    // prefs.setString('token', token);
                                                    // prefs.setString('name', name);
                                                  },
                                                  icon: Icon(Icons.swap_calls))
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container();
                          }),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> ChangerUser(
      BuildContext context, String useridd, String namee, String tokenn) async {
    final w = MediaQuery.of(context).size.width;
    final GlobalKey<FormState> _key = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            title: Text(
              "Are you sure to Switch ?",
              style: TextStyle(
                // color: Colors.white,
                fontSize: 20,
                fontFamily: Constants.regular,
              ),
            ),
            actions: <Widget>[
              Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.regular,
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontFamily: Constants.regular,
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // deleteMachine(id);
                      Navigator.pop(context);
                      prefs.setInt('userid', int.parse(useridd));
                      prefs.setString('token', tokenn);
                      prefs.setString('name', namee);
                      getUserList();
                      Constants.showtoast("User Changed to $namee!");
                      // Constants.showtoast("User Changed to $namee!");
                    });
                  },
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.regular,
                      )),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Constants.mainTheme)),
                  child: Text(
                    "Switch",
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: 16,
                      fontFamily: Constants.regular,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> LogoutUser() async {
    final w = MediaQuery.of(context).size.width;
    final GlobalKey<FormState> _key = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            title: Text(
              "Are you sure to Sign Out ?",
              style: TextStyle(
                // color: Colors.white,
                fontSize: 20,
                fontFamily: Constants.regular,
              ),
            ),
            actions: <Widget>[
              Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.regular,
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontFamily: Constants.regular,
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      logoutUser();
                    });
                  },
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.regular,
                      )),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Constants.mainTheme)),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: 16,
                      fontFamily: Constants.regular,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
