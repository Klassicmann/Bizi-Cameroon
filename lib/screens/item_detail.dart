import 'dart:ui';

import 'package:bizi/login/change_password.dart';
import 'package:bizi/models/user.dart';
// import 'package:bizi/screens/index. dart';
import 'package:bizi/screens/message.dart';
import 'package:bizi/widgets/dialogs.dart';
import 'package:bizi/widgets/edit_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ItemDetail extends StatefulWidget {
  final bool fromProfile;
  final String id;
  final String title;
  final DocumentReference reference;
  final String usrId;
  ItemDetail(
      {this.id,
      this.title,
      this.fromProfile = false,
      this.reference,
      this.usrId});
  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  dynamic img;
  double opacity = 1;
  bool tap;
  bool liked = false;
  bool loading = false;
  final TransformationController _controller = TransformationController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toUpperCase(),
            style: GoogleFonts.k2d(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          GestureDetector(
            onTap: () async {
              setState(() {
                loading = true;
              });
              CollectionReference favouritesReference = FirebaseFirestore
                  .instance
                  .collection('users')
                  .doc(widget.usrId)
                  .collection('favorites');
              List<DocumentReference> itemRenferences = [];

              await favouritesReference.get().then((value) {
                value.docs.forEach((element) {
                  itemRenferences.add(element.data()['item']);
                });
              }).catchError((e) {
                messageDialog('Error',
                    'An error occured when getting favourites', context);
              });

              if (!itemRenferences.contains(widget.reference)) {
                favouritesReference.add({
                  'item': widget.reference,
                  'time': DateTime.now()
                }).whenComplete(() {
                  snackbar(context, '${widget.title} added to favourites');
                  setState(() {
                    loading = false;
                    liked = true;
                  });
                }).catchError((e) {
                  messageDialog(
                      'Error',
                      'An error occured when adding item to favourites. Please try again later',
                      context);
                });
              } else {
                setState(() {
                  loading = false;
                });
                messageDialog(
                    'Error',
                    '${widget.title} already exist in your favourites list.',
                    context);
              }
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                !liked ? Icons.favorite_border_outlined : Icons.favorite,
                color: !liked ? Colors.white : Colors.redAccent,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('articles')
              .doc(widget.reference.id)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final data = snapshot.data.data();

            DocumentReference _userReference = data['user'];
            String userEmail;
            String loggedInUser = FirebaseAuth.instance.currentUser.email;
            Cuser _user;

            _userReference.get().then((value) {
              userEmail = value.data()['email'];
              _user = Cuser(
                  username: value.data()['username'],
                  profileImage: value.data()['photoUrl'],
                  email: value.data()['email']);
            });

            dynamic image = data['image'];
            List<dynamic> images = data['otherImages'];

            List<dynamic> otherImages = [image, ...images];

            bool isMe = loggedInUser == userEmail;

            return Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: [
                  if (!widget.fromProfile)
                    PostedBy(
                      user: _userReference,
                    ),
                  Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text(
                          data['title'],
                          style: GoogleFonts.k2d(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // isMe
                      //     ? IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                      //     : Container()
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      data['description'] != null ? data['description'] : '',
                      style: GoogleFonts.k2d(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: RichText(
                        text: TextSpan(
                            text: 'Price: ',
                            style: GoogleFonts.k2d(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87),
                            children: [
                          TextSpan(
                            text: data['price'].toString(),
                            style: GoogleFonts.k2d(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          ),
                          TextSpan(
                            text: ' FCFA',
                            style: GoogleFonts.k2d(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          ),
                        ])),
                  ),
                  Container(
                    height: 100,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: otherImages.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                img = otherImages[index];
                                _controller.value = Matrix4.identity();
                                // _selected[index] = true;
                              });
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              child: Image(
                                image: NetworkImage(otherImages[index]),
                                height: 90,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                  ),
                  InteractiveViewer(
                    transformationController: _controller,
                    onInteractionEnd: (detail) {
                      _controller.value = Matrix4.identity();
                    },
                    maxScale: 10,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      height: 400,
                      child: Image(
                        image: NetworkImage(img == null ? image : img),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  !widget.fromProfile
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: MaterialButton(
                            onPressed: () async {
                              if (userEmail != loggedInUser) {
                                await FirebaseFirestore.instance
                                    .collection('messages')
                                    .add({
                                  'document': '',
                                  'image': image,
                                  'images': [],
                                  'message': 'I like this article ',
                                  'sender':
                                      FirebaseAuth.instance.currentUser.email,
                                  'receiver': userEmail,
                                  'time': Timestamp.now(),
                                  'status': false,
                                  'seen': false
                                }).then((value) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SendMessage(
                                                cuser: _user,
                                              )));
                                }).catchError((e) {});
                              } else {
                                messageDialog(
                                    'Error',
                                    'You can\'t send message to yourself!',
                                    context);
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.message,
                                  color: Colors.lightBlueAccent,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  'I like this article',
                                  style: GoogleFonts.k2d(color: Colors.white),
                                ),
                              ],
                            ),
                            color: Colors.black87,
                          ),
                        )
                      : Container(),
                  !widget.fromProfile
                      ? Container()
                      : EditItem(id: widget.reference.id)
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PostedBy extends StatelessWidget {
  PostedBy({
    this.user,
  });
  final DocumentReference user;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: user.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator(
              backgroundColor: Colors.black,
            );
          }
          Cuser _user = Cuser(
              username: snapshot.data['username'],
              profileImage: snapshot.data['photoUrl'],
              email: snapshot.data['email']);
          return Container(
            child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(snapshot.data['photoUrl']),
                ),
                title: Text(snapshot.data['username']),
                subtitle: Text(snapshot.data['email']),
                trailing: IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SendMessage(
                                    cuser: _user,
                                  )));
                    })),
          );
        });
  }
}
