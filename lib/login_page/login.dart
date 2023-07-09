import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_7/brand_colors.dart';
import 'package:flutter_application_7/mainpage.dart';
import 'package:flutter_application_7/regestration/regestration.dart';
import 'package:flutter_application_7/widget/progress.dart';
import 'package:flutter_application_7/widget/taxibutton.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Loginpage extends StatelessWidget {
  static const String id = 'login';

  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  void showSnackBar(context, String title) {
    // ignore: unused_local_variable
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(title),
    ));
  }

  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void login(context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProcessDialog('Logging you in'),
    );
    // ignore: unused_local_variable
    final User = (await _auth
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            // ignore: body_might_complete_normally_catch_error
            .catchError((ex) {
      //cheack error and display message
      Navigator.pop(context);
      PlatformException thisEx = ex;
      showSnackBar(context, thisEx.message!);
    }))
        .user;

    Navigator.pop(context);

    if (User != null) {
      // ignore: unused_local_variable
      DatabaseReference userRef =
          FirebaseDatabase.instance.ref().child('users/${User.uid}');

      userRef.once().then((DatabaseEvent databaseEvent) {
        final value = Map<String, String>.from(
            databaseEvent.snapshot.value! as Map<Object?, Object?>);

        // ignore: unnecessary_null_comparison
        if (value != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, MainPage.id, (route) => false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 70,
                ),
                Image(
                  image: AssetImage('images/logo.png'),
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                ),
                SizedBox(
                  height: 70,
                ),
                Text(
                  "Sign In As Rider",
                  style: GoogleFonts.roboto(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: "Email Address",
                            labelStyle: GoogleFonts.roboto(fontSize: 14),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            )),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: debugInstrumentationEnabled,
                        decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: GoogleFonts.roboto(fontSize: 14),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            )),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 70,
                      ),
                      Taxibutton('LOGIN', () async {
                        var connectvityResult =
                            await Connectivity().checkConnectivity();

                        if (connectvityResult != ConnectivityResult.other &&
                            connectvityResult != ConnectivityResult.wifi) {
                          showSnackBar(context, 'No Internet Connectivity');
                        }

                        login(context);
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        prefs.setString('key', emailController.text);
                        Get.to(MainPage());

                        // Obtain shared preferences.
                      }, BrandColors.colorGreen),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Regestration.id, (route) => false);
                    },
                    child: Text(
                      "Don\'t have an account,Sign Up here",
                      style: GoogleFonts.roboto(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
