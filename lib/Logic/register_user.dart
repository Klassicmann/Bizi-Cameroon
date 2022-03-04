import 'package:bizi/screens/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseMessaging _messaging = FirebaseMessaging.instance;

Future registerUser(String username, String email, String pass, String mobile,
    photoUrl, BuildContext context) {
  _auth
      .createUserWithEmailAndPassword(
    email: email,
    password: pass,
  )
      .then((value) async {
    await FirebaseFirestore.instance.collection('users').add(
      {
        'username': username,
        'email': email,
        'phone': mobile,
        'town': '',
        'gender': '',
        'bio': '',
        'photoUrl': photoUrl
      },
    ).whenComplete(() async {
      FirebaseFirestore.instance
          .collection('deviceTokens')
          .add({'device_token': await _messaging.getToken()});
    });

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Welcome();
    }));
  });
}
