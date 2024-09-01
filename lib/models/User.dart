import 'dart:convert';
import 'package:hiring_task/constants/FirestoreConstants.dart';
import 'package:hiring_task/constants/UserStatusConstant.dart';
import 'package:hiring_task/firebase/FIrebase.dart';

class UserData extends FirestoreDatabase {
  String? uid;
  String? name;
  String? email;
  UserStatus? status;

  UserData({
    this.uid,
    this.name,
    this.email,
    this.status,
  }) : super(collectionName: FirestoreConstants.users);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'status': UserStatusUtil.getIntFromStatus(status ?? UserStatus.Pending),
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'].toString(),
      name: map['name'] != null ? map['name'] as String : 'N/A',
      email: map['email'] != null ? map['email'] as String : 'N/A',
      status: map['status'] != null
          ? UserStatusUtil.getStatusTypeFromInt(map['status'] as int)
          : UserStatus.Approved,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromJson(String source) => UserData.fromMap(json.decode(source) as Map<String, dynamic>);
}
