import 'package:bizi/screens/item_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Products extends StatelessWidget {
  final String id;
  Products({this.id});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('articles').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final data = snapshot.data.docs;
          final thisUser = FirebaseAuth.instance.currentUser.email;

          List items = [];
          data.forEach((e) {
            if (e.data()['userId'] == thisUser)
            items.add(PItems(
                title: e.data()['title'],
                price: e.data()['price'],
                image: e.data()['image'],
                snap: e));
          });

          return GridView.builder(
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              return items[index];
            },
          );
        });
  }
}

class PItems extends StatelessWidget {
  final String title;
  final int price;
  final String image;
  final DocumentSnapshot snap;
  const PItems({this.image, this.price, this.title, this.snap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (contex) => ItemDetail(title: title, id:snap.id , fromProfile: true,))),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                left: BorderSide(width: 3, color: Colors.black26),
                bottom: BorderSide(width: 2, color: Colors.black26))),
        height: 150,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: Image(
                height: 100,
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.k2d(fontSize: 19, color: Colors.black,
                fontWeight: FontWeight.w600
              ),
            ),
            Text(
              '$price XAF',
              style: GoogleFonts.k2d(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.w600
              ),
            )
          ],
        ),
      ),
    );
  }
}
