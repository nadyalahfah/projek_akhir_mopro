import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String userId;
  final String buyerName;
  final int total;
  final String status;
  final String date;
  final List<Map<String, dynamic>> items;

  OrderModel({required this.id, required this.userId, required this.buyerName, required this.total, required this.status, required this.date, required this.items});

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      userId: data['user_id'] ?? '',
      buyerName: data['buyer_name'] ?? '',
      total: data['total_price'] ?? 0,
      status: data['status'] ?? 'pending',
      date: (data['created_at'] as Timestamp).toDate().toString(),
      items: List<Map<String, dynamic>>.from(data['items'] ?? []),
    );
  }
}
