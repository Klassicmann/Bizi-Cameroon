import 'package:bizi/screens/home.dart';
import 'package:bizi/screens/sell_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  showNotification() {
    toast('Hello klassic mann');
  }

  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    _animationController.forward();
    _animationController.addListener(() {
      setState(() {});
    });

    _animation = ColorTween(
      begin: Colors.red,
      end: Colors.blue,
    ).animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User _user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              String _username;
              String _email;
              QueryDocumentSnapshot doc;
              snapshot.data.docs.forEach((e) {
                if (e.data()['email'] == _user.email) {
                  doc = e;
                }
              });

              _username = doc.data()['username'];

              _email = _user.email;
              return Stack(children: [
                Image(
                  image: AssetImage(
                      'assets/static/500_F_281008268_xXeSCjxFNr12ncCcL8cmMCxCH36fWaAK.jpg'),
                  fit: BoxFit.cover,
                  height: double.infinity,
                ),
                Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.7)),
                ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        top: 100,
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 50, horizontal: 30),
                      decoration: BoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Hi,',
                            style: GoogleFonts.k2d(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            _username,
                            style: GoogleFonts.k2d(
                                fontSize: 25,
                                color: Colors.orange,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'What do you want to do today?',
                            style: GoogleFonts.k2d(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            focusColor: Colors.red,
                            hoverColor: Colors.black38,
                            splashColor: Colors.yellow,
                            child: Container(
                              padding: EdgeInsets.only(left: 0),
                              height: 35,
                              decoration: BoxDecoration(
                                  color: Color(0xFF0D415D),
                                  borderRadius: BorderRadius.circular(25)),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return HomeScreen(
                                      snapshot: doc,
                                      // email: _email,
                                      // message: 'Nothing to show for now',
                                    );
                                  }));
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.money_off,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'I want to buy an article',
                                      style: GoogleFonts.k2d(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: MaterialButton(
                              onPressed: () async {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return SellForm(
                                    snap: doc,
                                  );
                                }));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                width: MediaQuery.of(context).size.width / 1.9,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.attach_money,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'I want to sell ',
                                      style: GoogleFonts.k2d(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              // color: Colors.orange,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: MaterialButton(
                              onPressed: showNotification,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                width: MediaQuery.of(context).size.width / 2.3,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.store,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'My Store ',
                                      style: GoogleFonts.k2d(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Color(0XFF223322),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]);
            }),
      ),
    );
  }
}
