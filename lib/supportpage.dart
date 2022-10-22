import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/contactBg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: h / 4.5),
              child: SizedBox(
                  height: h / 5,
                  width: w / 1.5,
                  child:
                      Image.asset("assets/images/Arrowmech_Logo_Final-2.png")),
            ),
            Text(
              "Get Support From Our Team",
              style: TextStyle(
                color: Colors.black,
                fontFamily: Constants.regular,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  dialNumber(phoneNumber: '+91 96383 21949', context: context);
                  // _launchCaller();
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.call, color: Constants.mainTheme),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "+91 96383 21949",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: Constants.regular,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  launchUrl(emailLaunchUri);
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.mail,
                    color: Constants.mainTheme,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "hello@arrowmech.com",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: Constants.regular,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              "( click one of them to redirect )",
              style: TextStyle(
                color: Colors.black,
                fontFamily: Constants.regular,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> dialNumber(
      {required String phoneNumber, required BuildContext context}) async {
    final url = "tel:$phoneNumber";
    if (await launch(url)) {
      await launchUrl(Uri.parse(url));
    } else {
      Constants.showtoast("Unable to call");
    }

    return;
  }

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'hello@arrowmech.com',
    query: encodeQueryParameters(<String, String>{
      'subject': 'Example Subject & Symbols are allowed!',
    }),
  );
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
