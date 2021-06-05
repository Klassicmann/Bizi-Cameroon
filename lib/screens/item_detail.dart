import 'dart:ui';

import 'package:bizi/models/user.dart';
// import 'package:bizi/screens/index.dart';
import 'package:bizi/screens/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemDetail extends StatefulWidget {
  final bool fromProfile;
  final String id;
  final String title;
  ItemDetail({this.id, this.title, this.fromProfile = false});
  @override
  _ItemDetailState createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  dynamic img;
  double opacity = 1;
  bool tap;
  List<bool> _selected = List.generate(10, (index) => false);
  final TransformationController _controller = TransformationController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toUpperCase(),
            style: GoogleFonts.k2d(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('articles')
            .doc(widget.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final data = snapshot.data.data();

          DocumentReference _userReference = data['user'];

          dynamic image = data['image'];
          List<dynamic> images = data['otherImages'];

          List<dynamic> otherImages = [image, ...images];

          return Container(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
               if(!widget.fromProfile) 
               PostedBy(
                  user: _userReference,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text(
                    data['title'],
                    style: GoogleFonts.k2d(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
                )
              ],
            ),
          );
        },
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
            return CircularProgressIndicator();
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
                subtitle: Text('Leader market'),
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
