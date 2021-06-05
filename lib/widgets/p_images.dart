import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;

class PImages extends StatefulWidget {
  final String id;
  PImages({
    this.id,
  });

  @override
  _PImagesState createState() => _PImagesState();
}

class _PImagesState extends State<PImages> {
  File imageUrl;
  ImagePicker _picker = ImagePicker();
  bool loading = false;
  String caption;

  Future<void> _uploadImage(ImageSource source) async {
    PickedFile selected =
        await _picker.getImage(source: source, imageQuality: 25);

    if (source != null) {
      setState(() {
        imageUrl = File(selected.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool j = false;
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.id)
              // .collection('images')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            }

            final data = snapshot.data.data();
            final thisUser = FirebaseAuth.instance.currentUser.email;

            return Container(
              child: j
                  ? Text('No images yet')
                  : GridView(
                      addRepaintBoundaries: true,
                      semanticChildCount: 3,
                      padding: EdgeInsets.all(3),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      children: [
                          if (data['email'] == thisUser)
                            Container(
                              child: MaterialButton(
                                color: Colors.orange,
                                onPressed: () async {
                                  await _uploadImage(ImageSource.gallery)
                                      .catchError((onError) => print(onError));

                                  if (imageUrl != null) {
                                    await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Add caption'),
                                            content: Container(
                                              height: 100,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'Add caption that talks about your photo ',
                                                    style: GoogleFonts.k2d(
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextField(
                                                      decoration:
                                                          InputDecoration(),
                                                      onChanged: (val) {
                                                        setState(() {
                                                          caption = val;
                                                        });
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              MaterialButton(
                                                onPressed: () async {
                                                  if (caption != null) {
                                                    setState(() {
                                                      loading = true;
                                                    });
                                                    Reference _reference =
                                                        FirebaseStorage.instance
                                                            .ref()
                                                            .child(
                                                                'userImages/${Path.basename(imageUrl.path)}');

                                                    await _reference
                                                        .putFile(imageUrl)
                                                        .whenComplete(() {
                                                      _reference
                                                          .getDownloadURL()
                                                          .then((url) {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(widget.id)
                                                            .collection(
                                                                'images')
                                                            .add({
                                                              'caption': caption,
                                                          'image': url,
                                                          'time': Timestamp.now()
                                                        });
                                                      });
                                                    }).catchError((error) {
                                                      print(error);
                                                    });
                                                  }
                                                },
                                                child: Text('Upload'),
                                              ),
                                              MaterialButton(
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                },
                                                child: Text('Cancel'),
                                              ),
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Icon(Icons.add_a_photo),
                              ),
                            ),
                          Img(),
                          Img(),
                          Img(),
                          Img(),
                          Img(),
                          Img(),
                          Img(),
                          Img()
                        ]),
            );
          }),
    );
  }
}

class Img extends StatelessWidget {
  const Img({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      // height: 100,
      // width: 100,
      child: Image(
        image: AssetImage(
          'assets/static/avekenedy.jpg',
        ),
        // height: 8,
        // width: 80,
        fit: BoxFit.cover,
      ),
    );
  }
}
