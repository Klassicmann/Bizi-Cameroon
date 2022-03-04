import 'dart:io';
import 'package:bizi/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bizi/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;

class SellForm extends StatefulWidget {
  final QueryDocumentSnapshot snap;
  SellForm({
    this.snap,
  });
  @override
  _SellFormState createState() => _SellFormState();
}

class _SellFormState extends State<SellForm> {
  final _formKey = GlobalKey<FormState>();

  File imageFile;

  final picker = ImagePicker();

  List<File> otherFiles = [];

  Future<void> _pickImage(ImageSource source, int id) async {
    PickedFile selected = await picker.getImage(source: source);
    if (id == 1) {
      setState(() {
        imageFile = File(selected.path);
      });
    } else {
      setState(() {
        otherFiles.add(File(selected.path));
      });
    }
  }

  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        androidUiSettings: AndroidUiSettings(
            toolbarColor: Colors.purple,
            toolbarWidgetColor: Colors.white,
            toolbarTitle: 'Crop'));

    setState(() {
      imageFile = cropped;
    });
  }

  _clear() {
    setState(() {
      imageFile = null;
    });
  }

  String _type;
  String _title;
  String _town;
  String _desc;

  int _price;
  String imgUrl;
  List<String> otherImagesUrl = [];

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    // Article article = Article();

    List<Widget> otherImages = [];

    if (otherFiles != []) {
      for (File i in otherFiles) {
        otherImages.add(Stack(children: [
          Container(
              width: 100,
              margin: EdgeInsets.all(5),
              child: Container(
                // fit: BoxFit.cover,
                child: Image.file(i),
              )),
          Positioned(
            right: 5,
            bottom: 5,
            child: GestureDetector(
                onTap: () {
                  setState(() {
                    otherFiles.remove(i);
                  });
                },
                child: Icon(
                  Icons.cancel,
                  color: Colors.white,
                )),
          )
        ]));
      }
    }

    String token;
    FirebaseMessaging.instance.getToken().then((value) {
      token = value;
    });
    print(token);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Container(
          padding: EdgeInsets.only(top: 10, left: 15, right: 15),
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'What are you selling,',
                          style: GoogleFonts.k2d(
                              color: Colors.blueGrey[700],
                              fontWeight: FontWeight.w600,
                              fontSize: 19),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '${widget.snap.data()['username']} ?',
                          style: GoogleFonts.k2d(
                            color: Colors.lightBlue,
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    style: kSellFormInputStyle,
                    onChanged: (value) {
                      setState(() {
                        _title = value;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: klabelStyle,
                        icon: Icon(Icons.text_fields)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    style: kSellFormInputStyle,
                    onChanged: (value) {
                      setState(() {
                        _price = int.parse(value);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Price',
                      labelStyle: klabelStyle,
                      icon: Icon(Icons.attach_money),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    style: kSellFormInputStyle,
                    onChanged: (value) {
                      setState(() {
                        _town = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Town',
                      labelStyle: klabelStyle,
                      icon: Icon(Icons.location_city),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<String>(
                    style: kSellFormInputStyle,
                    value: _type,
                    items: [
                      'Mobile',
                      'Computer'
                          'Watch',
                      'Cars',
                      'Headphones'
                          'Gaming',
                      'Dresses',
                      'Shoes',
                      'Network'
                          'Lands',
                      'Houses',
                      'Other electronic device',
                    ].map<DropdownMenuItem<String>>(
                      (String val) {
                        return DropdownMenuItem(
                          child: Text(val),
                          value: val,
                        );
                      },
                    ).toList(),
                    onChanged: (val) {
                      setState(() {
                        _type = val;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Type',
                        labelStyle: klabelStyle,
                        icon: Icon(Icons.developer_board),
                        border: InputBorder.none),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 5,
                    style: kSellFormInputStyle.copyWith(fontSize: 16),
                    decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                            borderSide: BorderSide(color: Colors.black12))),
                    onChanged: (val) {
                      setState(() {
                        _desc = val;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 10),
                        child: Text(
                          'Upload item image',
                          style: klabelStyle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (imageFile != null) ...[
                    Image.file(imageFile),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                            onPressed: () => _cropImage(),
                            child: Icon(Icons.crop)),
                        MaterialButton(
                            onPressed: () => _clear, child: Icon(Icons.refresh))
                      ],
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        color: Colors.grey[300],
                        onPressed: () => _pickImage(ImageSource.camera, 1),
                        child: Row(
                          children: [
                            Icon(Icons.camera, color: Colors.black54),
                            SizedBox(width: 10),
                            Text(
                              'Camera',
                              style:
                                  GoogleFonts.k2d(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      MaterialButton(
                        color: Colors.grey[300],
                        onPressed: () => _pickImage(ImageSource.gallery, 1),
                        child: Row(
                          children: [
                            Icon(Icons.photo_library, color: Colors.black54),
                            SizedBox(width: 10),
                            Text(
                              'Galery',
                              style:
                                  GoogleFonts.k2d(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.add_to_photos,
                        color: Colors.black54,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: Text(
                            'Add atleast two other images of your item ',
                            overflow: TextOverflow.clip,
                            style: klabelStyle,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  otherImages != []
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              color: Colors.grey[300],
                              onPressed: () =>
                                  _pickImage(ImageSource.camera, 2),
                              child: Row(
                                children: [
                                  Icon(Icons.camera, color: Colors.black54),
                                  SizedBox(width: 10),
                                  Text(
                                    'Camera',
                                    style: GoogleFonts.k2d(
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                            MaterialButton(
                              color: Colors.grey[300],
                              onPressed: () =>
                                  _pickImage(ImageSource.gallery, 2),
                              child: Row(
                                children: [
                                  Icon(Icons.photo_library,
                                      color: Colors.black54),
                                  SizedBox(width: 10),
                                  Text(
                                    'Galery',
                                    style: GoogleFonts.k2d(
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                  if (otherImages != null) ...[
                    Container(
                      width: double.infinity,
                      height: 120,
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListView(
                          padding: EdgeInsets.all(10),
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: () => _pickImage(ImageSource.gallery, 2),
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(50)),
                                child: Center(
                                  child: Icon(Icons.add_a_photo),
                                ),
                              ),
                            ),
                            ...otherImages.reversed
                          ]),
                    ),
                  ],
                  MaterialButton(
                    color: Colors.lightBlue,
                    child: Text(
                      'Submit',
                      style: GoogleFonts.k2d(color: Colors.white),
                    ),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });

                      Reference _reference = FirebaseStorage.instance
                          .ref()
                          .child('articles/${Path.basename(imageFile.path)}');

                      UploadTask uploadTask = _reference.putFile(imageFile);

                      await uploadTask.whenComplete(() {
                        _reference.getDownloadURL().then((fileUrl) {
                          setState(() {
                            imgUrl = fileUrl;
                          });
                        });
                      }).catchError((e) => print(e));

                      for (File i in otherFiles) {
                        Reference img = FirebaseStorage.instance
                            .ref()
                            .child('otherImages/${Path.basename(i.path)})');
                        UploadTask task = img.putFile(i);

                        await task.whenComplete(() {
                          img.getDownloadURL().then((url) {
                            setState(() {
                              otherImagesUrl.add(url);
                            });
                          });
                        }).catchError((error) {
                          print(error);
                        });
                      }

                      DocumentReference docId = widget.snap.reference;
                      print(docId);
                      await FirebaseFirestore.instance
                          .collection('articles')
                          .add({
                        'type': _type,
                        'title': _title,
                        'searchKey': _title.toLowerCase(),
                        'town': _town,
                        'description': _desc,
                        'price': _price,
                        'image': imgUrl,
                        'otherImages': otherImagesUrl,
                        'userId': FirebaseAuth.instance.currentUser.email,
                        'user': docId
                      }).then((value) {
                        setState(() {
                          loading = false;
                        });

                        showBarModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                            'Your item was uploaded successfully'),
                                      )
                                    ],
                                  ),
                                ));
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return HomeScreen(
                              // message: 'Your item was added successfully',
                              // snapshot: widget.snap,
                              );
                        }));
                      });
                    },
                  )
                ],
              )),
        ),
      ),
    );
  }
}
