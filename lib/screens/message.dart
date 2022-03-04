import 'package:bizi/login/form_feild.dart';
import 'package:bizi/models/message.dart';
import 'package:bizi/models/user.dart';
import 'package:bizi/screens/full_image.dart';
import 'package:bizi/widgets/funtions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:google_fonts/google_fonts.dart';

class SendMessage extends StatefulWidget {
  final Cuser cuser;
  final String myEmail;
  SendMessage({this.cuser, this.myEmail});

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  String message;

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FirebaseFirestore.instance.collection('messages').get().then((value) {
          value.docs.forEach((e) {
            if ((e['sender'] == widget.cuser.email &&
                    e['receiver'] == widget.myEmail) ||
                (e['sender'] == widget.myEmail &&
                    e['receiver'] == widget.cuser.email)) {
              if (!e['seen']) {
                FirebaseFirestore.instance
                    .collection('messages')
                    .doc(e.id)
                    .update({'seen': true});
              }
            }
          });
        });
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            backgroundColor: Theme.of(context).primaryColor,
            title: Container(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cuser.username,
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.k2d(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '',
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.k2d(
                        fontSize: 13,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            elevation: 20,
            leadingWidth: 110,
            actions: [
              GestureDetector(
                onTap: () {
                  // FirebaseAuth.instance.signOut();
                },
                child: Container(
                  margin: EdgeInsets.only(right: 25),
                  child: Icon(
                    Icons.call,
                    size: 30,
                  ),
                ),
              )
            ],
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back)),
                SizedBox(
                  width: 15,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    decoration: BoxDecoration(),
                    child: CircleAvatar(
                      backgroundImage: widget.cuser.profileImage != null
                          ? NetworkImage(widget.cuser.profileImage)
                          : AssetImage('assets/static/bizi1.png'),
                      radius: 26,
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              Image(
                image: AssetImage('assets/static/eLOXPz.png'),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Messages(
                      sender: widget.cuser,
                    ),
                    Container(
                      color: Colors.black54,
                      child: Row(
                        children: [
                          Container(
                            child: Expanded(
                              child: TextField(
                                controller: messageController,
                                style: GoogleFonts.k2d(
                                    color: Colors.white, fontSize: 19),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  border: InputBorder.none,
                                  hintText: 'Type message here...',
                                  hintStyle: GoogleFonts.k2d(
                                      fontSize: 18, color: Colors.white60),
                                  prefixIcon: Icon(
                                    Icons.emoji_emotions,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.attachment,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    message = val;
                                  });
                                },
                              ),
                            ),
                            // decoration: BoxDecoration(),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await FirebaseFirestore.instance
                                  .collection('messages')
                                  .add({
                                'document': '',
                                'image': '',
                                'images': [],
                                'message': message,
                                'sender':
                                    FirebaseAuth.instance.currentUser.email,
                                'receiver': widget.cuser.email,
                                'time': Timestamp.now(),
                                'status': false,
                                'seen': false
                              });
                              messageController.clear();
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Icon(
                                Icons.send,
                                size: 23,
                                color: Colors.white,
                              ),
                              margin: EdgeInsets.only(bottom: 5, right: 5),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(40)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ],
          )),
    );
  }
}

class Messages extends StatelessWidget {
  final Cuser sender;
  Messages({this.sender});
  @override
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;

    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('messages')
              .orderBy('time', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final snaps = snapshot.data.docs;

            List<Message> messages = [];

            snaps.forEach((doc) {
              if ((doc.data()['sender'] == sender.email &&
                      doc.data()['receiver'] == user.email) ||
                  (doc.data()['sender'] == user.email &&
                      doc.data()['receiver'] == sender.email)) {
                Message message = Message(
                    content: doc.data()['message'],
                    sender: doc.data()['sender'],
                    reciever: doc.data()['receiver'],
                    time: doc.data()['time'],
                    document: doc.data()['document'],
                    image: doc.data()['image'],
                    images: doc.data()['images'],
                    id: doc.id);
                messages.add(message);
              }
            });
            List<Widget> content = messages.map((message) {
              bool isMe = user.email == message.sender;
              DateTime time = DateTime.fromMicrosecondsSinceEpoch(
                  message.time.microsecondsSinceEpoch);
              return Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Dismissible(
                    key: ObjectKey(snapshot.data.docs
                        .elementAt(messages.indexOf(message))),
                    onDismissed: (direction) async {
                      await FirebaseFirestore.instance
                          .collection('messages')
                          .doc(message.id)
                          .delete()
                          .catchError((e) {
                        print(e);
                      });
                    },
                    child: ChatBubble(
                      shadowColor: Colors.black38,
                      margin: EdgeInsets.only(
                          top: 5, bottom: 7, left: 7, right: 10),
                      backGroundColor: isMe
                          ? Theme.of(context).primaryColor.withOpacity(0.8)
                          : Colors.grey[200],
                      clipper: ChatBubbleClipper1(
                          type: isMe
                              ? BubbleType.sendBubble
                              : BubbleType.receiverBubble),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    message.image != ''
                                        ? GestureDetector(
                                            onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullImage(
                                                            id: 1,
                                                            image: message
                                                                .image))),
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 3),
                                                child: Image(
                                                  image: NetworkImage(
                                                    message.image,
                                                  ),
                                                  height: 240,
                                                  width: 240,
                                                )),
                                          )
                                        : Container(),
                                    Container(
                                      constraints:
                                          BoxConstraints(maxWidth: 280),
                                      child: Text(
                                        message.content,
                                        overflow: TextOverflow.clip,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.k2d(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black87),
                                      ),
                                    ),
                                  ],
                                ),
                                // isMe
                                //     ? Padding(
                                //         padding: EdgeInsets.all(10),
                                //         child: Row(
                                //           children: [
                                //             Icon(
                                //               Icons.check,
                                //               size: 15,
                                //               color: Colors.green,
                                //             ),
                                //             Icon(
                                //               Icons.check,
                                //               size: 15,
                                //               color: Colors.green,
                                //             ),
                                //           ],
                                //         ),
                                //       )
                                //     : Container(),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.timelapse_rounded,
                                    size: 13,
                                    color:
                                        isMe ? Colors.white : Colors.black87),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  checktime(time),
                                  style: GoogleFonts.k2d(
                                      fontSize: 11,
                                      color:
                                          isMe ? Colors.white : Colors.black87),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList();
            content.reversed;

            return ListView.builder(
              reverse: true,
              itemCount: content.length,
              itemBuilder: (BuildContext context, int index) {
                return content[index];
              },
            );
          }),
    );
  }
}

class SendMessageWidget extends StatefulWidget {
  final String message;
  SendMessageWidget({this.message});

  @override
  _SendMessageWidgetState createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  String content;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
              // color: Colors.red,
              child: Expanded(
            child: InputField(
              prefixIcon: Icons.emoji_emotions,
              hint: 'Enter message',
              onChange: (val) {
                setState(() {
                  content = val;
                });
              },
            ),
          )),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(15),
              child: Icon(
                Icons.send,
                size: 23,
                color: Colors.white,
              ),
              margin: EdgeInsets.only(bottom: 5, right: 5),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(40)),
            ),
          ),
        ],
      ),
    );
  }
}
