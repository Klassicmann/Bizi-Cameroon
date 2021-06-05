import 'package:bizi/models/article.dart';
import 'package:bizi/screens/item_detail.dart';
import 'package:bizi/widgets/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  Stream<QuerySnapshot> streamQuery;

  // List<Article> articles = [];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.index),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            Icon(
              Icons.shopping_cart,
              color: Colors.orange,
              size: 30,
            )
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('articles').snapshots(),
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
                    // postedBy: e.data()['postedBy']
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
                          .where('searchKey', isGreaterThanOrEqualTo: query)
                          .where('searchKey', isLessThan: query + 'z')
                          .snapshots();
                      print(query);
                    });
                  },
                ),
                Expanded(
                  child: Container(
                    child: query != null
                        ? Container(
                            child: Center(
                              child: Text(query),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: (0.5 / 0.66)),
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
        ));
  }
}

class Items extends StatelessWidget {
  final String id;
  final String image;
  final String title;
  final String desc;
  final int price;
  final String location;
  final Function tap;
  Items(
      {this.id,
      this.title,
      this.desc,
      this.price,
      this.location,
      this.user,
      this.image,
      this.tap});

  final DocumentReference user;

  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: user.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemDetail(
                            id: id,
                            title: title,
                          )));
            },
            child: Container(
              padding: EdgeInsets.all(5),
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                vertical: 1,
              ),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      color: Colors.red,
                      width: double.infinity,
                      height: 120,
                      constraints: BoxConstraints(maxHeight: 150),
                      child: Image(
                        image: NetworkImage(image),
                        // height: 200,
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 7),
                    margin: EdgeInsets.only(right: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: GoogleFonts.k2d(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.orange,
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          margin: EdgeInsets.only(right: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              desc != null
                                  ? Text(desc,
                                      overflow: TextOverflow.clip,
                                      style: GoogleFonts.k2d(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ))
                                  : Container(),
                              SizedBox(
                                height: 5,
                              ),
                              Text('$price FCFA',
                                  overflow: TextOverflow.clip,
                                  style: GoogleFonts.k2d(
                                      fontSize: 13,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_city,
                                            size: 15,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(location,
                                              overflow: TextOverflow.clip,
                                              style: GoogleFonts.k2d(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(0.2),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
