import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class EditItem extends StatelessWidget {
  final String id;
  const EditItem({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: MaterialButton(
        onPressed: () async {
          showBarModalBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                  height: 100,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text(
                        'Edit Item',
                        style: GoogleFonts.k2d(
                          fontSize: 21,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            color: Colors.blueAccent,
                            hoverColor: Colors.black,
                            onPressed: () {},
                            child: Text(
                              'Update',
                              style: GoogleFonts.k2d(
                                  color: Colors.white, fontSize: 19),
                            ),
                          ),
                          MaterialButton(
                            color: Colors.redAccent,
                            onPressed: () {
                              Navigator.pop(context);
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Delete Item'),
                                      content: Text(
                                          'Are you sure you want to delete this item?'),
                                      actions: [
                                        MaterialButton(
                                          color: Colors.blueAccent,
                                          hoverColor: Colors.black,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: GoogleFonts.k2d(
                                                color: Colors.white,
                                                fontSize: 19),
                                          ),
                                        ),
                                        MaterialButton(
                                          color: Colors.redAccent,
                                          onPressed: () async {
                                            FirebaseFirestore.instance
                                                .collection('articles')
                                                .doc(id)
                                                .get()
                                                .then((value) {
                                              print(value.data());
                                              final List<String> images =
                                                  value.data()['otherImages'];
                                              final image =
                                                  value.data()['image'];

                                              FirebaseStorage.instance
                                                  .refFromURL(image)
                                                  .delete()
                                                  .whenComplete(() {
                                                images.forEach((element) {
                                                  FirebaseStorage.instance
                                                      .refFromURL(element)
                                                      .delete();
                                                });
                                              });
                                            }).catchError((e) {
                                              print(e);
                                            }).then((value) {
                                              Navigator.pop(context);

                                              FirebaseFirestore.instance
                                                  .collection('articles')
                                                  .doc(id)
                                                  .delete()
                                                  .then((value) =>
                                                      Navigator.pop(context))
                                                  .catchError((e) {
                                                print(e);
                                              });
                                            });
                                          },
                                          child: Text(
                                            'Yes delete',
                                            style: GoogleFonts.k2d(
                                                color: Colors.white,
                                                fontSize: 19),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              'Delete',
                              style: GoogleFonts.k2d(
                                  color: Colors.white, fontSize: 19),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.edit,
              color: Colors.lightBlueAccent,
            ),
            SizedBox(
              width: 7,
            ),
            Text(
              'Edit this item',
              style: GoogleFonts.k2d(color: Colors.white),
            ),
          ],
        ),
        color: Colors.black87,
      ),
    );
  }
}
