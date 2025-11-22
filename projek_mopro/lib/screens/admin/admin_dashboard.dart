import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_data.dart';
import '../../models/order_model.dart';
import '../../services/firebase_service.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../utils/image_helper.dart';
import '../../widgets/snackbar_helper.dart';
import '../auth/login_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _idx = 0;
  final List<Widget> _pages = [const AdminUserList(), const AdminOrderList()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showConfirmDialog(context, "Logout", "Keluar sebagai admin?",
                  () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              });
            },
          )
        ],
      ),
      body: _pages[_idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.people),
            label: "Users",
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: "Orders",
          )
        ],
      ),
    );
  }
}

class AdminUserList extends StatefulWidget {
  const AdminUserList({super.key});
  @override
  State<AdminUserList> createState() => _AdminUserListState();
}

class _AdminUserListState extends State<AdminUserList> {
  List<UserData> _u = [];
  bool _l = true;

  @override
  void initState() {
    super.initState();
    _ref();
  }

  void _ref() async {
    var d = await FirebaseService.getUsers();
    setState(() {
      _u = d;
      _l = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _l
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _u.length,
            itemBuilder: (c, i) => ListTile(
              leading: CircleAvatar(
                backgroundImage: getDynamicImage(_u[i].img),
              ),
              title: Text(_u[i].fullname),
              subtitle: Text("${_u[i].email} (${_u[i].role})"),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showConfirmDialog(context, "Hapus User",
                      "Hapus ${_u[i].fullname}?", () async {
                    await FirebaseService.deleteUser(_u[i].id);
                    _ref();
                  });
                },
              ),
            ),
          );
  }
}

class AdminOrderList extends StatefulWidget {
  const AdminOrderList({super.key});
  @override
  State<AdminOrderList> createState() => _AdminOrderListState();
}

class _AdminOrderListState extends State<AdminOrderList> {
  List<OrderModel> _o = [];
  bool _l = true;

  @override
  void initState() {
    super.initState();
    _ref();
  }

  void _ref() async {
    var d = await FirebaseService.getOrders();
    setState(() {
      _o = d;
      _l = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _l
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _o.length,
            itemBuilder: (c, i) {
              final x = _o[i];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ExpansionTile(
                  title: Text("Order #${x.id.substring(0, 8)}"),
                  subtitle: Text(
                      "${x.buyerName} - ${formatRupiah(x.total)}\nStatus: ${x.status}"),
                  children: [
                    ...x.items.map((it) => ListTile(
                          title: Text(it['product_name']),
                          subtitle: Text("${it['quantity']}x"),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await FirebaseService.updateOrderStatus(
                                  x.id, 'shipped');
                              _ref();
                            },
                            child: const Text("Kirim"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () async {
                              await FirebaseService.updateOrderStatus(
                                  x.id, 'completed');
                              _ref();
                            },
                            child: const Text("Selesai"),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
  }
}
