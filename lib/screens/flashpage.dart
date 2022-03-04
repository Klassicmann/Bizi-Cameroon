import 'dart:async';
import 'package:bizi/Logic/check_provider.dart';
import 'package:bizi/screens/introduction.dart';
import 'package:bizi/screens/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login/login.dart';

class FlashPage extends StatefulWidget {
  @override
  _FlashPageState createState() => _FlashPageState();
}

class _FlashPageState extends State<FlashPage> {
  int initScreen;
  @override
  void initState() {
    Timer(Duration(seconds: 4), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      initScreen = prefs.getInt("initScreen");
      await prefs.setInt("initScreen", 1);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return initScreen == 0 || initScreen == null
            ? OnBoardingPage()
            : Provider.of<CheckProvider>(context).getUser != null
                ? Welcome()
                : Login();
      }));
    });
    super.initState();
  }

  final Future<FirebaseApp> _init = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _init,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Stack(
                children: [
                  Image(
                    image: AssetImage('assets/static/bi.png'),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              );
            }));
  }
}
