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



class HomeScreen extends StatefulWidget {


  final QueryDocumentSnapshot snapshot;
  HomeScreen({this.snapshot});
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
    super.initState();
    // Create TabController for getting the index of current tab
    _controller = TabController(length: 4, vsync: this);

    // _controller.addListener(() {
    //   setState(() {
    //     _selectedIndex = _controller.index;
    //   });
    // });
  }

  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey<ScaffoldState>();
  List<Widget> _widgetsList = [
    Index(),
    // Posts(),
    UserMessages(),
    Notifications(),
    Searches(),
  ];
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
          // bottom: TabBar(
          //   labelPadding: EdgeInsets.only(bottom: 10),
          //   indicatorColor: Colors.white,
          //   onTap: (index) {
          //     // Should not used it as it only called when tab options are clicked,
          //     // not when user swapped
          //   },
          //   controller: _controller,
          //   tabs: [
          //     Icon(
          //       Icons.grid_on_sharp,
          //     ),
          //     // Icon(
          //     //   Icons.article,
          //     // ),
          //     Icon(
          //       Icons.message,/
          //     ),
          //     Icon(
          //       Icons.notifications,
          //     ),
          //     Icon(
          //       Icons.search,
          //     ),
          //   ],
          // ),
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
                  Icons.shopping_bag_outlined,
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
          },

          activeColor: Colors.white,
          curveSize: 60,
          backgroundColor: Theme.of(context).primaryColor.withRed(20),

          color: Colors.white,
          // cornerRadius: 20.0,
          height: 35,
          style: TabStyle.reactCircle,
          controller: _controller,
          // initialActiveIndex: 0,
          items: [
            TabItem(icon: Icons.category_rounded),
            TabItem(icon: Icons.message),
            TabItem(icon: Icons.notifications_active_rounded),
            TabItem(icon: Icons.search),
          ],
        ),
        body: Container(child: _widgetsList[_selectedIndex]));
  }
}
