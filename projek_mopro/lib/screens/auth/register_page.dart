import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/firebase_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/snackbar_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _nimController = TextEditingController();
  
  String _role = 'customer';
  File? _imageFile;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  void _register() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _fullnameController.text.isEmpty) {
      showErrorSnackbar(context, "Mohon lengkapi data wajib");
      return;
    }

    setState(() => _isLoading = true);
    
    final res = await FirebaseService.register(
      _emailController.text,
      _passwordController.text,
      _role,
      _fullnameController.text,
      _nimController.text,
      _imageFile,
    );
    
    setState(() => _isLoading = false);

    if (res['status'] == 'success') {
      if (!mounted) return;
      showSuccessSnackbar(context, "Registrasi Berhasil! Silakan Login");
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      showErrorSnackbar(context, res['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create Account"),
        backgroundColor: Colors.white,
        foregroundColor: textDark,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: backgroundColor,
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? const Icon(Icons.camera_alt, size: 40, color: textLight)
                        : null,
                  ),
                  if (_imageFile != null)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text("Upload Profile Picture", style: TextStyle(color: textLight)),
            const SizedBox(height: 30),
            CustomTextField(
              controller: _fullnameController,
              label: "Full Name",
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _emailController,
              label: "Email Address",
              icon: Icons.email_outlined,
              type: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _passwordController,
              label: "Password",
              icon: Icons.lock_outline,
              isPassword: true,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: _nimController,
              label: "NIM (Optional)",
              icon: Icons.numbers,
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _role,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: primaryColor),
                  items: const [
                    DropdownMenuItem(value: 'customer', child: Text("Customer (Buyer)")),
                    DropdownMenuItem(value: 'penjual', child: Text("Seller (Penjual)")),
                  ],
                  onChanged: (v) => setState(() => _role = v.toString()),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "REGISTER",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
