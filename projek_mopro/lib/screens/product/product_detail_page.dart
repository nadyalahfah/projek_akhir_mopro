import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/user_data.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/image_helper.dart';
import '../../widgets/star_rating.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final Function(Product) onAdd;
  final UserData user;
  const ProductDetailPage({super.key, required this.product, required this.onAdd, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: product.id,
                child: Image(
                  image: getDynamicImage(product.img),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.nama,
                            style: titleStyle.copyWith(fontSize: 24),
                          ),
                        ),
                        Text(
                          formatRupiah(product.harga),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        buildStarRating(product.rating, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          "${product.rating.toStringAsFixed(1)} (${product.reviews} Reviews)",
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person, size: 15, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Penjual: ${product.sellerName}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Deskripsi",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.deskripsi,
                      style: const TextStyle(color: textLight, height: 1.5),
                    ),
                    const SizedBox(height: 30),
                    if (user.role != 'penjual')
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: product.stok > 0 ? () {
                            onAdd(product);
                            Navigator.pop(context);
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: product.stok > 0 ? primaryColor : Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            product.stok > 0 ? "TAMBAH KE KERANJANG" : "STOK HABIS",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
