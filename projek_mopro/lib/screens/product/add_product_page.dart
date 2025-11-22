import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_data.dart';
import '../../services/firebase_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/snackbar_helper.dart';
import '../../utils/constants.dart';

class AddProductPage extends StatefulWidget {
  final UserData user;
  const AddProductPage({super.key, required this.user});
  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _n = TextEditingController();
  final _h = TextEditingController();
  final _s = TextEditingController();
  final _d = TextEditingController();
  String _k = 'Elektronik';
  File? _i;
  bool _l = false;
  final ImagePicker _pk = ImagePicker();

  Future _pic() async {
    final x = await _pk.pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => _i = File(x.path));
  }

  void _save() async {
    if (_n.text.isEmpty || _h.text.isEmpty || _s.text.isEmpty) {
      showErrorSnackbar(context, "Lengkapi data");
      return;
    }
    setState(() => _l = true);
    bool ok = await FirebaseService.addProduct(
      _n.text,
      _k,
      _h.text,
      _s.text,
      _d.text,
      _i,
      widget.user.id,
      widget.user.fullname,
    );
    setState(() => _l = false);
    if (ok) {
      Navigator.pop(context);
      showSuccessSnackbar(context, "Produk ditambahkan");
    } else {
      showErrorSnackbar(context, "Gagal menambah produk");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Produk")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pic,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                  image: _i != null
                      ? DecorationImage(image: FileImage(_i!), fit: BoxFit.cover)
                      : null,
                ),
                child: _i == null
                    ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _n,
              label: "Nama Produk",
              icon: Icons.shopping_bag,
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField(
              value: _k,
              items: ['Elektronik', 'Pakaian', 'Buku']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _k = v.toString()),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                labelText: "Kategori",
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _h,
                    label: "Harga",
                    icon: Icons.attach_money,
                    type: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: CustomTextField(
                    controller: _s,
                    label: "Stok",
                    icon: Icons.inventory,
                    type: TextInputType.number,
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _d,
              label: "Deskripsi",
              icon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _l ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                child: _l
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "UPLOAD PRODUK",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
