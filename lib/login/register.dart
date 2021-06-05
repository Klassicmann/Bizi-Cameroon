import 'package:bizi/screens/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'form_feild.dart';
import 'login.dart';
// import 'stackcon.dart';

final users = FirebaseFirestore.instance.collection('users');

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  bool show = true;
  String phone;

  bool _async = false;
  @override
  Widget build(BuildContext context) {
    Future registerUser(
        String username, String email, String pass, String mobile, photoUrl) {
      setState(() {
        _async = true;
      });
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
        );
        setState(() {
          _async = false;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return Welcome();
        }));
      });
    }

    final articles = FirebaseFirestore.instance.collection('articles');
    print(articles);

    return Scaffold(
      resizeToAvoidBottomInset:true,
      backgroundColor: Color(0xFF0D415D),
      body: ModalProgressHUD(
        inAsyncCall: _async,
        color: Colors.orange,
        child: Form(
            key: _formKey,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Image(
                    image: AssetImage('assets/static/Login2.png'),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                      // gradient: LinearGradient(
                      //     begin: Alignment.topCenter,
                      //     colors: [
                      //   Colors.blueGrey,
                      //   Colors.black,
                      // ],
                      //     stops: [
                      //   0.6,
                      //   0.9
                      // ])
                      ),
                  child: Container(
                    child: Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Text(
                              'Enter your information to create your free account today!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.k2d(
                                  color: Colors.black,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15),
                            ),
                          ),
                          InputField(
                            controller: _usernameController,
                            hint: 'Username...',
                            // prefixIcon: Icons.supervised_user_circle,
                            image:
                                'assets/static/icons8_Male_User_50px.png',
                            suffiximage: Container(
                              child: Text(''),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter your username';
                              }
                              return null;
                            },
                          ),
                          InputField(
                            controller: _emailController,
                            hint: 'Email...',
                            image: 'assets/static/icons8_Email_50px_1.png',
                            suffiximage: Container(
                              child: Text(''),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter text';
                              }
                              return null;
                            },
                          ),
                          InputField(
                            // inputFormatters: [
                            //   // [LengthLimitingTextInputFormatter(9)]
                            // ],
                            controller: _phoneController,
                            hint: 'Phone number...',
                            image:
                                'assets/static/icons8_Blackberry_50px.png',
                            suffiximage: Container(
                              child: Text(''),
                            ),
                            // helper: 'Format 2376XXXXXXXX',
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter phone number';
                              }
                              return null;
                            },
                          ),
                          InputField(
                            controller: _passController,
                            hint: 'Password...',
                            obscureText: show,
                            image: 'assets/static/icons8_Shutdown_50px.png',
                            suffiximage: Image(
                              image: AssetImage(
                                  'assets/static/icons8_Eye_48px_1.png'),
                              height: 15,
                              width: 18,
                              fit: BoxFit.cover,
                            ),
                            sufixTap: () {
                              setState(() {
                                show = show ? false : true;
                              });
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Enter text';
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 15, left: 30, right: 30),
                            child: GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState.validate()) {
                                    final mobile =
                                        _phoneController.text.trim();
                                    final email =
                                        _emailController.text.trim();
                                    final pass =
                                        _passController.text.trim();
                                    final username =
                                        _usernameController.text.trim();
                                    final photoUrl =
                                        'https://www.google.com/url?sa=i&url=https%3A%2F%2Fdepositphotos.com%2Fvector-images%2Fdefault-profile-picture.html&psig=AOvVaw1gtFi7dCIJK17XV1XcCAFw&ust=1613741614097000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCKC16Z7G8-4CFQAAAAAdAAAAABAD';

                                    registerUser(username, email, pass,
                                        mobile, photoUrl);
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
                                      'Submit',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                    ),
                                  ),
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 70, top: 10),
                            child: Row(
                              children: [
                                Text('Already have an account?'),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return Login();
                                  })),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

// Future registerUser(
//     String email, String pass, String mobile, BuildContext context) async {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   _auth.verifyPhoneNumber(
//       phoneNumber: mobile,
//       timeout: Duration(seconds: 60),
//       verificationCompleted: (AuthCredential authCredi) {
//         _auth
//             .createUserWithEmailAndPassword(email: email, password: pass)
//             .then((value) async{
//           await FirebaseFirestore.instance.collection('users') .add({
//             'email':email,
//             'phone': mobile
//           });
//           Navigator.pushReplacement(context,
//               MaterialPageRoute(builder: (context) {
//             return Welcome();
//           }));
//         });
//       },
//       verificationFailed: (FirebaseAuthException authException) {
//         print(authException);
//       },
//       codeSent: (String veriId, [int forceResendingToken]) async {
//         String code;
//         code = await Navigator.push(context,
//             MaterialPageRoute(builder: (context) {
//           return GetCode();
//         }));
//         PhoneAuthCredential _credential = PhoneAuthProvider.credential(
//             verificationId: veriId, smsCode: code);
//         await _auth.signInWithCredential(_credential).then((value) {
//           _auth
//               .createUserWithEmailAndPassword(email: email, password: pass)
//               .then((value) {
//             Navigator.push(context, MaterialPageRoute(builder: (context) {
//               return Welcome();
//             }));
//           });
//         });
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         verificationId = verificationId;
//         print(verificationId);
//         print("Timout");
//       });
// }
