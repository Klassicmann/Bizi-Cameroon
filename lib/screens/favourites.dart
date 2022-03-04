import 'package:bizi/screens/item_detail.dart';
import 'package:bizi/widgets/dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Favourites extends StatefulWidget {
  final String id;
  // const Favourites({ Key? key }) : super(key: key);
  Favourites({this.id});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          padding: EdgeInsets.only(top: 20),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.id)
                .collection('favorites')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.deepOrange,
                ));
              }
              final data = snapshot.data.docs;

              List<Widget> favourites = data.map((e) {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('articles')
                      .doc(e.data()['item'].id)
                      .get(),
                  // initialData: InitialData,
                  builder: (BuildContext context, AsyncSnapshot snap) {
                    if (!snap.hasData) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.deepOrange,
                        ),
                      );
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ItemDetail(
                            usrId: widget.id,
                            reference: e.data()['item'],
                            title: snap.data['title'],
                          );
                        }));
                      },
                      child: Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: ListTile(
                            title: Text(snap.data['title']),
                            leading: Container(
                                width: 80,
                                child: Image(
                                  image: NetworkImage(snap.data['image']),
                                  fit: BoxFit.cover,
                                )),
                            subtitle: Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Type: ',
                                      style: GoogleFonts.k2d(
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      snap.data['type'],
                                      style: GoogleFonts.k2d(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 7),
                                  width: 1,
                                  height: 10,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border(
                                        right: BorderSide(
                                            width: 1,
                                            style: BorderStyle.solid,
                                            color: Colors.black),
                                        left: BorderSide(
                                            width: 1,
                                            style: BorderStyle.solid,
                                            color: Colors.black),
                                      )),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Town: ',
                                      style: GoogleFonts.k2d(
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                      snap.data['town'],
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.k2d(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Remove From Fvourites'),
                                          content: Text(
                                              'Are you sure you want to remove this item from your favourites list?'),
                                          actions: [
                                            MaterialButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                setState(() {
                                                  _loading = true;
                                                });
                                                Navigator.pop(context);
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(widget.id)
                                                    .collection('favorites')
                                                    .doc(e.id)
                                                    .delete()
                                                    .whenComplete(() {
                                                  setState(() {
                                                    _loading = false;
                                                  });
                                                }).catchError((e) {
                                                  print(e);
                                                });
                                              },
                                              child: Text('Remove'),
                                              color: Colors.redAccent,
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: Icon(Icons.delete_outline_outlined)),
                          )),
                    );
                  },
                );
                // return fu
              }).toList();
              return Container(
                child: ListView.builder(
                    itemCount: favourites.length,
                    itemBuilder: (context, index) {
                      return favourites.length != 0
                          ? favourites[index]
                          : Container(
                              color: Colors.red,
                              child: Center(
                                child: Text('No items in favourites list yet'),
                              ));
                    }),
              );
            },
          ),
        ),
      ),
    );
  }
}
