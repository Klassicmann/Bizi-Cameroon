import 'dart:io';

import 'package:bizi/models/user.dart';
import 'package:bizi/screens/edit_profile.dart';
import 'package:bizi/screens/full_image.dart';
import 'package:bizi/screens/message.dart';
import 'package:bizi/widgets/p_pageview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;

class Profile extends StatefulWidget {
  final Cuser user;

  Profile({
    this.user,
  });
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  // Animation<double> _animation;
  // AnimationController _animationController;
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  String profileImage;
  bool isMe = false;
  User fUser = FirebaseAuth.instance.currentUser;
  // bool _favourite = false;

  bool _loading = false;

  final _picker = ImagePicker();

  Future _pickImage(ImageSource source) async {
    await _picker.getImage(source: source, imageQuality: 25).then((value) {
      setState(() {
        _loading = true;
      });
      Reference _reference = FirebaseStorage.instance
          .ref()
          .child('profiles/${Path.basename(widget.user.snapshot.id)}');

      _reference.putFile(File(value.path)).whenComplete(() {
        _reference.getDownloadURL().then((url) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user.snapshot.id)
              .update({'coverImage': url});
        }).whenComplete(() {
          Tooltip(message: 'Cover image uploaded successfully');
        });
        setState(() {
          _loading = false;
        });
      }).catchError((error) {
        print(error);
      });
    });
  }

  String url = '+237654118518';

  _showFullProfileImage(context, String image) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (contex) {
                return FullImage(
                  image: image,
                  id: 1,
                );
              }));
            },
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                constraints: BoxConstraints(maxHeight: 300),
                child: Image(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final Cuser user = widget.user;
    // final data = widget.snap.data();

    if (user.email == fUser.email) {
      setState(() {
        isMe = true;
      });
    }

    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: _loading,
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.user.snapshot.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.data.data();

            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  // pinned: true,
                  floating: false,
                  expandedHeight: MediaQuery.of(context).size.height / 4,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(left: 50, bottom: 10),
                    background: Image(
                      image: data['coverImage'] == null
                          ? AssetImage(
                              'assets/static/8f35ba26fe296e36b3a96ee5416259b4.jpg',
                            )
                          : NetworkImage(
                              data['coverImage'],
                            ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  actions: [
                    isMe
                        ? Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.white30,
                                borderRadius: BorderRadius.circular(30)),
                            child: IconButton(
                                icon: Icon(Icons.edit),
                                tooltip: 'change cover photo',
                                color: Colors.black87,
                                splashColor: Colors.red,
                                onPressed: () {
                                  _pickImage(ImageSource.gallery);
                                }),
                          )
                        : Container(),
                  ],
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    padding: EdgeInsets.only(top: 10, left: 20),
                    // margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await _showFullProfileImage(
                                context, data['photoUrl']);
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(data['photoUrl']),
                            radius: 40,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(user.username,
                                    style: GoogleFonts.k2d(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                SizedBox(
                                  width: 40,
                                ),
                                if (isMe)
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditProfile(
                                                      user: user,
                                                      id: widget.user.id,
                                                    )));
                                      })
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  data['bio'] == null
                                      ? 'Add description to let people know more about your business'
                                      : data['bio'],
                                  overflow: TextOverflow.clip,
                                  style: GoogleFonts.k2d(fontSize: 16),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Link(
                              icon: Icons.location_city,
                              title: data['address'] == null
                                  ? 'Update your address'
                                  : data['address'],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Link(
                              icon: Icons.badge,
                              title: data['job'] == null
                                  ? 'Add your business type'
                                  : data['job'],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Link(
                              icon: Icons.phone,
                              title: data['phone'] == null
                                  ? 'Update your phone number'
                                  : data['phone'],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: isMe
                                  ? Container()
                                  : Row(
                                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.2,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 4),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.phone_outlined,
                                                  color: Colors.white),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Call',
                                                style: GoogleFonts.k2d(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.lightBlue,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SendMessage(
                                                          cuser: widget.user,
                                                        )));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Icon(Icons.message,
                                                      color: Colors.white),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Message',
                                                    style: GoogleFonts.k2d(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.lightBlue,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  PageViewBuilder(
                    id: widget.user.snapshot.id,
                    email: widget.user.email,
                  ),
                ])),
              ],
            );
          }),
    ));
  }
}

class Link extends StatelessWidget {
  final IconData icon;
  final String title;
  Link({this.icon, this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
        ),
        SizedBox(
          width: 10,
        ),
        Text(title,
            style: GoogleFonts.k2d(fontSize: 18, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class Links extends StatelessWidget {
  final String title;
  final IconData icon;

  Links({this.title, this.icon});
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: Colors.black38, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: Colors.orange,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: GoogleFonts.k2d(
                fontWeight: FontWeight.w600, fontSize: 19, color: Colors.white),
          )
        ],
      ),
    );
  }
}

class Contact extends StatelessWidget {
  final Function tap;
  final IconData icon;
  Contact({this.icon, this.tap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(icon),
      width: MediaQuery.of(context).size.width / 2.5,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    );
  }
}
