import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class SubMachine extends StatefulWidget {
  String id;
  String name;

  SubMachine({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<SubMachine> createState() => _SubMachineState();
}

class _SubMachineState extends State<SubMachine> {
  final _formKey = GlobalKey<FormState>();
  bool isLoad = false;
  var data;
  late SharedPreferences prefs;
  String? tokenvalue;
  int submachinecount = 0;
  TextEditingController subname = TextEditingController();
  TextEditingController iotID = TextEditingController();
  TextEditingController localID = TextEditingController();

  @override
  void initState() {
    super.initState();
    FetchSubMachineList();
  }

  void FetchSubMachineList() async {
    setState(() {
      isLoad = true;
    });
    prefs = await SharedPreferences.getInstance();
    tokenvalue = prefs.getString("token");
    final response = await http.get(
      Uri.parse('${Constants.weblink}sub-categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
    );
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      print("Sub Machine List");
      print(data);
      submachinecount = data['data']['sub_categories'].length;
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

  void AddSubMachine() async {
    final response = await http.post(
      Uri.parse('${Constants.weblink}sub-categories'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
      body: jsonEncode(<String, String>{
        // "categories": _textFieldController.text,
        "category_id": widget.id,
        "name": subname.text,
        "iot_device_id": iotID.text,
        "local_device_id": localID.text,
      }),
    );
    if (response.statusCode == 200) {
      Constants.showtoast("Machine Added!");
      // _textFieldController.clear();
      FetchSubMachineList();
    } else {
      print(response.statusCode);
      print(response.body);
      Constants.showtoast("Error Fetching Data.");
    }
  }

  void UpdateMachinesMachineList(String id) async {
    print(tokenvalue);
    final response = await http.post(
      Uri.parse('${Constants.weblink}sub-categories/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $tokenvalue',
      },
      body: jsonEncode(<String, String>{
        // '_method': 'PUT',
        "category_id": widget.id,
        "name": subname.text,
        "iot_device_id": iotID.text,
        "local_device_id": localID.text,
      }),
    );
    if (response.statusCode == 200) {
      // data = jsonDecode(response.body);
      Constants.showtoast("Machine Updated!");
      subname.clear();
      iotID.clear();
      localID.clear();
      FetchSubMachineList();
    } else {
      print(response.statusCode);
      print(response.body);
      Constants.showtoast("Error Fetching Data.");
    }
  }

  void deleteMachine(String id) async {
    final response = await http.post(
      Uri.parse('${Constants.weblink}sub-categories/$id'),
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
      FetchSubMachineList();
    } else {
      Constants.showtoast("Error Fetching Data.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return Future(() => FetchSubMachineList());
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
              child: Icon(Icons.arrow_back_outlined,
                  color: Colors.black, size: 25),
            );
          }),
        ),
        body: Column(
          children: [
            Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Sub Machine",
                      style: TextStyle(
                          fontSize: 28, fontFamily: Constants.semibold),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              subname.clear();
                              iotID.clear();
                              localID.clear();
                              _displayTextInputDialog(context);
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Constants.mainTheme,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Add",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: Constants.medium),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ],
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                      ],
                    )
                  ],
                )),
            const SizedBox(
              height: 10,
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
                : (data['data']['sub_categories'].length == 0)
                    ? Container(
                        height: 300,
                        // color: Colors.red,
                        child: Center(
                          child: Text(
                            "No Sub-Machines Currently.",
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
                            itemCount: data['data']['sub_categories'].length,
                            itemBuilder: (context, index) {
                              var submachine =
                                  data['data']['sub_categories'][index];
                              return (widget.id ==
                                      submachine['category_id'].toString())
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 10,
                                          top: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.pink.withOpacity(0.05),
                                        ),
                                        child: Column(
                                          children: <Widget>[
                                            SizedBox(
                                              height: 50,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 15,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: Text(
                                                      submachine['name']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontFamily: Constants
                                                              .semibold),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8,
                                                              bottom: 8,
                                                              right: 20),
                                                      child: SizedBox(
                                                        height: 25,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            GestureDetector(
                                                              child: Image.asset(
                                                                  'assets/icons/edit.png'),
                                                              onTap: () {
                                                                subname.text =
                                                                    submachine[
                                                                            'name']
                                                                        .toString();
                                                                iotID
                                                                    .text = submachine[
                                                                        'iot_device_id']
                                                                    .toString();
                                                                localID
                                                                    .text = submachine[
                                                                        'local_device_id']
                                                                    .toString();
                                                                _updateDialog(
                                                                    context,
                                                                    submachine[
                                                                            'id']
                                                                        .toString());
                                                              },
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                _deleteMachineDialog(
                                                                    context,
                                                                    submachine[
                                                                            'id']
                                                                        .toString());
                                                              },
                                                              child: Image.asset(
                                                                  'assets/icons/delete.png'),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10,
                                                  top: 10,
                                                  left: 20),
                                              color: Colors.white,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "IOT Device ID",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                Constants
                                                                    .medium,
                                                            fontSize: 15),
                                                      ),
                                                      Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      25),
                                                          child: Text(
                                                            submachine[
                                                                    'iot_device_id']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    Constants
                                                                        .regular,
                                                                fontSize: 15),
                                                          )),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Local Device ID",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                Constants
                                                                    .medium,
                                                            fontSize: 15),
                                                      ),
                                                      Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      25),
                                                          child: Text(
                                                            submachine[
                                                                    'local_device_id']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    Constants
                                                                        .regular,
                                                                fontSize: 15),
                                                          )),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container();
                            },
                          ),
                        ),
                      ),
          ],
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
                    height: height / 6,
                    width: width / 1.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'Sub Category Required' : null,
                            controller: subname,
                            style: TextStyle(
                              fontFamily: Constants.medium,
                              // color: Constants.textColor,
                            ),
                            decoration: InputDecoration(
                                hintText: "Sub Category Name",
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 60,
                              width: width / 3.2,
                              child: TextFormField(
                                // keyboardType: TextInputType.number,
                                validator: (value) =>
                                    value!.isEmpty ? 'IOT ID Required' : null,
                                controller: iotID,
                                style: TextStyle(
                                  fontFamily: Constants.medium,
                                  // color: Constants.textColor,
                                ),
                                decoration: InputDecoration(
                                    hintText: "IOT Device ID",
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 20.0, left: 10.0),
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Constants.mainTheme,
                                          width: 2.0),
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
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              height: 60,
                              width: width / 3.2,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    value!.isEmpty ? 'Local Id Required' : null,
                                controller: localID,
                                style: TextStyle(
                                  fontFamily: Constants.medium,
                                  // color: Constants.textColor,
                                ),
                                decoration: InputDecoration(
                                    hintText: "Local Device ID",
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 20.0, left: 10.0),
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Constants.mainTheme,
                                          width: 2.0),
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
                          Navigator.pop(context);
                          AddSubMachine();
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

  Future<void> _updateDialog(BuildContext context, String id) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0))),
            title: Text(
              "Update Machine",
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
                return Form(
                  key: _formKey,
                  child: SizedBox(
                    height: height / 6,
                    width: width / 1.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          child: TextFormField(
                            validator: (value) =>
                                value!.isEmpty ? 'Sub Category Required' : null,
                            controller: subname,
                            style: TextStyle(
                              fontFamily: Constants.medium,
                              // color: Constants.textColor,
                            ),
                            decoration: InputDecoration(
                                hintText: "Sub Category Name",
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
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 60,
                              width: width / 3.2,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    value!.isEmpty ? 'IOT ID Required' : null,
                                controller: iotID,
                                style: TextStyle(
                                  fontFamily: Constants.medium,
                                  // color: Constants.textColor,
                                ),
                                decoration: InputDecoration(
                                    hintText: "IOT Device ID",
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 20.0, left: 10.0),
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Constants.mainTheme,
                                          width: 2.0),
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
                            const SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              height: 60,
                              width: width / 3.2,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    value!.isEmpty ? 'Local Id Required' : null,
                                controller: localID,
                                style: TextStyle(
                                  fontFamily: Constants.medium,
                                  // color: Constants.textColor,
                                ),
                                decoration: InputDecoration(
                                    hintText: "Local Device ID",
                                    contentPadding: const EdgeInsets.only(
                                        bottom: 20.0, left: 10.0),
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Constants.mainTheme,
                                          width: 2.0),
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
                      ],
                    ),
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
                      Navigator.pop(context);
                      UpdateMachinesMachineList(id);
                    }
                  },
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.medium,
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
                          fontFamily: Constants.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> _deleteMachineDialog(BuildContext context, String id) async {
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
                fontFamily: Constants.medium,
              ),
            ),
            actions: <Widget>[
              Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    // Get.back();
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.medium,
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontFamily: Constants.medium,
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    deleteMachine(id);
                  },
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                        fontSize: 16,
                        fontFamily: Constants.medium,
                      )),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red)),
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      // color: Colors.white,
                      fontSize: 16,
                      fontFamily: Constants.medium,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}
