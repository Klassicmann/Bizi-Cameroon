import 'dart:io';

import 'package:bizi/constants.dart';
import 'package:bizi/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path/path.dart' as Path;

class EditProfile extends StatefulWidget {
  final Cuser user;
  final String id;
  EditProfile({this.user, this.id});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  DateTime selectedDate = DateTime.now();
  Cuser data;
  File _imageFile;
  final _picker = ImagePicker();

  String _email;
  String _bio;
  String _town;
  String _phone;
  String _gender;
  String profileImage;
  String _username;
  String _job;

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025),
        initialEntryMode: DatePickerEntryMode.input);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _pickImage(ImageSource source) async {
    PickedFile selected = await _picker.getImage(
      source: source,
    );

    setState(() {
      _imageFile = File(selected.path);
    });
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    print(widget.user.profileImage);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit profile'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              // color: Colors.red
                              ),
                          child: Stack(
                            children: [ 
                              _imageFile != null
                                  ? Image.file(
                                      _imageFile,
                                      fit: BoxFit.cover,
                                    
                                    )
                                  : Image(
                                      image: NetworkImage(widget.user.profileImage),
                                      fit: BoxFit.cover,
                                  
                                    ),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.white,
                                    builder: (context) {
                                      return Container(
                                        height: 100,
                                        child: Column(
                                          children: [
                                            Text(
                                              'Choose from',
                                              style: GoogleFonts.k2d(
                                                  color: Colors.purpleAccent,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                MaterialButton(
                                                  onPressed: () {
                                                    _pickImage(
                                                            ImageSource.camera)
                                                        .whenComplete(() =>
                                                            Navigator.pop(
                                                                context));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.camera),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text('Camera')
                                                    ],
                                                  ),
                                                ),
                                                MaterialButton(
                                                  onPressed: () {
                                                    _pickImage(
                                                            ImageSource.gallery)
                                                        .whenComplete(() =>
                                                            Navigator.pop(
                                                                context));
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons
                                                          .photo_library_outlined),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text('Gallery')
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  width: 150,
                                  height: 100,
                                  margin: EdgeInsets.only(top: 90),
                                  child: Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                  decoration:
                                      BoxDecoration(color: Colors.black54),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextFormField(
                      style: kSellFormInputStyle,
                      onChanged: (val) {
                        setState(() {
                          _username = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: widget.user.username != null
                            ? widget.user.username
                            : '',
                        helperText: widget.user.username != null
                            ? widget.user.username
                            : '',
                        labelText: 'Username',
                        labelStyle: klabelStyle,
                        // icon: Icon(Icons.text_fields)
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: kSellFormInputStyle,
                      onChanged: (val) {
                        setState(() {
                          _email = val;
                        });
                      },
                      validator: (input) =>
                          input.isValidEmail() ? null : "Check your email",
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText:
                            widget.user.email != null ? widget.user.email : '',
                        helperText:
                            widget.user.email != null ? widget.user.email : '',

                        labelStyle: klabelStyle,
                        // icon: Icon(Icons.location_city),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      style: kSellFormInputStyle,
                      onChanged: (val) {
                        setState(() {
                          _phone = val;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        hintText:
                            widget.user.phone != null ? widget.user.phone : '',
                        helperText:
                            widget.user.phone != null ? widget.user.phone : '',

                        labelStyle: klabelStyle,
                        // icon: Icon(Icons.attach_money),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: kSellFormInputStyle,
                      onChanged: (val) {
                        setState(() {
                          _job = val;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Job',
                        hintText:
                            widget.user.job != null ? widget.user.job : '',
                        helperText:
                            widget.user.job != null ? widget.user.job : '',

                        labelStyle: klabelStyle,
                        // icon: Icon(Icons.location_city),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      style: kSellFormInputStyle,
                      onChanged: (val) {
                        setState(() {
                          _town = val;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Address',
                        hintText:
                            widget.user.town != null ? widget.user.town : '',
                        helperText:
                            widget.user.town != null ? widget.user.town : '',

                        labelStyle: klabelStyle,
                        // icon: Icon(Icons.location_city),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Text(
                            'Date of birth',
                            style: kSellFormInputStyle.copyWith(
                                color: Colors.black87),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Text(
                              selectedDate != null
                                  ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                                  : '20/ 20/ 2020',
                              style: kSellFormInputStyle,
                            ),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          MaterialButton(
                            onPressed: () => _selectDate(context),
                            child: Text('Change'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButtonFormField<String>(
                      style: kSellFormInputStyle,
                      // value: _type,
                      items: [
                        'Male',
                        'Female',
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
                          _gender = val;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: 'Gender',
                          labelStyle: klabelStyle,
                          // icon: Icon(Icons.developer_board),
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
                          labelText: 'Bio',
                          hintText:
                              widget.user.bio != null ? widget.user.bio : '',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: BorderSide(color: Colors.black12))),
                      onChanged: (val) {
                        setState(() {
                          _bio = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });

                        if (_imageFile != null) {
                          Reference _reference = FirebaseStorage.instance
                              .ref()
                              .child('profiles/${Path.basename(widget.id)}');

                          await _reference.putFile(_imageFile).whenComplete(() {
                            _reference.getDownloadURL().then((url) {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.id)
                                  .update({'photoUrl': url});
                            });
                          }).catchError((error) {
                            print(error);
                          });
                        }

                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.id)
                            .update({
                          'username': _username != null
                              ? _username
                              : widget.user.username,
                          'email': _email != null ? _email : widget.user.email,
                          'phone': _phone != null ? _phone : widget.user.phone,
                          'bio': _bio != null ? _bio : widget.user.bio,
                          'town': _town != null ? _town : widget.user.town,
                          'gender':
                              _gender != null ? _gender : widget.user.gender,
                          'dateOfBirth':
                              _gender != null ? _gender : widget.user.gender,
                          'job': _job != null ? _job : widget.user.job,
                        }).then((value) {
                          setState(() {
                            Navigator.pop(context);
                            setState(() {
                              loading = false;
                            });
                          });
                        }).catchError((e) {
                          print(e);
                        });
                      },
                      child: Text(
                        'Submit',
                        style:
                            kSellFormInputStyle.copyWith(color: Colors.white),
                      ),
                      color: Colors.lightBlue,
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
