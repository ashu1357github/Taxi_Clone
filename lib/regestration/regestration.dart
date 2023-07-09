import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_7/brand_colors.dart';
import 'package:flutter_application_7/login_page/login.dart';
import 'package:flutter_application_7/mainpage.dart';
import 'package:flutter_application_7/widget/progress.dart';
import 'package:flutter_application_7/widget/taxibutton.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class Regestration extends StatefulWidget {
  static const String id = 'register';

  @override
  State<Regestration> createState() => _RegestrationState();
}

class _RegestrationState extends State<Regestration> {
  final GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  void showSnackBar(context, String title) {
    // ignore: unused_local_variable
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(title),
    ));
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController = TextEditingController();

  var emailController = TextEditingController();

  var phonenoController = TextEditingController();

  var passwordController = TextEditingController();

  void registerUser() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProcessDialog('Registering you...'),
    );
    final User = (await _auth
            .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            // ignore: body_might_complete_normally_catch_error
            .catchError((ex) {
      Navigator.pop(context);
      //cheack error and display message

      PlatformException thisEx = ex;
      showSnackBar(context, thisEx.message!);
    }))
        .user;
    Navigator.pop(context);
    if (User != null) {
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.ref().child('users/${User.uid}');

      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phonenoController.text,
        'password': passwordController.text,
      };
      newUserRef.set(userMap);

      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
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
                  " Create a Rider\'s Account",
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
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            labelText: "Full Name",
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
                        controller: phonenoController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            labelText: "Phone Number",
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
                      Taxibutton('REGESTRATION', () async {
                        var connectvityResult =
                            await Connectivity().checkConnectivity();

                        if (connectvityResult != ConnectivityResult.other &&
                            connectvityResult != ConnectivityResult.wifi) {
                          showSnackBar(context, 'No Internet Connectivity');
                        }
                        if (fullNameController.text.length < 3) {
                          showSnackBar(
                              context, 'Please provide a valid Fullname');
                          return;
                        }

                        if (phonenoController.text.length < 10) {
                          showSnackBar(
                              context, 'Please provide a valid PhoneNumber');
                          return;
                        }

                        if (passwordController.text.length < 8) {
                          showSnackBar(
                              context, 'Please provide a valid Email Address');
                          return;
                        }

                        registerUser();
                      }, BrandColors.colorGreen),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Loginpage.id, (route) => false);
                    },
                    child: Text(
                      "Already have a RIDER account? Log In",
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
