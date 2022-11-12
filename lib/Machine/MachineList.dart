import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'submachine.dart';

class MachineList extends StatefulWidget {
  const MachineList({Key? key}) : super(key: key);

  @override
  State<MachineList> createState() => _MachineListState();
}

class _MachineListState extends State<MachineList> {
  TextEditingController _textFieldController = TextEditingController();
  bool isLoad = false;
  var data;
  late SharedPreferences prefs;
  String? tokenvalue;
  int machinecount = 0;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    FetchMachinesMachineList();
  }

  void FetchMachinesMachineList() async {
    setState(() {
      isLoad = true;
    });
    prefs = await SharedPreferences.getInstance();
    tokenvalue = prefs.getString("token");
    final response = await http.get(
      Uri.parse('${Constants.weblink}categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
    );
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print("Main Machine List");
      print(data);
      print(data['data']);
      print(data['data']['categories']);
      print(data['data']['categories'].length);
      machinecount = data['data']['categories'].length;
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

  void AddMachinesMachineList() async {
    final response = await http.post(
      Uri.parse('${Constants.weblink}categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
      body: jsonEncode(<String, String>{
        "name": _textFieldController.text,
      }),
    );
    if (response.statusCode == 200) {
      Constants.showtoast("Machine Added!");
      _textFieldController.clear();
      FetchMachinesMachineList();
    } else {
      print(response.statusCode);
      print(response.body);
      Constants.showtoast("Error Fetching Data.");
    }
  }

  void UpdateMachinesMachineList(String id) async {
    print(tokenvalue);
    final response = await http.post(
      Uri.parse('${Constants.weblink}categories/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
      body: jsonEncode(<String, String>{
        // '_method': 'PUT',
        "name": _textFieldController.text,
        // "id": id,
      }),
    );
    if (response.statusCode == 200) {
      // data = jsonDecode(response.body);
      Constants.showtoast("Machine Updated!");
      _textFieldController.clear();
      FetchMachinesMachineList();
    } else {
      print(response.statusCode);
      print(response.body);
      Constants.showtoast("Error Fetching Data.");
    }
  }

  void deleteMachine(int id) async {
    final response = await http.post(
      Uri.parse('${Constants.weblink}categories/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
      body: jsonEncode(<String, String>{
        '_method': "DELETE",
      }),
    );
    if (response.statusCode == 200) {
      Constants.showtoast("Machine Deleted!");
      FetchMachinesMachineList();
    } else {
      Constants.showtoast("Error Fetching Data.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () {
        return Future(() => FetchMachinesMachineList());
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Machine List  ( $machinecount )",
                      style: TextStyle(
                          fontFamily: Constants.semibold,
                          color: Colors.black,
                          fontSize: 24),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Constants.mainTheme),
                        ),
                        onPressed: () {
                          _textFieldController.clear();
                          _displayTextInputDialog(context);
                        },
                        child: Row(
                          children: [
                            Center(
                              child: Text(
                                "Add",
                                style: TextStyle(
                                    fontFamily: Constants.regular,
                                    color: Colors.white,
                                    fontSize: 16),
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 22,
                            ),
                            // SizedBox(
                            //     height: 18,
                            //     child: Image.asset(
                            //         "assets/icons/fluent_add-square-20-regular.png")),
                          ],
                        ))
                  ],
                ),
                const SizedBox(height: 10),
                (isLoad == true)
                    ? Container(
                        height: 500,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Constants.mainTheme,
                          ),
                        ),
                      )
                    :
                (data['data']['categories'].length == 0 )?Container(
                  height: 300,
                  // color: Colors.red,
                  child:  Center(
                    child: Text(
                      "No Machines Currently.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        // fontFamily:
                        // Constants.semibold
                      ),
                    ),
                  ),
                ):Expanded(
                        child: ListView.builder(
                            itemCount: data['data']['categories'].length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  color: Colors.pinkAccent.withOpacity(0.02),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          // Text(
                                          //   "${index+1}.",
                                          //   style: TextStyle(
                                          //       fontFamily: Constants.regular,
                                          //       color: Colors.black,
                                          //       fontSize: 20),
                                          // ),
                                          // SizedBox(width: 20),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SubMachine(
                                                            id: data['data']['categories'][index]
                                                                    ['id']
                                                                .toString(),
                                                            name: data['data']['categories'][index][
                                                                    'name']
                                                                .toString(),
                                                          )));
                                            },
                                            child: Container(
                                              height: h / 25,
                                              width: w / 1.6,
                                              child: Text(
                                                data['data']['categories']
                                                        [index]['name']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontFamily:
                                                        Constants.regular,
                                                    color: Colors.black,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _textFieldController.text =
                                                  data['data']['categories'][index]['name'];
                                              updatemachine(context,
                                                  data['data']['categories'][index]['id'].toString());
                                            },
                                            child: SizedBox(
                                                height: 22,
                                                child: Image.asset(
                                                    "assets/icons/fluent_data-usage-edit-20-regular.png")),
                                          ),
                                          SizedBox(width: 10),
                                          IconButton(
                                              onPressed: () {
                                                _deleteMachineDialog(
                                                    context, data['data']['categories'][index]['id']);
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                color: Constants.mainTheme,
                                                size: 22,
                                              ))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              title: Text(
                "Add New Machine",
                style: TextStyle(
                  // color: Colors.white,
                  fontSize: 20,
                  fontFamily: Constants.regular,
                ),
              ),
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;
                  return SizedBox(
                    height: height / 12,
                    width: width / 1.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'Machine name required' : null,
                            controller: _textFieldController,
                            style: TextStyle(
                              fontFamily: Constants.medium,
                              // color: Constants.textColor,
                            ),
                            decoration: InputDecoration(
                                hintText: "Machine Name",
                                contentPadding: const EdgeInsets.only(
                                    bottom: 20.0, left: 10.0),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Constants.mainTheme, width: 2.0),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                filled: true,
                                hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontFamily: Constants.medium,
                                    fontSize: 14),
                                labelStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontFamily: Constants.medium,
                                    fontSize: 14),
                                // hintText: "first name",
                                fillColor: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              actions: <Widget>[
                SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();
                          // print(_textFieldController.text);
                          AddMachinesMachineList();
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                          textStyle:
                              MaterialStateProperty.all<TextStyle>(TextStyle(
                            fontSize: 16,
                            fontFamily: Constants.medium,
                          )),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Constants.mainTheme)),
                      child: Text(
                        "Add",
                        style: TextStyle(
                          // color: Colors.white,
                          fontSize: 16,
                          fontFamily: Constants.medium,
                        ),
                      ),
                    )),
              ],
            ),
          );
        });
  }

  Future<void> updatemachine(BuildContext context, String id) async {
    final w = MediaQuery.of(context).size.width;
    final GlobalKey<FormState> _key = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _key,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              title: Text(
                "Update Machine",
                style: TextStyle(
                  // color: Colors.white,
                  fontSize: 20,
                  fontFamily: Constants.semibold,
                ),
              ),
              content: SizedBox(
                height: 60,
                width: w * 0.25,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required.';
                    }
                    return null;
                  },
                  controller: _textFieldController,
                  style: TextStyle(
                    fontFamily: Constants.regular,
                    // color: Constants.textColor,
                  ),
                  decoration: InputDecoration(
                      labelText: "Machine Name",
                      hintText: "Enter Machine Name",
                      contentPadding:
                          const EdgeInsets.only(bottom: 10.0, left: 10.0),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Constants.mainTheme, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: Constants.regular,
                          fontSize: 14),
                      labelStyle: TextStyle(
                          color: Colors.grey[400],
                          fontFamily: Constants.regular,
                          fontSize: 14),
                      // hintText: "first name",
                      fillColor: Colors.white70),
                ),
              ),
              actions: <Widget>[
                Container(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_key.currentState!.validate()) {
                          _key.currentState!.save();
                          Navigator.pop(context);
                          UpdateMachinesMachineList(id);
                        }
                      });
                    },
                    style: ButtonStyle(
                        textStyle:
                            MaterialStateProperty.all<TextStyle>(TextStyle(
                          fontSize: 16,
                          fontFamily: Constants.regular,
                        )),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Constants.mainTheme)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Icon(
                          Icons.update,
                          color: Colors.white,
                          size: 16,
                        ),
                        Text(
                          "Update",
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 14,
                            fontFamily: Constants.regular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _deleteMachineDialog(BuildContext context, int id) async {
    final w = MediaQuery.of(context).size.width;
    final GlobalKey<FormState> _key = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            title: Text(
              "Are you sure to Delete ?",
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
                      deleteMachine(id);
                      Navigator.pop(context);
                    });
                  },
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.regular,
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red)),
                  child: Text(
                    "Delete",
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
