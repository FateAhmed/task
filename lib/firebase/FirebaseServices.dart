import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hiring_task/constants/FirestoreConstants.dart';
import 'package:hiring_task/models/RentalItem.dart';
import 'package:hiring_task/models/User.dart';

class FirebaseStreamService {
  late FirebaseFirestore _firestore;
  late FirebaseAuth _auth;
  FirebaseStreamService() {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
  }
  Stream<List<EventItem>> readEvents() => _firestore
      .collection(FirestoreConstants.events)
      .where('createdBy', isEqualTo: _auth.currentUser?.uid ?? 'none')
      .snapshots()
      .map((event) => event.docs.map((e) => EventItem.fromMap(e)).toList());

  Stream<List<UserData>> readUsers() => _firestore
      .collection(FirestoreConstants.users)
      .snapshots()
      .map((event) => event.docs.map((e) => UserData.fromMap(e.data())).toList());
}
