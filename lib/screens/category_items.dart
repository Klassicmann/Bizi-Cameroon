import 'package:bizi/models/article.dart';
import 'package:bizi/screens/item_detail.dart';
import 'package:bizi/widgets/one_item.dart';
import 'package:bizi/widgets/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryItems extends StatefulWidget {
  final String index;
  CategoryItems({this.index});
  @override
  _CategoryItemsState createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems> {
  int cartNum = 0;
  final _searchController = TextEditingController();
  String query;
  Stream<QuerySnapshot> streamQuery =
      FirebaseFirestore.instance.collection('articles').snapshots();

  // List<Article> articles = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.index),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.favorite_border_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            )
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          children: [
            // Image(
            //   image: AssetImage('assets/static/avekenedy.jpg'),
            //   fit: BoxFit.cover,
            //   height: double.infinity,
            //   ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, usrsnap) {
                  if (!usrsnap.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.deepOrange,
                      ),
                    );
                  }

                  final usrdata = usrsnap.data.docs;
                  String thisusrId;
                  usrdata.forEach((element) {
                    if (element.data()['email'] ==
                        FirebaseAuth.instance.currentUser.email)
                      thisusrId = element.id;
                  });
                  return StreamBuilder<QuerySnapshot>(
                    stream: streamQuery,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot.data.docs;
                      List<Article> articles = [];

                      data.forEach((e) async {
                        if (e.data()['type'] == widget.index) {
                          Article article = Article(
                              articleId: e.id,
                              image: e.data()['image'],
                              images: e.data()['otherImages'],
                              price: e.data()['price'],
                              title: e.data()['title'],
                              town: e.data()['town'],
                              type: e.data()['type'],
                              desc: e.data()['description'],
                              reference: e.reference,
                              postedBy: e.data()['user']);

                          articles.add(article);
                        }
                      });

                      List<Widget> items = articles.map((e) {
                        return Items(
                          id: e.articleId,
                          image: e.image,
                          title: e.title,
                          desc: e.desc,
                          price: e.price,
                          location: e.town,
                          user: e.postedBy,
                          reference: e.reference,
                          loggedUserId: thisusrId,
                        );
                      }).toList();
                      return Column(
                        children: [
                          Search(
                            controller: _searchController,
                            hint: 'Quick search here',
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
                                    .where('searchKey',
                                        isGreaterThanOrEqualTo: query)
                                    .where('searchKey', isLessThan: query + 'z')
                                    .snapshots();
                              });
                            },
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 6,
                                        mainAxisSpacing: 7,
                                        childAspectRatio: (0.4 / 0.66)),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return items[index];
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ],
        ));
  }
}
