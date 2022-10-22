import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:arrowmech/switchscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool session = false;
  bool isLoad = false;
  List UserData = [];  bool _isObscure = true;

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
                          const EdgeInsets.only(left: 80, right: 80, top: 60),
                      child: Image.asset(
                          "assets/images/Arrowmech_Logo_Final-2.png"),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    "Welcome To",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        fontFamily: Constants.regular),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Flowmeter Monitoring",
                      style: TextStyle(
                          fontFamily: Constants.semibold, fontSize: 34),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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

                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(10.0),
                              ),
                              filled: false,
                              hintText: "  Password",
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
                      Text(
                        "Remember Me",
                        style: TextStyle(
                            fontFamily: Constants.regular, fontSize: 15),
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
                  )
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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('userid', userid);
              prefs.setString('token', token);
              prefs.setString('name', name);
              prefs.getString("UserList");

              if (prefs.getString("UserList") == null) {
                prefs.setString(
                    "UserList",
                    jsonEncode([
                      // { "token": token, "name": name}
                      {"UserID": "$userid", "token": token, "name": name}
                    ]));
              } else {
                String? data = prefs.getString("UserList");
                List DecodeUser = jsonDecode(data!);
                DecodeUser.add(
                    // {"token": token, "name": name});
                    {"UserID": "$userid", "token": token, "name": name});
                prefs.setString("UserList", jsonEncode(DecodeUser));
              }
            } else {
              String token = data['data']['token'];
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('token', token);
              print("do not store data");
            }
            setState(() {
              isLoad = false;
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => Switcher(values: 0)));
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
