import 'package:bizi/models/cart.dart';
import 'package:bizi/models/message.dart';
import 'package:bizi/models/noti.dart';
import 'package:bizi/models/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cuser {
  final String id;
  final String email;
  final String bio;
  final String town;
  final String phone;
  final String gender;
  final String profileImage;
  final String coverImage;
  final String dateOfBirth;
  final String username;
  final String job;
  final Message messages;
  final Notifs notis;
  final Store store;
  final Cart basket;
  Cuser(
      {this.email,
      this.bio,
      this.town,
      this.job,
      this.phone,
      this.gender,
      this.profileImage,
      this.coverImage,
      this.username,
      this.messages,
      this.notis,
      this.store,
      this.basket,
      this.id,
      this.dateOfBirth});
  factory Cuser.fromDocument(DocumentSnapshot doc) {
    return Cuser(
      email: doc['email'],
    );
  }
}
