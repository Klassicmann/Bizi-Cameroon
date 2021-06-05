import 'package:bizi/screens/category_items.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Categories extends StatelessWidget {
  final String image;
  final String type;
  final String title;
  final String index;
  final int articlesNum;
  final int sellersNum;
  final Function tap;
  Categories(
      {this.image,
      this.type,
      this.title,
      this.articlesNum,
      this.sellersNum,
      this.tap,
      this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          width: 200,
          height: 200, 
          margin: EdgeInsets.all(3),
          padding: EdgeInsets.all(0.5),
          decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(301),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 1,
                    color: Colors.black,
                    offset: Offset(0, 1),
                    blurRadius: 1)
              ]),
          child: Container(
            height: 100,
            child: Stack(
              children: [
                Image(
                  image: AssetImage('assets/static/' + image),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          type,
                          style: GoogleFonts.k2d(
                              fontSize: 18,
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.k2d(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13),
                        child: Text(
                          '$articlesNum+ articles',
                          style: GoogleFonts.k2d(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 13),
                        child: Text(
                          '$sellersNum+ vendeurs',
                          style: GoogleFonts.k2d(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
