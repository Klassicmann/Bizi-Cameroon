import 'dart:math';
import 'package:bizi/screens/item_detail.dart';
import 'package:bizi/widgets/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Searches extends StatefulWidget {
  @override
  _SearchesState createState() => _SearchesState();
}

class _SearchesState extends State<Searches> {
  AnimationController controller;
  final _searchController = TextEditingController();
  String query;
  Stream<QuerySnapshot> streamQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).accentColor.withOpacity(0.4),
      child: Column(
        children: [
          Search(
            controller: _searchController,
            hint: 'Search everything here',
            
            pressed: () async {
              setState(() {
                query = _searchController.text.trim();
              });
            },
            onChange: (value) {
              setState(() {
                query = value;
                streamQuery = FirebaseFirestore.instance
                    .collection('articles')
                    .where('searchKey', isGreaterThanOrEqualTo: query)
                    .where('searchKey', isLessThan: query + 'z')
                    .snapshots();
              });
            },
          ),
          query == null
              ? Center(
                  child: Text('Search results will appear here',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.k2d(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 40)))
              : Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                      stream: streamQuery,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: Text('Search results will appear here',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.k2d(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 40)));
                        }

                        final data = snapshot.data.docs;

                        List<Itm> results = [];
                        data.forEach((element) {
                          results.add(Itm(
                            id: element.id,
                            title: element.data()['title'],
                            image: element.data()['image']
                          ));
                        });

                        List list = results
                            .map((e) => Container(
                              
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 3),
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)

                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ItemDetail(
                                        title: e.title,
                                        id: e.id,
                                      );
                                    }));
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(e.image),
                                    ),
                                    title: Text(e.title.toLowerCase(),
                                        style: GoogleFonts.k2d(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ),
                                )),)
                            .toList();

                        return ListView(
                          // itemExtent: 42,
                          children: list,
                        );
                      })),
        ],
      ),
    );
  }
}

class Itm {
  final String id;
  final String title;
  final String image;
  Itm({this.id, this.title, this.image});
}
