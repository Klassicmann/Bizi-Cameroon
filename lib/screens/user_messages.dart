import 'dart:io';
import 'package:bizi/models/user.dart';
import 'package:bizi/screens/message.dart';
import 'package:bizi/widgets/funtions.dart';
import 'package:bizi/widgets/progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserMessages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String myemail = FirebaseAuth.instance.currentUser.email;
    return Container(
      color: Colors.grey[200],
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Progress();
          }
          final data = snapshot.data.docs;
          final _user = FirebaseAuth.instance.currentUser.email;
          // Get all messages that concerns the logged in user
          List allmess = [];
          data.forEach((mess) {
            if (mess['sender'] == _user || mess['receiver'] == _user) {
              allmess.add(mess);
            }
          });
          // Remove the ones that were sent by logged in users and received by him
          allmess.removeWhere((element) =>
              element['sender'] == _user && element['receiver'] == _user);

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return Progress();
              }

              // Get all the users that sent or receive the messages
              List messUsers = [];

              snapshot.data.docs.forEach((user) {
                allmess.forEach((elem) {
                  if (user['email'] == elem['sender'] ||
                      user['email'] == elem['receiver']) {
                    messUsers.add(user);
                  }
                });
              });

              messUsers.removeWhere((element) => element['email'] == _user);

              List cleaned = messUsers.toSet().toList();

              List<GestureDetector> fmess = cleaned.map((e) {
                List hisMessages = [];

                Cuser cuser = Cuser(
                  username: e['username'],
                  profileImage: e['photoUrl'],
                  email: e['email'],
                  phone: e['phone'],
                );

                allmess.forEach((mess) {
                  if ((mess['sender'] == _user &&
                          mess['receiver'] == e['email']) ||
                      (mess['sender'] == e['email'] &&
                          mess['receiver'] == _user)) {
                    hisMessages.add(mess);
                  }
                });

                List notSeenMessages = [];
                hisMessages.forEach((element) {
                  if (!element['seen']) {
                    if (element['sender'] != _user) {
                      notSeenMessages.add(element);
                    }
                  }
                });

                QueryDocumentSnapshot lastMessage;
                if (hisMessages != [] || hisMessages != null) {
                  lastMessage = hisMessages.first;
                }
                String lamess = lastMessage['message'].toString();
                Timestamp messagetime = lastMessage['time'];

                final time = DateTime.fromMicrosecondsSinceEpoch(
                    messagetime.microsecondsSinceEpoch);

                return GestureDetector(
                  onTap: () {
                    notSeenMessages.forEach((element) {
                      FirebaseFirestore.instance
                          .collection('messages')
                          .doc(element.id)
                          .update({'seen': true});
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SendMessage(
                                  cuser: cuser,
                                  myEmail: myemail,
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        // color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5)),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: e['photoUrl'] != ""
                            ? NetworkImage(e['photoUrl'])
                            : AssetImage('assets/static/bizi1.png'),
                        backgroundColor: Colors.black,
                      ),
                      title: Text(
                        e['username'],
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(lamess.length < 30
                          ? lamess
                          : lamess.substring(0, 30) + '...'),
                      trailing: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: notSeenMessages.length != 0
                                    ? Colors.red
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              notSeenMessages.length != 0
                                  ? notSeenMessages.length.toString()
                                  : '',
                              style: GoogleFonts.k2d(
                                  fontSize: 12, color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            checktime(time),
                            style: GoogleFonts.k2d(
                                fontSize: 12, color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList();

              return ListView(
                children: [
                  SizedBox(
                    height: 1,
                  ),
                  ...fmess
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// class MessageUser {
//   final QueryDocumentSnapshot theuser;
//   final List<QueryDocumentSnapshot> hismessages;

//   MessageUser({this.theuser, this.hismessages});

// }
