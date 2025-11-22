import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String nama;
  final String kategori;
  final int harga;
  final int stok;
  final String img;
  final String deskripsi;
  final double rating;
  final int reviews;
  final String sellerId;
  final String sellerName;

  Product({required this.id, required this.nama, required this.kategori, required this.harga, required this.stok, required this.img, required this.deskripsi, this.rating = 0.0, this.reviews = 0, required this.sellerId, required this.sellerName});

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      nama: data['nama'] ?? '',
      kategori: data['kategori'] ?? '',
      harga: data['harga'] ?? 0,
      stok: data['stok'] ?? 0,
      img: data['img'] ?? '',
      deskripsi: data['deskripsi'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      reviews: data['reviews'] ?? 0,
      sellerId: data['seller_id'] ?? '',
      sellerName: data['seller_name'] ?? '',
    );
  }
}
