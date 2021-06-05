import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Posts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(7),
            padding: EdgeInsets.all(10),
            // height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor.withOpacity(0.5) , borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white,
                              )),
                          child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                  'assets/static/Max-R_Headshot (1).jpg')),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Klassic mann',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 19, color: Colors.white),
                            ),
                            Text(
                              '2 hours ago',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 13, color: Colors.white70),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_city,
                                  size: 20,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  'Douala',
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 13, color: Colors.blue),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.more_horiz,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  child: Text(
                    '6LACK and Miller Genuine Draft have collaborated for an exceptional performance as part of Miller Music Amplified, a series of five performances. Check out Miller Genuine Draft\'s social channels to see what\'s still in store.',
                    style: GoogleFonts.k2d(color: Colors.white, fontSize: 20),
                  ),
                ),
                Image(
                  image: AssetImage('assets/static/AdobeStock_300917172.jpeg'),
                  height: MediaQuery.of(context).size.height / 3.5,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.thumb_up_alt_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '232',
                            style: GoogleFonts.k2d(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.comment,
                            size: 25,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '2k',
                            style: GoogleFonts.k2d(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.share,
                            size: 25,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '20',
                            style: GoogleFonts.k2d(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          // Text(
                          //   '232',
                          //   style: GoogleFonts.k2d(color: Colors.white),
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            padding: EdgeInsets.all(10),
            // height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black54, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white,
                              )),
                          child: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                  'assets/static/Max-R_Headshot (1).jpg')),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Klassic mann',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 19, color: Colors.white),
                            ),
                            Text(
                              '2 hours ago',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 13, color: Colors.white70),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_city,
                                  size: 20,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text(
                                  'Douala',
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 13, color: Colors.blue),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.more_horiz,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(top: 10, bottom: 3),
                  child: Text(
                    '6LACK and Miller Genuine Draft have collaborated for an exceptional performance as part of Miller Music Amplified, a series of five performances. Check out Miller Genuine Draft\'s social channels to see what\'s still in store.',
                    style: GoogleFonts.k2d(color: Colors.white, fontSize: 20),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.thumb_up_alt_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '232',
                            style: GoogleFonts.k2d(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.comment,
                            size: 25,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '2k',
                            style: GoogleFonts.k2d(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.share,
                            size: 25,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '20',
                            style: GoogleFonts.k2d(color: Colors.white),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          // Text(
                          //   '232',
                          //   style: GoogleFonts.k2d(color: Colors.white),
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
