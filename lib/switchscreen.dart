import 'package:arrowmech/Machine/MachineList.dart';
import 'package:arrowmech/Machine/customreport.dart';
import 'package:arrowmech/profile/profilepage.dart';
import 'package:arrowmech/Auth/switchuser.dart';
import 'package:arrowmech/supportpage.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

import 'Machine/ViewReport.dart';
import 'constants.dart';

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
              height: 45,
              child: Image.asset("assets/icons/Arrowmech.png")),
          centerTitle: true,
          elevation: 0,
          leading: Builder(builder: (context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: Icon(Icons.menu, color: Colors.black, size: 25),
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
                    SizedBox(height: 20),
                    Text(
                      "Welcome To",
                      style: TextStyle(
                          fontFamily: Constants.regular,
                          color: Colors.white,
                          fontSize: 25),
                    ),
                    Text(
                      "Company Name",
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
                    SizedBox(width: 10),
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
                    SizedBox(width: 10),
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
              ),              ListTile(
                title: Row(
                  children: [
                    SizedBox(
                        height: 25,
                        width: 25,
                        child: Image.asset("assets/icons/machinelist.png")),
                    SizedBox(width: 10),
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
                    SizedBox(width: 10),
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
                    SizedBox(width: 10),
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
