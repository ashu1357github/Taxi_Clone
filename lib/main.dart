import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_7/dataprovider/appdata.dart';
import 'package:flutter_application_7/firebase_options.dart';
import 'package:flutter_application_7/login_page/login.dart';
import 'package:flutter_application_7/mainpage.dart';
import 'package:flutter_application_7/regestration/regestration.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => appdata(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: Loginpage.id,
        routes: {
          Regestration.id: (context) => Regestration(),
          Loginpage.id: (context) => Loginpage(),
          MainPage.id: (context) => MainPage(),
        },
      ),
    );
  }
}
