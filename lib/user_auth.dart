import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status { unlogin, login }

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.unlogin;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Status get status => _status;
  User get user => _user;


  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.login;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.unlogin;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.unlogin;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unlogin;
    } else {
      _user = firebaseUser;
      _status = Status.login;
    }
    notifyListeners();
  }

  // //
  //
  //
  // Stream<String> get onAuthStateChanged =>
  //     _auth.authStateChanges().map(
  //           (User user) => user?.uid,
  //     );
  //
  // // GET UID
  // Future<String> getCurrentUID() async {
  //   return (await _auth.currentUser).uid;
  // }
  //
  // // GET CURRENT USER
  // Future getCurrentUser() async {
  //   return await _auth.currentUser;
  // }
  //
  //
  //
  // //


}