import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String type;
  final String title;
  final String town;
  final String desc;
  final DocumentReference reference;
  final int price;
  final List<dynamic> images;
  final String image;
  final String gender;
  final DocumentReference postedBy;
  final String articleId;
  Article(
      {this.postedBy,
      this.type,
      this.title,
      this.town,
      this.desc,
      this.reference,
      this.price,
      this.images,
      this.image,
      this.gender,
      this.articleId});
}

// class User {
//   final String name;
//   final int numb;

//   User({this.name, this.numb});
// }

// List<User> users = [
//   User(name: 'Paul', numb: 654118518),
//   User(name: 'Peter', numb: 6553418518),
//   User(name: 'Raul', numb: 6575438518),

// ];
