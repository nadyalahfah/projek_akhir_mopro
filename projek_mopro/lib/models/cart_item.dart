class CartItem {
  final String id;
  final String nama;
  final String img;
  final int harga;
  int qty;
  final int maxStok;

  CartItem({required this.id, required this.nama, required this.img, required this.harga, this.qty = 1, required this.maxStok});
}
