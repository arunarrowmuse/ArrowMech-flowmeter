import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../switchscreen.dart';

class AddUser extends StatefulWidget {
  const AddUser({Key? key}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool session = false;
  bool isLoad = false;
  List UserData = [];
  bool _isObscure = true;
  final Uri arrowmech = Uri.parse('https://arrowmech.com');
  final Uri arrowmuse = Uri.parse('https://arrowmuse.com');

  Future<void> _launchmech() async {
    if (!await launchUrl(arrowmech, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $arrowmech';
    }
  }

  Future<void> _launchmuse() async {
    if (!await launchUrl(arrowmuse, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $arrowmuse';
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/loginBg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 60, right: 60, top: 80),
                      child: Image.asset("assets/images/logofinal.png"),
                      // "assets/images/Arrowmech_Logo.png"),
                      // "assets/images/Arrowmech_Logo_Final-2.png"),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        // _launchCaller();
                        _launchmech();
                      });
                    },
                    child: Text(
                      'www.arrowmech.com',
                      style: TextStyle(
                          fontFamily: Constants.semibold,
                          color: Constants.mainTheme,
                          fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10, left: 30),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Email",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.5,
                          fontFamily: Constants.semibold),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: _email,
                          validator: (value) =>
                              value!.isEmpty ? 'Email cannot be blank' : null,
                          style: TextStyle(
                              fontFamily: Constants.regular,
                              color: Colors.black,
                              fontSize: 18),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontFamily: Constants.regular,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: 'enter email'),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 10, left: 30),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Password",
                      style: TextStyle(
                          fontSize: 14, fontFamily: Constants.semibold),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: _password,
                          validator: (value) => value!.isEmpty
                              ? 'Password cannot be blank'
                              : null,
                          obscureText: _isObscure,
                          style: TextStyle(
                              fontFamily: Constants.regular,
                              color: Colors.black,
                              fontSize: 18),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontFamily: Constants.regular,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              filled: false,
                              hintText: "password",
                              fillColor: Colors.white70),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Checkbox(
                          shape: RoundedRectangleBorder(),
                          value: session,
                          onChanged: (value) {
                            setState(() {
                              this.session = value!;
                            });
                          },
                          activeColor: Constants.mainTheme,
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            print("gotclicked");
                            session =! session;
                          });
                        },
                        child: Text(
                          "Remember Me",
                          style: TextStyle(
                              fontFamily: Constants.regular, fontSize: 15),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    width: w,
                    child: ElevatedButton(
                        onPressed: () {
                          loginUser(_email.text, _password.text, session);
                          // Navigator.pushNamed(context, '/ContactUs');
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Constants.mainTheme),
                        child: Center(
                            child: (isLoad == false)
                                ? Text(
                                    'Sign In',
                                    style: TextStyle(
                                        fontFamily: Constants.regular,
                                        fontSize: 16),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ))),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchmuse();
                    },
                    child: Column(
                      children: [
                        Text(
                          'Powered By :',
                          style: TextStyle(
                              fontFamily: Constants.medium,
                              // color: Constants.mainTheme,
                              fontSize: 14),
                        ),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 120, right: 120, top: 5),
                            child: Image.asset("assets/images/Logo.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginUser(String email, String password, bool storesession) async {
    setState(() {
      isLoad = true;
    });
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      if (RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email)) {
        final response = await http.post(
          Uri.parse('${Constants.weblink}' + Routes.LOGIN),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password,
          }),
        );
        print(response.statusCode);
        if (response.statusCode == 200 || response.statusCode == 201) {
          var data = jsonDecode(response.body);
          print(data);
          if (data['message'] == "Bad creds") {
            Constants.showtoast("Invalid Email or Password!");
            setState(() {
              isLoad = false;
            });
          } else {
            if (storesession == true) {
              int userid = data['data']['user']['id'];
              String token = data['data']['token'];
              String name = data['data']['user']['name'];
              String company = data['data']['user']['company_name'].toString();
              String picktime = data['data']['user']['pick_time'].toString();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('userid', userid);
              prefs.setString('token', token);
              prefs.setString('name', name);
              prefs.setString('company', company);
              prefs.setString('picktime', picktime);
              prefs.getString("UserList");
              if (prefs.getString("UserList") == null) {
                prefs.setString(
                    "UserList",
                    jsonEncode([
                      {"UserID": "$userid", "token": token, "name": name, "picktime":picktime}
                    ]));
              } else {
                String? data = prefs.getString("UserList");
                List DecodeUser = jsonDecode(data!);
                DecodeUser.add(
                    {"UserID": "$userid", "token": token, "name": name,"picktime":picktime});
                prefs.setString("UserList", jsonEncode(DecodeUser));
              }
            } else {
              String token = data['data']['token'];
              String name = data['data']['user']['name'];
              String company = data['data']['user']['company_name'].toString();
              String picktime = data['data']['user']['pick_time'].toString();
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (prefs.getString("UserList") == null) {
                prefs.setString("UserList", jsonEncode([]));
              } else {
                String? data = prefs.getString("UserList");
                List DecodeUser = jsonDecode(data!);
                // DecodeUser.add();
                prefs.setString("UserList", jsonEncode(DecodeUser));
              }
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('token', token);
              prefs.setString('name', name);
              prefs.setString('company', company);
              prefs.setString('picktime', picktime);
              print("do not store data");
            }
            setState(() {
              isLoad = false;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => Switcher(values: 0)));
            });
          }
        } else {
          setState(() {
            isLoad = false;
          });
          print(response.statusCode);
          print(response.body);
          Constants.showtoast("Invalid Email or Password!");
        }
      } else {
        setState(() {
          isLoad = false;
        });
        Constants.showtoast("Email Format is valid!, Please Check");
      }
    } else {
      setState(() {
        isLoad = false;
      });
    }
  }
}
