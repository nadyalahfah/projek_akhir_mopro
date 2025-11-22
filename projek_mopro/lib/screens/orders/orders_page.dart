import 'package:flutter/material.dart';
import '../../models/user_data.dart';
import '../../models/order_model.dart';
import '../../services/firebase_service.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../widgets/snackbar_helper.dart';

class OrdersPage extends StatefulWidget {
  final UserData user;
  const OrdersPage({super.key, required this.user});
  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<OrderModel> _o = [];
  bool _l = true;

  @override
  void initState() {
    super.initState();
    _ref();
  }

  void _ref() async {
    setState(() => _l = true);
    var d = await FirebaseService.getOrders(userId: widget.user.id);
    setState(() {
      _o = d;
      _l = false;
    });
  }

  void _rate(String pid, String pname) {
    final c = TextEditingController();
    double r = 5.0;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, st) => AlertDialog(
          title: Text("Review $pname"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    icon: Icon(
                      i < r ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                    onPressed: () => st(() => r = i + 1.0),
                  ),
                ),
              ),
              TextField(
                controller: c,
                decoration: const InputDecoration(hintText: "Tulis ulasan..."),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseService.addReview(
                    pid, widget.user.id, widget.user.fullname, r, c.text);
                Navigator.pop(ctx);
                showSuccessSnackbar(context, "Terima kasih!");
              },
              child: const Text("Kirim"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusStepper(String status) {
    int step = 0;
    if (status == 'pending') step = 1;
    if (status == 'packed') step = 2;
    if (status == 'shipped') step = 3;
    if (status == 'completed') step = 4;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _stepItem("pending", step >= 1),
        _line(step >= 2),
        _stepItem("packed", step >= 2),
        _line(step >= 3),
        _stepItem("shipped", step >= 3),
        _line(step >= 4),
        _stepItem("delivered", step >= 4),
      ],
    );
  }

  Widget _stepItem(String label, bool active) {
    return Column(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: active ? Colors.orange : Colors.grey[300],
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: active ? Colors.black87 : Colors.grey,
          ),
        )
      ],
    );
  }

  Widget _line(bool active) {
    return Expanded(
      child: Container(
        height: 2,
        color: active ? Colors.orange : Colors.grey[300],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lacak Pesanan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _ref,
          )
        ],
      ),
      body: _l
          ? const Center(child: CircularProgressIndicator())
          : _o.isEmpty
              ? const Center(child: Text("Belum ada pesanan"))
              : ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: _o.length,
                  itemBuilder: (c, i) {
                    final x = _o[i];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order #${x.id.substring(0, 6)}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  x.date.length > 16
                                      ? x.date.substring(0, 16)
                                      : x.date,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            _buildStatusStepper(x.status),
                            const SizedBox(height: 20),
                            const Divider(),
                            const SizedBox(height: 10),
                            ...x.items.map((it) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          it['product_name'],
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Text(
                                        "${it['quantity']}x",
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total: ${formatRupiah(x.total)}",
                                  style: const TextStyle(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if (x.status == 'completed')
                                  TextButton(
                                    onPressed: () {
                                      // Review logic for first item for simplicity, or show dialog to pick item
                                      if (x.items.isNotEmpty) {
                                        _rate(x.items[0]['product_id'],
                                            x.items[0]['product_name']);
                                      }
                                    },
                                    child: const Text("Review"),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
