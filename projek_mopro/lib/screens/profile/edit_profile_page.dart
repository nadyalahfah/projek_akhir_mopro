import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_data.dart';
import '../../services/firebase_service.dart';
import '../../utils/image_helper.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/snackbar_helper.dart';
import '../../utils/constants.dart';

class EditProfilePage extends StatefulWidget {
  final UserData user;
  const EditProfilePage({super.key, required this.user});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _f;
  late TextEditingController _n;
  File? _i;
  bool _l = false;
  final ImagePicker _pk = ImagePicker();

  @override
  void initState() {
    super.initState();
    _f = TextEditingController(text: widget.user.fullname);
    _n = TextEditingController(text: widget.user.nim);
  }

  Future _pic() async {
    final x = await _pk.pickImage(source: ImageSource.gallery);
    if (x != null) setState(() => _i = File(x.path));
  }

  void _save() async {
    setState(() => _l = true);
    final res = await FirebaseService.updateProfile(
        widget.user.id, _f.text, _n.text, _i);
    setState(() => _l = false);
    if (res['status'] == 'success') {
      UserData newUser = UserData(
        id: widget.user.id,
        email: widget.user.email,
        fullname: _f.text,
        role: widget.user.role,
        nim: _n.text,
        img: res['imgUrl'] ?? widget.user.img,
      );
      Navigator.pop(context, newUser);
      showSuccessSnackbar(context, "Profil diperbarui");
    } else {
      showErrorSnackbar(context, res['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pic,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _i != null
                    ? FileImage(_i!)
                    : getDynamicImage(widget.user.img),
                child: const Icon(Icons.camera_alt,
                    color: Colors.white54, size: 30),
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _f,
              label: "Nama Lengkap",
              icon: Icons.person,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _n,
              label: "NIM",
              icon: Icons.numbers,
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
                        "SIMPAN",
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
