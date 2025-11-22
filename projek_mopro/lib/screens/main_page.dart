import 'package:flutter/material.dart';
import '../models/user_data.dart';
import '../models/cart_item.dart';
import 'home/home_page.dart';
import 'cart/cart_page.dart';
import 'orders/orders_page.dart';
import 'profile/profile_page.dart';

class MainPage extends StatefulWidget {
  final UserData user;
  const MainPage({super.key, required this.user});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _idx = 0;
  late UserData _currentUser;
  List<CartItem> globalCart = [];

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  void _updateUser(UserData newUser) {
    setState(() => _currentUser = newUser);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(user: _currentUser, cart: globalCart),
      CartPage(user: _currentUser, cart: globalCart),
      OrdersPage(user: _currentUser),
      ProfilePage(user: _currentUser, onUpdateProfile: _updateUser)
    ];
    return Scaffold(
      body: pages[_idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (i) => setState(() => _idx = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping),
            label: "Orders",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Profile",
          )
        ],
      ),
    );
  }
}
