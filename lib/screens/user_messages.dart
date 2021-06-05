import 'package:bizi/models/message.dart';
import 'package:bizi/models/user.dart';
import 'package:bizi/screens/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_gifs/loading_gifs.dart';

class UserMessages extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('messages').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final data = snapshot.data.docs;
          List<Message> messages = [];
          List messageSenders = [];
          data.forEach((doc) {
            if (doc.data()['receiver'] ==
                FirebaseAuth.instance.currentUser.email) {
              Message message = Message(
                content: doc.data()['message'],
                sender: doc.data()['sender'],
                reciever: doc.data()['receiver'],
                time: doc.data()['time'],
              );
              if (!messageSenders.contains(doc.data()['sender'])) {
                messageSenders.add(doc.data()['sender']);
              }
              messages.add(message);
            }
          });

          return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                final snap = snapshot.data.docs;
                List<NewMessage> allMessages = [];
                DateTime time = DateTime.now();
                snap.forEach((user) {
                  messageSenders.forEach((mess) {
                    if (user.data()['email'] == mess) {
                      NewMessage newMessage = NewMessage(
                        image: user.data()['photoUrl'],
                        name: user.data()['username'],
                        time: '${time.hour} : ${time.minute}',
                        lastMessage: 'Last Message',
                        cuser: Cuser(username:user.data()['username'],
                          profileImage: user.data()['photoUrl'],
                          email: user.data()['email'],),
                      );

                      allMessages.add(newMessage);
                    }
                  });
                });

                return Container(
                  color: Colors.black45,
                  child: ListView(
                    children: allMessages.toSet().toList(),
                  ),
                );
              });
        });
  }
}

class NewMessage extends StatelessWidget {
  final String image;
  final String name;
  final String time;
  final String lastMessage;
  final Cuser cuser;

  NewMessage({this.image, this.name, this.time, this.lastMessage, this.cuser});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => SendMessage(cuser: cuser,))),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
        decoration: BoxDecoration(color: Theme.of(context).accentColor),
        child: ListTile(
          isThreeLine: true,
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/static/' + image),
          ),
          title: Text(name,
              style: GoogleFonts.k2d(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              )),
          subtitle: Text(
            lastMessage,
            style: GoogleFonts.k2d(color: Colors.white70),
          ),
          trailing: Text(
            time,
            style: GoogleFonts.k2d(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

//  // padding: EdgeInsets.all(5),
//             child: ListView(
//               children: [
//                 NewWidget(
//                   image: 'thinkstock-router-100569363-large.jpg',
//                   name: 'Mesongdo',
//                   time: '23 : 30',
//                   lastMessage:
//                       'Hey bro hope your home cause i will come at 10 am',
//                 ),
//                 // SizedBox(height: 20,),
//                 NewWidget(
//                   image: 'types-of-homes-hero.jpg',
//                   name: 'Vitruss',
//                   time: 'Yesterday',
//                   lastMessage: 'How much?',
//                 ),
//                 NewWidget(
//                   image: 'Max-R_Headshot (1).jpg',
//                   name: 'La kores njio',
//                   time: 'Yesterday',
//                   lastMessage: 'Yess mola',
//                 ),
//                 NewWidget(
//                   image: '8f35ba26fe296e36b3a96ee5416259b4.jpg',
//                   name: 'Pro',
//                   time: 'Yesterday',
//                   lastMessage:
//                       'Lambo v23 lk sj. Meilleur au Cameroon et dans l\'afrique central',
//                 ),
//                 NewWidget(
//                   image: '16x9_M.jpg',
//                   name: 'Land finder',
//                   time: 'Yesterday',
//                   lastMessage: 'Where are the bills?',
//                 ),
//                 NewWidget(
//                   image: 'Best-android-smartphones-in-nigeria.jpeg',
//                   name: 'Ancien phone',
//                   time: '5 hours ago',
//                   lastMessage: 'Bring 339300 Fcfa take sa',
//                 ),
//                 NewWidget(
//                   image: 'Best-android-smartphones-in-nigeria.jpeg',
//                   name: 'Ancien phone',
//                   time: '5 hours ago',
//                   lastMessage: 'Bring 339300 Fcfa take sa',
//                 ),
//               ],
//             ), // padding: EdgeInsets.all(5),
//             child: ListView(
//               children: [
//                 NewWidget(
//                   image: 'thinkstock-router-100569363-large.jpg',
//                   name: 'Mesongdo',
//                   time: '23 : 30',
//                   lastMessage:
//                       'Hey bro hope your home cause i will come at 10 am',
//                 ),
//                 // SizedBox(height: 20,),
//                 NewWidget(
//                   image: 'types-of-homes-hero.jpg',
//                   name: 'Vitruss',
//                   time: 'Yesterday',
//                   lastMessage: 'How much?',
//                 ),
//                 NewWidget(
//                   image: 'Max-R_Headshot (1).jpg',
//                   name: 'La kores njio',
//                   time: 'Yesterday',
//                   lastMessage: 'Yess mola',
//                 ),
//                 NewWidget(
//                   image: '8f35ba26fe296e36b3a96ee5416259b4.jpg',
//                   name: 'Pro',
//                   time: 'Yesterday',
//                   lastMessage:
//                       'Lambo v23 lk sj. Meilleur au Cameroon et dans l\'afrique central',
//                 ),
//                 NewWidget(
//                   image: '16x9_M.jpg',
//                   name: 'Land finder',
//                   time: 'Yesterday',
//                   lastMessage: 'Where are the bills?',
//                 ),
//                 NewWidget(
//                   image: 'Best-android-smartphones-in-nigeria.jpeg',
//                   name: 'Ancien phone',
//                   time: '5 hours ago',
//                   lastMessage: 'Bring 339300 Fcfa take sa',
//                 ),
//                 NewWidget(
//                   image: 'Best-android-smartphones-in-nigeria.jpeg',
//                   name: 'Ancien phone',
//                   time: '5 hours ago',
//                   lastMessage: 'Bring 339300 Fcfa take sa',
//                 ),
//               ],
//             ),
