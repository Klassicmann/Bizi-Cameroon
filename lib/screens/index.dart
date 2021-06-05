import 'package:bizi/screens/category_items.dart';
import 'package:bizi/widgets/categories.dart';
import 'package:bizi/widgets/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Index extends StatefulWidget {
  const Index({
    Key key,
  }) : super(key: key);

  @override
  _IndexState createState() => _IndexState();
}

bool search = false;

class _IndexState extends State<Index> {
  @override
  void initState() { 

    super.initState();
    
  }
  push(BuildContext context, String title) {
    return Navigator.push(context, MaterialPageRoute(builder: (context) {
      return CategoryItems(
        index: title,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('articles').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final snap = snapshot.data.docs;
          List<Categories> categories = [];

          snap.forEach((doc) {
            String catName = doc.data()['type'];

            categories.add(Categories(
              index: catName,
            ));
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              search
                  ? Search(
                      hint: 'Search item or category here',
                    )
                  : Container(),
              Expanded(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      
                      children: [
                        Categories(
                          type: 'Mobile',
                          title: 'Andorid and Iphone',
                          articlesNum: 32,
                          sellersNum: 303,
                          image: 'Best-android-smartphones-in-nigeria.jpeg',
                          tap: () {
                            push(context, 'Mobile');
                          },
                        ),
                        Categories(
                          type: 'Computer',
                          title: 'Desktop and Laptop',
                          articlesNum: 230,
                          sellersNum: 3002,
                          image: 'PES6US4DGQsJVRQmnqkzCZ.jpg',
                          tap: () {
                            push(context, 'Computer');
                          },
                        ),
                        Categories(
                          type: 'Shoes',
                          title: 'Male and Female',
                          articlesNum: 571,
                          sellersNum: 4713,
                          image:
                              'adapt-bb-2-tie-dye-basketball-shoe-vdFwKS.jpg',
                          tap: () {
                            push(context, 'Shoes');
                          },
                        ),
                        Categories(
                          type: 'Cars',
                          title: 'Cars, Motocycles',
                          articlesNum: 907,
                          sellersNum: 637,
                          image: '8f35ba26fe296e36b3a96ee5416259b4.jpg',
                          tap: () {
                            push(context, 'Cars');
                          },
                        ),
                        
                        Categories(
                          type: 'Headphones',
                          title: 'Headphones',
                          articlesNum: 3278,
                          sellersNum: 253,
                          image: '20200923171822_5f6b12dea04c5.jpg_500x500.jpg',
                          tap: () {
                            push(context, 'Headphones');
                          },
                        ),
                        Categories(
                          type: 'Gaming',
                          title: 'Gaming tools',
                          articlesNum: 907,
                          sellersNum: 637,
                          image: '101e9a654e5ff0a22b5fd6f24c3d1e34.jpg',
                          tap: () {
                            push(context, 'Gaming');
                          },
                        ),
                        Categories(
                          type: 'Network',
                          title: 'Network Devices',
                          articlesNum: 3278,
                          sellersNum: 253,
                          image: 'thinkstock-router-100569363-large.jpg',
                          tap: () {
                            push(context, 'Network');
                          },
                        ),
                        Categories(
                          type: 'Meches',
                          title: 'Brazilien, Indian...',
                          articlesNum: 674,
                          sellersNum: 212,
                          image: 'IMG-20200624-WA0021sa.jpg',
                          tap: () {
                            push(context, 'Hair');
                          },
                        ),
                        Categories(
                          type: 'Watches',
                          title: 'Buy a Good Watch',
                          articlesNum: 674,
                          sellersNum: 212,
                          image: '61WixzlVuXL._UL1280_.jpg',
                          tap: () {
                            push(context, 'Hair');
                          },
                        ),
                        Categories(
                          type: 'Cloths',
                          title: 'Male and Female',
                          articlesNum: 876,
                          sellersNum: 390,
                          image: '5c94befb230000c800e9f38b.jpeg',
                          tap: () {
                            push(context, 'Dresses');
                          },
                        ),
                        Categories(
                          type: 'Houses',
                          title: 'All Types of Houses',
                          articlesNum: 8076,
                          sellersNum: 760,
                          image: 'types-of-homes-hero.jpg',
                          tap: () {
                            push(context, 'Houses');
                          },
                        ),
                        Categories(
                          type: 'Lands',
                          title: 'Big and Small Lands',
                          articlesNum: 876,
                          sellersNum: 390,
                          image: '16x9_M.jpg',
                          tap: () {
                            push(context, 'Lands');
                          },
                        ),
                      ],
                    )),
              )
            ],
          );
        });
  }
}
