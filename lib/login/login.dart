import 'package:bizi/screens/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'form_feild.dart';
import 'phone_confirm.dart';
import 'register.dart';

final users = FirebaseFirestore.instance.collection('users');

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool show = true;

  AnimationController _controller;
  Animation _animation;
  bool isComplete = false;
  double screenHeight;

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    //Login screen background image animation initialised
    _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 10),
        upperBound: 700,
        lowerBound: 620);

    _controller.forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isComplete = true;
        });
      } else {
        setState(() {
          isComplete = false;
        });
      }
    });
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    String email;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Form(
            key: _formKey,
            
            child: Column(
            
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: Stack(
                        // alignment: AlignmentDirectional.center,
                        children: [
                          Image(
                              image: AssetImage('assets/static/Login2.png'),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity),
                          ListView(
                            shrinkWrap: true,
                            children: [
                              Container(
                                padding: EdgeInsets.only(top: 250),
                                // constraints: BoxConstraints(maxHeight: 100),
                                child: Column(
                                  children: [
                                    // InputField(
                                    //   hint: 'Username or email',
                                    //   prefixIcon: Icons.supervised_user_circle,
                                    //   validator: (value) {
                                    //     if (value.isEmpty) {
                                    //       return 'Enter text';
                                    //     }
                                    //     return null;
                                    //   },
                                    // ),
                                    Container(
                                      child: Text(
                                        'Login to your account!',
                                        style: GoogleFonts.k2d(
                                            fontSize: 20,
                                            color: Colors.blueGrey),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    InputField(
                                      controller: _emailController,
                                      // prefixText: '+237',rf
                                      hint: 'Enter your email...',
                                      suffiximage: Container(child: Text(''),),
                                      image:
                                          'assets/static/icons8_Male_User_50px.png',
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Email cannot be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                    InputField(
                                      controller: _passController,
                                      hint: 'Password...',
                                      obscureText: show,
                                      // prefixIcon: Icons.lock,
                                      image:
                                          'assets/static/icons8_Shutdown_50px.png',
                                      // suffiximage: 'assets/static/icons8_Eye_48px_1.png',
                                      suffiximage: Image(
                                        image: AssetImage(
                                            'assets/static/icons8_Eye_48px_1.png'),
                                        height: 15,
                                        width: 18,
                                        fit: BoxFit.cover,
                                      ),
                                      // suffixIcon: Icons.remove_red_eye,
                                      sufixTap: () {
                                        setState(() {
                                          show = show ? false : true;
                                        });
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'password cannot be empty';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 50),
                                      child: GestureDetector(
                                          onTap: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              final _userEmail =
                                                  _emailController.text.trim();
                                              final _password =
                                                  _passController.text.trim();
                                              setState(() {
                                                loading = true;
                                              });

                                              await _firebaseAuth
                                                  .signInWithEmailAndPassword(
                                                      email: _userEmail,
                                                      password: _password)
                                                  .then((value) {
                                                setState(() {
                                                  loading = false;
                                                });
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(
                                                        builder: (context) {
                                                  return Welcome();
                                                }));
                                              });
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black),
                                            child: Center(
                                              child: Text(
                                                'Login',
                                                style: GoogleFonts.k2d(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17),
                                              ),
                                            ),
                                          )),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ConfirmPhone())),
                                        child: Text(
                                          'I forgot my password',
                                          style: GoogleFonts.k2d(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.5),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Don\'t have an account?',
                                          style:
                                              TextStyle(color: Colors.black87),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return Register();
                                          })),
                                          child: Text(
                                            'Register',
                                            style: TextStyle(
                                                color: Colors.blueAccent,
                                                fontSize: 15.5,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ]),
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
