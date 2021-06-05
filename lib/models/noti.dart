import 'package:cloud_firestore/cloud_firestore.dart';

class Notifs {
  final QueryDocumentSnapshot id;
  final String content;
  final Timestamp time;
  Notifs({
    this.id,
    this.content,
    this.time,
  });
}
