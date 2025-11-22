import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String id;
  final String email;
  final String fullname;
  final String role;
  final String nim;
  final String img;

  UserData({required this.id, required this.email, required this.fullname, required this.role, required this.nim, required this.img});

  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserData(
      id: doc.id,
      email: data['email'] ?? '',
      fullname: data['fullname'] ?? '',
      role: data['role'] ?? 'customer',
      nim: data['nim'] ?? '',
      img: data['img'] ?? '',
    );
  }
  
  factory UserData.fromMap(Map<String, dynamic> map) {
      return UserData(id: map['id'], email: map['email'], fullname: map['fullname'], role: map['role'], nim: map['nim'], img: map['img']);
  }
}
