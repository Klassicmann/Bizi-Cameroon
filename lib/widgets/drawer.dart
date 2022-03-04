import 'package:bizi/login/login.dart';
import 'package:bizi/models/user.dart';
import 'package:bizi/screens/favourites.dart';
import 'package:bizi/screens/profile.dart';
import 'package:bizi/screens/sell_form.dart';
import 'package:bizi/screens/help.dart';
import 'package:bizi/screens/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerBuilder extends StatelessWidget {
  final QueryDocumentSnapshot snapshot;
  DrawerBuilder({this.snapshot});
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    Cuser cuser;

    cuser = Cuser(
        username: snapshot.data()['username'],
        email: snapshot.data()['email'],
        phone: snapshot.data()['phone'],
        town: snapshot.data()['town'],
        bio: snapshot.data()['bio'],
        profileImage: snapshot.data()['photoUrl'],
        coverImage: snapshot.data()['coverImage'],
        snapshot: snapshot
        // job: snapshot.data()['job'],
        );
    return Container(
      width: MediaQuery.of(context).size.width / 1.9,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(
                            user: cuser,
                          )));
            },
            child: Container(
              height: 170,
              child: Stack(
                children: [
                  Image(
                    image: snapshot.data()['coverImage'] != null
                        ? NetworkImage(snapshot.data()['coverImage'])
                        : AssetImage(
                            'assets/static/avekenedy.jpg',
                          ),
                    fit: BoxFit.cover,
                    height: 170,
                    width: double.infinity,
                  ),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width / 1.5,
                          color: Colors.black54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(snapshot.data()['username'],
                                  style: GoogleFonts.k2d(
                                      fontSize: 20, color: Colors.white)),
                              Icon(
                                Icons.verified_user,
                                color: Colors.white,
                              )
                            ],
                          ))),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Container();
                      })),
                      child: DrawerListItems(
                        icon: Icons.library_books,
                        title: 'My List',
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black54,
                      indent: 3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    DrawerListItems(
                      icon: Icons.shop,
                      title: 'Shops',
                      tap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Accounts()));
                      },
                    ),
                    Divider(
                      height: 5,
                      color: Colors.black54,
                      indent: 3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    DrawerListItems(
                      icon: Icons.favorite,
                      title: 'Favorites',
                      tap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Favourites(
                                      id: snapshot.id,
                                    )));
                      },
                    ),
                    Divider(
                      height: 5,
                      color: Colors.black54,
                      indent: 3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SellForm(
                                    snap: snapshot,
                                  ))),
                      child: DrawerListItems(
                        icon: Icons.flash_on_outlined,
                        title: 'Quick sell',
                      ),
                    ),
                    Divider(
                      height: 5,
                      color: Colors.black54,
                      indent: 3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    DrawerListItems(
                      icon: Icons.shopping_bag_outlined,
                      title: 'My shop',
                    ),
                    Divider(
                      height: 5,
                      color: Colors.black54,
                      indent: 3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Signout'),
                                content: Text('Confirm signout'),
                                actions: [
                                  MaterialButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('signout'),
                                  ),
                                  MaterialButton(
                                    onPressed: () => FirebaseAuth.instance
                                        .signOut()
                                        .whenComplete(() =>
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Login()))),
                                    child: Text('cancel'),
                                  ),
                                ],
                              );
                            });
                      },
                      child: DrawerListItems(
                        icon: Icons.logout,
                        title: 'Logout',
                      ),
                    ),
                    Divider(
                      height: 5,
                      color: Colors.black54,
                      indent: 3,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Help())),
                      child: DrawerListItems(
                        icon: Icons.help_outline,
                        title: 'Help',
                      ),
                    ),
                  ],
                )),
          ),
          // Container(
          //   height: 50,
          //   color: Colors.black,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       SignalButton(
          //         icon: Icons.notifications,
          //         numb: 5,
          //       ),
          //       SignalButton(
          //         icon: Icons.settings,
          //       ),
          //       SignalButton(
          //         icon: Icons.share,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class DrawerListItems extends StatelessWidget {
  DrawerListItems({this.icon, this.title, this.tap});
  final IconData icon;
  final String title;
  final Function tap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        margin: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Icon(
                icon,
                size: 26,
                color: Color(0xFAA09FB8),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(title,
                  style: GoogleFonts.k2d(fontSize: 20, color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}

class SignalButton extends StatelessWidget {
  final IconData icon;
  final int numb;
  final bool home;
  SignalButton({this.icon, this.numb, this.home = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Stack(
        children: [
          IconButton(
              icon: Icon(
                icon,
                color: home ? Colors.white : Colors.white,
                size: 25,
              ),
              onPressed: () {}),
          Positioned(
            top: 10,
            right: 10,
            child: numb != null
                ? Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      numb.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 10),
                    ),
                  )
                : Text(''),
          )
        ],
      ),
    );
  }
}
