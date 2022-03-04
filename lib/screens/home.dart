import 'package:bizi/login/login.dart';
import 'package:bizi/screens/index.dart';
import 'package:bizi/screens/notifications.dart';
import 'package:bizi/screens/searches.dart';
import 'package:bizi/screens/user_messages.dart';
import 'package:bizi/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_gifs/loading_gifs.dart';

class HomeScreen extends StatefulWidget {
  final QueryDocumentSnapshot snapshot;

  HomeScreen({
    this.snapshot,
  });
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  int _selectedIndex = 0;
  List<Widget> list = [];
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      id = widget.snapshot.id;
    });
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = TabController(length: 4, vsync: this);
  }

  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  String id;
  List<Widget> _widgetsList = [
    Index(),
    // Posts(),
    UserMessages(),
    Notifications(),
    Searches(),
  ];
  bool tapped = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scafoldKey,
        drawer: Drawer(
          child: DrawerBuilder(
            snapshot: widget.snapshot,
          ),
        ),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              _scafoldKey.currentState.openDrawer();
            },
            child: Container(
              child: Icon(Icons.menu),
            ),
          ),
          // leading: IconButton(icon:Icon(Icons.supervised_user_circle, size: 30,), onPressed: (){}),
          title: Text(
            'bizi market',
            style: GoogleFonts.allerta(
              fontSize: 25,
            ),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.favorite_outline,
                  size: 30,
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) =>
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Login();
                      })));
                })
          ],
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor.withRed(20),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        bottomNavigationBar: ConvexAppBar(
          onTap: (val) {
            setState(() {
              _selectedIndex = val;
            });
            if (val == 1) {
              setState(() {
                tapped = true;
              });
            } else {
              setState(() {
                tapped = false;
              });
            }
          },

          activeColor: Colors.white,
          curveSize: 60,
          backgroundColor: Theme.of(context).primaryColor.withRed(20),

          color: Colors.white,
          // cornerRadius: 20.0,
          height: 40,
          style: TabStyle.reactCircle,
          controller: _controller,
          // initialActiveIndex: 0,
          items: [
            TabItem(icon: Icons.category_rounded),
            tapped
                ? TabItem(icon: Icons.message)
                : TabItem(
                    icon: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('messages')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator();
                          }
                          final _user = FirebaseAuth.instance.currentUser.email;
                          final data = snapshot.data.docs;
                          List allmess = [];
                          data.forEach((mess) {
                            if (mess['sender'] == _user ||
                                mess['receiver'] == _user) {
                              allmess.add(mess);
                            }
                          });
                          allmess.removeWhere((element) =>
                              element['sender'] == _user &&
                              element['receiver'] == _user);

                          List notSeenMessages = [];
                          allmess.forEach((element) {
                            if (!element['seen']) {
                              if (element['sender'] != _user) {
                                notSeenMessages.add(element);
                              }
                            }
                          });

                          return Container(
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.message,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 2.5, vertical: 0.7),
                                      decoration: BoxDecoration(
                                          color: notSeenMessages.length != 0
                                              ? Colors.redAccent
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      child: notSeenMessages.length != 0
                                          ? Text(
                                              notSeenMessages.length.toString(),
                                              // '9+',
                                              style: GoogleFonts.k2d(
                                                  color: Colors.white,
                                                  fontSize: 12))
                                          : Container()),
                                )
                              ],
                            ),
                          );
                        })),
            TabItem(icon: Icons.notifications_active_rounded),
            TabItem(icon: Icons.search),
          ],
        ),
        body: Container(child: _widgetsList[_selectedIndex]));
  }
}
