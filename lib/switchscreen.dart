
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Auth/switchuser.dart';
import 'Machine/MachineList.dart';
import 'Machine/ViewReport.dart';
import 'Machine/customreport.dart';
import 'constants.dart';
import 'supportpage.dart';

class Switcher extends StatefulWidget {
  int values;

  Switcher({Key? key, required this.values}) : super(key: key);

  @override
  State<Switcher> createState() => _SwitcherState();
}

class _SwitcherState extends State<Switcher> {
  late int currentpage;
  bool isLoad = false;
  String UserName = '';
  String? companyname = "";

  List getPages = [
    const ViewReport(),
    const CustomReport(),
    const MachineList(),
    const SwitchUser(),
    const SupportPage(),
  ];

  @override
  void initState() {
    super.initState();
    currentpage = widget.values;
    getcompany();
  }

  Future<void> getcompany() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    companyname = prefs.getString("company");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DoubleBackToCloseApp(
          child: getPages[currentpage],
          snackBar: const SnackBar(
            content: Text('Tap back again to leave'),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: SizedBox(
              height: 45, child: Image.asset("assets/icons/Arrowmech.png")),
          centerTitle: true,
          elevation: 0,
          leading: Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
                getcompany();
              },
              child: const Icon(Icons.menu, color: Colors.black, size: 25),
            );
          }),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Constants.mainTheme,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SizedBox(
                              height: 25,
                              width: 25,
                              child:
                                  Image.asset("assets/icons/menu-close.png")),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Welcome",
                      style: TextStyle(
                          fontFamily: Constants.regular,
                          color: Colors.white,
                          fontSize: 25),
                    ),
                    (companyname == "null")
                        ? Text(
                            "Company Name",
                            style: TextStyle(
                                fontFamily: Constants.semibold,
                                color: Colors.white,
                                fontSize: 30),
                          )
                        : Text(
                            companyname!.toString(),
                            style: TextStyle(
                                fontFamily: Constants.semibold,
                                color: Colors.white,
                                fontSize: 30),
                          ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset("assets/icons/report.png")),
                    const SizedBox(width: 10),
                    Text(
                      'View Report',
                      style: TextStyle(
                          fontFamily: Constants.semibold, fontSize: 16),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    currentpage = 0;
                  });
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset("assets/icons/machinelist.png")),
                    const SizedBox(width: 10),
                    Text(
                      'Custom Report',
                      style: TextStyle(
                          fontFamily: Constants.semibold, fontSize: 16),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    currentpage = 1;
                  });
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset("assets/icons/machinelist.png")),
                    const SizedBox(width: 10),
                    Text(
                      'Machine List',
                      style: TextStyle(
                          fontFamily: Constants.semibold, fontSize: 16),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    currentpage = 2;
                  });
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset("assets/icons/user.png")),
                    const SizedBox(width: 10),
                    Text(
                      'User Profile',
                      style: TextStyle(
                          fontFamily: Constants.semibold, fontSize: 16),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    currentpage = 3;
                  });
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset("assets/icons/support.png")),
                    const SizedBox(width: 10),
                    Text(
                      'Support',
                      style: TextStyle(
                          fontFamily: Constants.semibold, fontSize: 16),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    currentpage = 4;
                  });
                },
              ),
            ],
          ),
        )
        // body: getPage(widget.values),
        );
  }
}
