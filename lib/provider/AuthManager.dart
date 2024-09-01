import 'package:hiring_task/constants/FirestoreConstants.dart';
import 'package:hiring_task/models/User.dart';
import 'package:hiring_task/router/RouteConstants.dart';
import 'package:hiring_task/widgets/ProgressHud.dart';
import 'package:hiring_task/widgets/Snackbar.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:localstorage/localstorage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Status {
  notLoggedIn,
  loggedIn,
  authenticating,
}

class AuthManager extends ChangeNotifier {
  Logger l = Logger();
  String currentPage = '/';

  UserData _user = UserData();
  Status _loggedInStatus = Status.authenticating;

  UserData get getCurrentUser => _user;
  Status get loggedInStatus => _loggedInStatus;

  set user(UserData u) {
    _user = u;
    notifyListeners();
  }

  late Logger logger;

  void setloggedInStatus(Status status) {
    _loggedInStatus = status;
    l.d('Auth State Changed Notifiying Listners [Status: $_loggedInStatus]');
    notifyListeners();
  }

  AuthManager() {
    logger = Logger();
    getUser();
  }

  Future<UserData> fetchUserData(String uid) async {
    UserData user = UserData();

    DocumentSnapshot? result = await user.getRecordById(id: uid);
    if (result != null) {
      user = UserData.fromJson(result.data().toString());
    } else {
      user = UserData(uid: uid, email: user.email, name: user.name);
    }
    return user;
  }

  Future<void> saveUser(UserData user) async {
    localStorage.setItem('user', user.toJson());
    _user = user;
  }

  Future<void> getUser() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await Future.delayed(const Duration(seconds: 2));
    try {
      if (firebaseAuth.currentUser?.uid != null) {
        final String user = localStorage.getItem('user').toString();
        if (user != 'null') {
          _user = UserData.fromJson(user);
          setloggedInStatus(Status.loggedIn);
        } else {
          setloggedInStatus(Status.notLoggedIn);
        }
      } else {
        setloggedInStatus(Status.notLoggedIn);
      }
      notifyListeners();
    } catch (e) {
      logger.e(e);
      setloggedInStatus(Status.notLoggedIn);
      await Future.delayed(const Duration(seconds: 2));
      notifyListeners();
    }
  }

  performSignIn(BuildContext context) async {
    bool isOldUser = false;
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uid = auth.currentUser?.uid;
    DocumentSnapshot? userDoc;
    CollectionReference firestore = FirebaseFirestore.instance.collection(FirestoreConstants.users);
    if (uid != null) {
      _user = UserData(
        uid: auth.currentUser!.uid,
        email: auth.currentUser?.email,
        name: auth.currentUser?.displayName,
      );
      userDoc = await firestore.doc(uid).get();
      isOldUser = userDoc.exists;
    }
    if (context.mounted) {
      if (!isOldUser) {
        await firestore.doc(uid).set(_user.toMap());
        await saveUser(getCurrentUser);
        setloggedInStatus(Status.loggedIn);
        if (context.mounted) {
          context.pop();
          context.go(RouteConstants.dashboardPath);
        }
      } else if (isOldUser) {
        _user = UserData.fromMap(userDoc!.data() as Map<String, dynamic>);
        await saveUser(getCurrentUser);
        setloggedInStatus(Status.loggedIn);
        if (context.mounted) {
          context.pop();
          context.go(RouteConstants.dashboardPath);
        }
      }
    }
  }

  Future<void> signinWithEmailWithPassword(String email, String password, BuildContext context) async {
    showLoadingHUD(context);
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      if (context.mounted) performSignIn(context);
    } catch (e) {
      if (context.mounted) {
        context.pop();
        showSnacBar(context, content: e.toString().split('] ')[1]);
      }
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password, BuildContext context) async {
    showLoadingHUD(context);
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      if (context.mounted) performSignIn(context);
    } catch (e) {
      if (context.mounted) {
        showSnacBar(context, content: e.toString().split('] ')[1]);
        context.pop();
      }
    }
  }

  bool isLoggedIn() {
    return FirebaseAuth.instance.currentUser?.uid != null;
  }
}
