import 'package:bizi/screens/item_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Items extends StatelessWidget {
  final String id;
  final String image;
  final String title;
  final String desc;
  final int price;
  final String location;
  final Function tap;
  final DocumentReference reference;
  final String loggedUserId;
  Items(
      {this.id,
      this.title,
      this.desc,
      this.price,
      this.location,
      this.user,
      this.reference,
      this.image,
      this.tap,
      this.loggedUserId});

  final DocumentReference user;

  Widget build(BuildContext context) {
    // print(loggedUserId);
    return FutureBuilder<DocumentSnapshot>(
        future: user.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
                color: Colors.green,
              ),
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
                          reference: reference,
                          usrId: loggedUserId)));
            },
            child: Container(
              // padding: EdgeInsets.all(5),
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                vertical: 1,
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(5)),
                    child: Container(
                        color: Colors.white,
                        width: double.infinity,
                        height: 100,
                        constraints: BoxConstraints(maxHeight: 160),
                        child: Image(
                          image: NetworkImage(image),
                          // height: 200,
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBox(
                    height: 3,
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
                              color: Colors.orangeAccent[400],
                            )),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          margin: EdgeInsets.only(right: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // desc != null
                              //     ? Text(desc,
                              //         overflow: TextOverflow.clip,
                              //         style: GoogleFonts.k2d(
                              //           fontSize: 13,
                              //           fontWeight: FontWeight.w600,
                              //           color: Colors.black87,
                              //         ))
                              //     : Container(),
                              SizedBox(
                                height: 1,
                              ),
                              Text('$price FCFA',
                                  overflow: TextOverflow.clip,
                                  style: GoogleFonts.k2d(
                                      fontSize: 12,
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
                                  // Container(
                                  //   padding: EdgeInsets.all(0.2),
                                  //   child: Icon(
                                  //     Icons.add,
                                  //     color: Colors.white,
                                  //   ),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.orange,
                                  //       borderRadius:
                                  //           BorderRadius.circular(20)),
                                  // )
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
