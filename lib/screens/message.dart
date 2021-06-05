import 'package:bizi/login/change_password.dart';
import 'package:bizi/login/form_feild.dart';
import 'package:bizi/models/message.dart';
import 'package:bizi/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:google_fonts/google_fonts.dart';

class SendMessage extends StatefulWidget {
  final Cuser cuser;
  SendMessage({this.cuser});

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  String message;

  final messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'active 4h ago',
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
                  child: Image(
                    image: NetworkImage(widget.cuser.profileImage),
                    fit: BoxFit.cover,
                    width: 50,
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
                          child: InputField(
                            chat: true,
                            controller: messageController,
                            prefixIcon: Icons.emoji_emotions,
                            hint: 'write message ...',
                            onChange: (val) {
                              setState(() {
                                message = val;
                              });
                            },
                            suffixIcon: Icons.attachment_outlined,
                          ),
                        )),
                        Container(
                          child: IconButton(
                              icon: Icon(Icons.attachment), onPressed: () {}),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () async {
                            await FirebaseFirestore.instance
                                .collection('messages')
                                .add({
                              'message': message,
                              'sender': FirebaseAuth.instance.currentUser.email,
                              'receiver': widget.cuser.email,
                              'time': Timestamp.now()
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
        ));
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
                );
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
                ChatBubble(

                  shadowColor: Colors.black38,
                  margin: EdgeInsets.only(top:5, bottom: 10, left: 10, right: 10 ),
                  backGroundColor: isMe ? Theme.of(context).accentColor.withOpacity(0.9) : Colors.grey[200],
                  clipper: ChatBubbleClipper1(type: isMe? BubbleType.sendBubble : BubbleType.receiverBubble),

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
                                  Container(

                                    constraints: BoxConstraints(maxWidth: 300),
                                    child: Text(

                                      message.content,
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.k2d(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: isMe? Colors.white : Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                              isMe
                                  ? Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.check,
                                            size: 15,
                                            color: Colors.green,
                                          ),
                                          Icon(
                                            Icons.check,
                                            size: 15,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.timelapse_rounded,
                                size: 13,
                                color: isMe? Colors.white : Colors.black87
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '${time.hour + 1} : ${time.minute}',
                                style: GoogleFonts.k2d(fontSize: 11,color: isMe? Colors.white : Colors.black87),
                              ),
                            ],
                          ),
                        ],
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
    return 
    Container(
      child: Row(
        children: [
          Container(
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
