import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:user_fyp/splashScreen/splash_screen.dart';
import 'package:user_fyp/test.dart';

import 'BBC LONDON/map_sscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp(
      child: MaterialApp(
    title: 'Users App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MySplashScreen(),

    //home: TrackingButton(),

    debugShowCheckedModeBanner: false,
  )));
}

class MyApp extends StatefulWidget {
  final Widget? child;

  MyApp({this.child});
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }
  //const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      child: widget.child!,
    );
  }
}
