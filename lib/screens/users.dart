import 'package:bizi/models/user.dart';
import 'package:bizi/screens/profile.dart';
import 'package:bizi/widgets/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Accounts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Find a shop',
            style: GoogleFonts.k2d(fontSize: 20),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final data = snapshot.data.docs;
            QueryDocumentSnapshot snap;
            List<Cuser> cusers = [];
            data.forEach((doc) {
              
              snap = doc;
              String name = doc.data()['username'];
              String email = doc.data()['email'];
              String phone = doc.data()['phone'];
              String thumbnail = doc.data()['photoUrl'];
              String desc = doc.data()['bio'];
              String town = doc.data()['town'];
              Cuser cuser = Cuser(
                  email: email,
                  username: name,
                  phone: phone,
                  profileImage: thumbnail,
                  bio: desc,
                  town: town);
              cusers.add(cuser);
            });
            cusers.removeWhere((element) =>
                FirebaseAuth.instance.currentUser.email == element.email);
            return Column(children: [
              Search(
                hint: 'Search for an account',
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cusers.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(
                                      user: cusers[index],
                                      snap: snap,
                                    )));
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          height: 120,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 2,
                                    spreadRadius: 6,
                                    color: Colors.white60,
                                    offset: Offset(0, 2))
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image(
                                      image: NetworkImage(cusers[index].profileImage),
                                      // height: MediaQuery.of(context).size.width / 3.5,
                                      width: MediaQuery.of(context).size.width /
                                          4.2,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cusers[index].username,
                                          style: GoogleFonts.k2d(
                                              fontSize: 20,
                                              color: Colors.green),
                                        ),
                                        Text(
                                          cusers[index].email,
                                          style: GoogleFonts.k2d(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          cusers[index].phone,
                                          style: GoogleFonts.k2d(
                                              fontSize: 17,
                                              color: Colors.orange),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(15)),
                                child: Icon(
                                  Icons.thumb_up,
                                  color: Colors.white,
                                  size: 19,
                                ),
                              )
                            ],
                          )),
                    );
                  },
                ),
              ),
            ]);
          },
        ));
  }
}
