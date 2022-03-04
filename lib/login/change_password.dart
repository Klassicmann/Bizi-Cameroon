import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'form_feild.dart';
import 'stackcon.dart';

final users = FirebaseFirestore.instance.collection('users');

class ChangePass extends StatefulWidget {
  @override
  _ChangePass createState() => _ChangePass();
}

class _ChangePass extends State<ChangePass> {
  final _formKey = GlobalKey<FormState>();
  bool show = true;
  FirebaseAuth user = FirebaseAuth.instance;

  String email;
  String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              StackCon(
                text: 'Change Password',
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          colors: [
                        Colors.grey.withOpacity(0.4),
                        Colors.blue.withOpacity(0.6)
                      ],
                          stops: [
                        0.6,
                        0.9
                      ])),
                  child: Column(
                    children: [
                      InputField(
                        hint: 'New password',
                        obscureText: show,
                        prefixIcon: Icons.lock,
                        suffixIcon: Icons.remove_red_eye,
                        sufixTap: () {
                          setState(() {
                            show = show ? false : true;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Cannot be empty';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15, left: 30, right: 30),
                        child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Submited')));
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.lightBlueAccent),
                              child: Center(
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
