import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

class FirestoreDatabase {
  final String collectionName;

  late FirebaseFirestore _firebase;
  late CollectionReference collectionRef;
  late Logger logger;
  FirestoreDatabase({required this.collectionName}) {
    _firebase = FirebaseFirestore.instance;
    collectionRef = _firebase.collection(collectionName);
    logger = Logger();
  }

  Future<QuerySnapshot?> getRecords() async {
    try {
      QuerySnapshot data = await collectionRef.get();
      return data;
    } catch (err) {
      logger.e(err);
    }
    return null;
  }

  Future<DocumentSnapshot?> getRecordById({required id}) async {
    try {
      DocumentSnapshot data = await collectionRef.doc(id).get();
      return data;
    } catch (err) {
      logger.e(err);
    }
    return null;
  }

  Future<bool> createRecord({required data}) async {
    try {
      return await collectionRef.add(data).then((value) => true);
    } catch (err) {
      logger.e(err);
      return false;
    }
  }

  Future<bool> createRecordWithId({required data, required String id}) async {
    try {
      return await collectionRef.doc(id).set(data).then((value) => true);
    } catch (err) {
      logger.e(err);
      return false;
    }
  }

  Future<bool> updateRecord({required id, required data}) async {
    try {
      return await collectionRef.doc(id).update(data).then((value) => true);
    } catch (err) {
      logger.e(err);
      return false;
    }
  }

  Future<bool> deleteRecord({required id}) async {
    try {
      return await collectionRef.doc(id).delete().then((value) => true);
    } catch (err) {
      logger.e(err);
      return false;
    }
  }
}
