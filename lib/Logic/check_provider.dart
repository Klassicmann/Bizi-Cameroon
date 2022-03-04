import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CheckProvider extends ChangeNotifier {
  User _user = FirebaseAuth.instance.currentUser;
  get getUser => _user;
}
