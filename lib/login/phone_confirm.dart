import 'package:bizi/login/form_feild.dart';
import 'package:bizi/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ResetPass extends StatefulWidget {
  @override
  _ResetPassState createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool loading = false;
  bool obscureText = true;
  bool sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Reset Password'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Form(
            key: _formKey,
            child: Container(
              child: ListView(
                children: [
                  // Padding(
                  //   padding: EdgeInsets.all(20),
                  //   child: Text(
                  //     'Enter your email and we will send you password confirmation link in your inbox',
                  //     style: GoogleFonts.k2d(
                  //       fontSize: 18,
                  //     ),
                  //   ),
                  // ),
                  sent
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Text(
                                'Password reset link sent successfully. Please check your mail.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.k2d(
                                    color: Colors.black87, fontSize: 19)),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 30),
                          child: Column(children: [
                            Center(
                                child: MaterialButton(
                              onPressed: () {},
                              child: Text(
                                'Enter your email and we will send you a link to reset your password',
                                style: GoogleFonts.k2d(
                                  color: Colors.black87,
                                  fontSize: 16,
                                ),
                              ),
                            )),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    hintText: 'Enter your email'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 20),
                              child: MaterialButton(
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });

                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: _emailController.text.trim())
                                        .whenComplete(() {
                                      _emailController.clear();
                                      setState(() {
                                        loading = false;
                                        sent = true;
                                      });
                                    }).catchError((error) {
                                      print(error);
                                    });
                                  }
                                },
                                child: Text(
                                  'Reset Password',
                                  style: GoogleFonts.k2d(
                                      color: Colors.white, fontSize: 17),
                                ),
                                color: Colors.lightBlue,
                              ),
                            ),
                          ]),
                        ),
                ],
              ),
            ),
          ),
        ));
  }
}
// Padding(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 40, vertical: 20),
//                             child: MaterialButton(
//                               onPressed: () async {
//                                 if (_formKey.currentState.validate()) {
//                                   setState(() {
//                                     loading = true;
//                                   });

//                                   await FirebaseAuth.instance
//                                       .sendPasswordResetEmail(
//                                           email: _emailController.text.trim())
//                                       .whenComplete(() {
//                                     _emailController.clear();
//                                     setState(() {
//                                       loading = false;
//                                       sent = true;
//                                     });
//                                   }).catchError((error) {
//                                     print(error);
//                                   });
//                                 }
//                               },
//                               child: Text(
//                                 'Reset Password',
//                                 style: GoogleFonts.k2d(
//                                     color: Colors.white, fontSize: 17),
//                               ),
//                               color: Colors.lightBlue,
//                             ),
//                           ),